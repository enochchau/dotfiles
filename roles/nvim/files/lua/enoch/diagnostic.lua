local api = vim.api
local ns_id = vim.api.nvim_create_namespace("CustomDiagnostic")

---@type vim.diagnostic.Opts.Signs
vim.diagnostic.config({
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ", -- x000f015a
            [vim.diagnostic.severity.WARN] = "󰀪 ", -- x000f002a
            [vim.diagnostic.severity.INFO] = "󰋽 ", -- x000f02fd
            [vim.diagnostic.severity.HINT] = "󰌶 ", -- x000f0336
        },
    },
})

-- Variable to hold the ID of the floating window
local diagnostic_win_id = nil
local diagnostic_buf_id = nil

local manage_diag_win =
    api.nvim_create_augroup("ManageDiagnosticWindow", { clear = true })
local last_win = nil

-- Autocommand to close the diagnostic window when the cursor moves
api.nvim_create_autocmd("WinEnter", {
    group = manage_diag_win,
    callback = function()
        local current_win_id = vim.api.nvim_get_current_win()
        if
            last_win
            and last_win == diagnostic_win_id
            and current_win_id
            and current_win_id ~= diagnostic_win_id
            and diagnostic_win_id
            and api.nvim_win_is_valid(diagnostic_win_id)
        then
            api.nvim_win_close(diagnostic_win_id, true)
            diagnostic_win_id = nil
            diagnostic_buf_id = nil
        end

        last_win = current_win_id
    end,
})

---@type table<vim.diagnostic.Severity,string>|nil
local default_icon_map

---get the default icon map from vim.diagnostic.severity
---@return table<vim.diagnostic.Severity,string>
local function get_default_icon_map()
    if default_icon_map then
        return default_icon_map
    end

    local icon_map = {}
    for k, v in pairs(vim.diagnostic.severity) do
        if string.len(k) == 1 and type(v) == "number" then
            icon_map[v] = k .. " "
        end
    end

    default_icon_map = icon_map
    return icon_map
end

-- Daemon State
local daemon_job = nil
local request_cache = {}
local req_id = 0

local function ensure_daemon()
    if daemon_job then
        return daemon_job
    end

    local scriptname = debug.getinfo(1).source:match("@?(.*/)")
        .. "../../nvim-pretty-ts-errors/out.js"

    daemon_job = vim.fn.jobstart({ "node", scriptname, "--daemon" }, {
        on_stdout = function(_, data, _)
            for _, line in ipairs(data) do
                if line ~= "" then
                    local ok, res = pcall(vim.json.decode, line)
                    if ok and res.id then
                        request_cache[res.id] = res.result
                    end
                end
            end
        end,
        on_exit = function()
            daemon_job = nil
            request_cache = {}
        end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            if daemon_job then
                vim.fn.jobstop(daemon_job)
            end
        end,
    })

    return daemon_job
end

local function format_diagnostic_daemon(message)
    ensure_daemon()
    if not daemon_job then
        return message
    end

    req_id = req_id + 1
    local current_id = req_id

    -- Encode and send
    local payload = vim.json.encode({ id = current_id, message = message })
    vim.fn.chansend(daemon_job, payload .. "\n")

    -- Wait synchronously (up to 200ms - formatting should be fast)
    local ok = vim.wait(200, function()
        return request_cache[current_id] ~= nil
    end)

    if ok then
        local res = request_cache[current_id]
        request_cache[current_id] = nil -- cleanup
        return res
    else
        -- Timeout or error
        return message
    end
end

--- Formats a single diagnostic into a Markdown string.
--- @param diagnostic table The diagnostic object.
--- @return table<string> The formatted diagnostic string.
local function format_diagnostic(diagnostic)
    local source = diagnostic.source or "nvim"
    local message = diagnostic.message
    if source == "typescript" then
        local ok, formatted = pcall(vim.fn.PrettyTsFormat, message)
        if ok and formatted then
            message = formatted
        else
            print(">>Falling back to deamon!!!")
            message = format_diagnostic_daemon(message)
        end
    end
    local message_lines = vim.split(message, "\n")
    local code = diagnostic.code

    local icon_map
    local diag_config = vim.diagnostic.config()
    if
        diag_config
        and type(diag_config.signs) == "table"
        and type(diag_config.signs.text) == "table"
    then
        icon_map = vim.diagnostic.config().signs.text
    else
        icon_map = get_default_icon_map()
    end

    local icon = icon_map[diagnostic.severity]

    local first = string.format("%s%s", icon, source)
    if code ~= nil then
        first = first .. string.format("(%s)", code)
    end

    local lines = { first }
    for i = 1, #message_lines do
        table.insert(lines, message_lines[i])
    end

    -- Simple Markdown formatting
    return lines
