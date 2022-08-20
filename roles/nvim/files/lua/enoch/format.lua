local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.default_fmt_omit = {
    ["tsserver"] = true,
    ["jsonls"] = true,
    ["yammls"] = true,
    ["sumneko_lua"] = true,
}

M.astro_fmt_omit = {
    ["astro"] = true,
    ["eslint"] = true,
}

local fmt_on_save = augroup("FmtOnSave", {})

--- format filter on omitted clients
---@param omit_client_set table Set like table
---@return fun(client: table):boolean filter callback for vim.lsp.buf.format
function M.format_filter(omit_client_set)
    return function(fmt_client_name)
        if omit_client_set[fmt_client_name] then
            print('checking formatting', fmt_client_name, false)
            return false
        end
            print('checking formatting', fmt_client_name, true)
        return true
    end
end

local function format_filetype(pattern, omit_clients)
    omit_clients = omit_clients or {}
    autocmd("BufWritePre", {
        group = fmt_on_save,
        pattern = pattern,
        callback = function()
            vim.lsp.buf.format {
                filter = M.format_filter(omit_clients)
            }
        end,
    })
end

local enable = false
if enable then
    format_filetype({
        "*.js",
        "*.ts",
        "*.jsx",
        "*.tsx",
        "*.cjs",
        "*.mjs",
        "*.css",
        "*.scss",
        "*.md",
        "*.yaml",
        "*.yml",
        "*.json",
        "*.lua",
        "*.go",
        "*.fnl",
    }, M.default_fmt_omit)

    format_filetype({
        "*.astro",
    }, M.astro_fmt_omit)
end

return M
