local api = vim.api

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

--- Formats a single diagnostic into a Markdown string.
--- @param diagnostic table The diagnostic object.
--- @return string The formatted diagnostic string.
local function format_diagnostic(diagnostic)
    local severity_map = {
        [vim.diagnostic.severity.ERROR] = "ERROR",
        [vim.diagnostic.severity.WARN] = "WARNING",
        [vim.diagnostic.severity.INFO] = "INFO",
        [vim.diagnostic.severity.HINT] = "HINT",
    }
    local severity = severity_map[diagnostic.severity] or "UNKNOWN"
    local source = diagnostic.source or "nvim"
    local message = diagnostic.message:gsub("\n", " ") -- Replace newlines in message

    -- Simple Markdown formatting
    return string.format("# %s [%s]\n%s", severity, source, message)
end

--- Gets all diagnostics for the current line.
--- @return table A list of formatted diagnostic strings, or an empty list if none found.
local function get_diagnostics_for_current_line()
    local bufnr = api.nvim_get_current_buf()
    local cursor_row = api.nvim_win_get_cursor(0)[1]
    -- vim.diagnostic.get with lnum gets all diagnostics on that line
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_row - 1 }) -- lnum is 0-indexed in API

    local formatted_diagnostics = {}
    for _, diag in ipairs(diagnostics) do
        table.insert(formatted_diagnostics, format_diagnostic(diag))
    end

    return formatted_diagnostics
end

--- Creates and displays a floating diagnostic window at the cursor with all diagnostics for the current line.
local function show_line_diagnostics()
    -- Close existing window if it exists
    if diagnostic_win_id and api.nvim_win_is_valid(diagnostic_win_id) then
        api.nvim_win_close(diagnostic_win_id, true)
        diagnostic_win_id = nil
        diagnostic_buf_id = nil
    end

    local diagnostic_messages = get_diagnostics_for_current_line()

    -- Do nothing if no diagnostics on the line
    if #diagnostic_messages == 0 then
        return
    end

    local content = table.concat(diagnostic_messages, "\n---\n") -- Separate multiple diagnostics with a line

    -- Create a new scratch buffer
    local buf = api.nvim_create_buf(false, true)
    diagnostic_buf_id = buf

    -- Set buffer options for the floating window
    api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    -- api.nvim_buf_set_option(buf, "readonly", true)
    -- api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_set_option_value("filetype", "markdown", { buf = buf }) -- Set filetype for Markdown highlighting

    -- Set the content of the buffer
    local lines = vim.split(content, "\n")
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Calculate window dimensions
    local max_width = 0
    for _, line in ipairs(lines) do
        max_width = math.max(max_width, #line)
    end
    local win_height =
        math.min(#lines, math.floor(api.nvim_get_option_value("lines") * 0.4)) -- Limit height
    local win_width = math.min(
        max_width,
        math.floor(api.nvim_get_option_value("columns") * 0.6)
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

-- Example usage: Map to a keybinding
-- vim.keymap.set('n', '<leader>D', show_line_diagnostics, { desc = 'Show line diagnostics' })
