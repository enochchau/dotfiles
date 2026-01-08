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
-- Expose the function via a command
vim.api.nvim_create_user_command(
    "ShowLineDiagnostics",
    require("pretty-ts-errors").show_line_diagnostics,
    { desc = "Show all diagnostics for the current line" }
)

return {
    show_line_diagnostics = require("pretty-ts-errors").show_line_diagnostics,
}