end

---@return string|nil
local function severity_to_hlgroup(severity)
    if severity == vim.diagnostic.severity.ERROR then
        return "DiagnosticSignError"
    elseif severity == vim.diagnostic.severity.HINT then
        return "DiagnosticSignHint"
    elseif severity == vim.diagnostic.severity.WARN then
        return "DiagnosticSignWarn"
    elseif severity == vim.diagnostic.severity.INFO then
        return "DiagnosticSignInfo"
    end
end

--- Gets all diagnostics for the current line.
--- @return table<string>, table A list of formatted diagnostic strings, or an empty list if none found.
local function get_diagnostics_for_current_line()
    local bufnr = api.nvim_get_current_buf()
    local cursor_row = api.nvim_win_get_cursor(0)[1]
    -- vim.diagnostic.get with lnum gets all diagnostics on that line
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_row - 1 }) -- lnum is 0-indexed in API

    local line_count = 0

    local hl_positions = {}

    ---@type table<string>
    local formatted_diagnostics = {}
    for _, diag in ipairs(diagnostics) do
        for i, line in ipairs(format_diagnostic(diag)) do
            table.insert(formatted_diagnostics, line)
            if i == 1 then
                local hl_group = severity_to_hlgroup(diag.severity)
                if hl_group then
                    table.insert(hl_positions, {
                        hl_group,
                        { line_count, 0 },
                        { line_count, 1 },
                    })
                    table.insert(hl_positions, {
                        "Bold",
                        { line_count, 1 },
                        { line_count, #line }
                    })
                end
            end
            line_count = line_count + 1
        end
    end

    return formatted_diagnostics, hl_positions
end

local function get_window_size(lines)
    local height = #lines
    local width = 0

    for _, line in ipairs(lines) do
        -- Using vim.fn.strdisplaywidth accounts for tabs/multibyte chars
        local line_width = vim.fn.strdisplaywidth(line)
        if line_width > width then
            width = line_width
        end
    end

    return width, height
end

--- Creates and displays a floating diagnostic window at the cursor with all diagnostics for the current line.
local function show_line_diagnostics()
    -- Close existing window if it exists
    if diagnostic_win_id and api.nvim_win_is_valid(diagnostic_win_id) then
        api.nvim_win_close(diagnostic_win_id, true)
        diagnostic_win_id = nil
        diagnostic_buf_id = nil
    end

    -- Create a new scratch buffer
    local buf = api.nvim_create_buf(false, true)
    diagnostic_buf_id = buf

    local diagnostic_messages, hl_positions = get_diagnostics_for_current_line()

    -- Do nothing if no diagnostics on the line
    if #diagnostic_messages == 0 then
        return
    end



    local lines = diagnostic_messages

    -- Set the content of the buffer
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    for _, hl_pos in ipairs(hl_positions) do
        vim.hl.range(buf, ns_id, hl_pos[1], hl_pos[2], hl_pos[3])
    end

    local width, height = get_window_size(lines)

    -- Set buffer options for the floating window
    api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    api.nvim_set_option_value("filetype", "markdown", { buf = buf }) -- Set filetype for Markdown highlighting
    api.nvim_set_option_value('readonly', true, { buf = buf })
    api.nvim_set_option_value("modifiable", false, { buf = buf })

    -- Open the floating window
    diagnostic_win_id = api.nvim_open_win(buf, false, {
        relative = 'cursor',
        row = 1,
        col = 0,
        width = width,
        height = height,
        style = 'minimal'
    })

    api.nvim_set_option_value("wrap", true, { win = diagnostic_win_id })
    api.nvim_set_option_value("linebreak", true, { win = diagnostic_win_id })
    vim.treesitter.start(buf, 'markdown')

    -- Create the auto-close trigger
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        once = true, -- The command runs once and then unregisters itself
        callback = function()
            if vim.api.nvim_win_is_valid(diagnostic_win_id) then
                vim.api.nvim_win_close(diagnostic_win_id, true)
            end
        end,
    })
end

-- Expose the function via a command
vim.api.nvim_create_user_command(
    "ShowLineDiagnostics",
    show_line_diagnostics,
    { desc = "Show all diagnostics for the current line" }
)

return {
    show_line_diagnostics = show_line_diagnostics,
}
