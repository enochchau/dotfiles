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

-- Autocommand to close the diagnostic window when the cursor moves
api.nvim_create_autocmd("CursorMoved", {
    group = api.nvim_create_augroup("CloseDiagnosticWindow", { clear = true }),
    callback = function()
        if diagnostic_win_id and api.nvim_win_is_valid(diagnostic_win_id) then
            api.nvim_win_close(diagnostic_win_id, true)
            diagnostic_win_id = nil
            diagnostic_buf_id = nil
        end
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

--- Formats a single diagnostic into a Markdown string.
--- @param diagnostic table The diagnostic object.
--- @return table<string> The formatted diagnostic string.
local function format_diagnostic(diagnostic)
    local source = diagnostic.source or "nvim"
    local message = diagnostic.message
    if diagnostic.source == "typescript" then
        message =
            require("enoch.pretty-ts-errors.pretty-ts-errors").format_diagnostic_message(
                message
            )
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
        table.insert(lines, "  " .. message_lines[i])
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
                        { line_count, #line },
                    })
                end
            end
            line_count = line_count + 1
        end
    end

    return formatted_diagnostics, hl_positions
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

    -- Set buffer options for the floating window
    api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    -- api.nvim_buf_set_option(buf, "readonly", true)
    -- api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_set_option_value("filetype", "markdown", { buf = buf }) -- Set filetype for Markdown highlighting

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

    -- Calculate window dimensions
    local max_width = 0
    for _, line in ipairs(lines) do
        max_width = math.max(max_width, #line)
    end
    local win_height = math.min(
        #lines,
        math.floor(api.nvim_get_option_value("lines", {}) * 0.4)
    ) -- Limit height
    local win_width = math.min(
        max_width,
        math.floor(api.nvim_get_option_value("columns", {}) * 0.6)
    ) -- Limit width

    -- Define window options for positioning
    local opts = {
        relative = "cursor",
        row = 1, -- Position below the cursor line
        col = 0, -- Position at the cursor column
        width = win_width,
        height = win_height,
        style = "minimal",
        border = "rounded", -- Optional: add a border
        focusable = false, -- Prevent the window from being focused
    }

    -- Open the floating window
    diagnostic_win_id = api.nvim_open_win(buf, false, opts)

    -- Optional: Highlight the border
    api.nvim_set_option_value(
        "winhl",
        "Normal:Normal,FloatBorder:FloatBorder",
        { win = diagnostic_win_id }
    )
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
