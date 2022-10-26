local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

local default_fmt_omit = {
    ["tsserver"] = true,
    ["jsonls"] = true,
    ["yammls"] = true,
    ["eslint"] = true,
    ["sumneko_lua"] = true,
}

local astro_fmt_omit = {
    ["astro"] = true,
    ["eslint"] = true,
}
--- format filter on omitted clients
---@param omit_client_set table Set like table
---@return fun(client: table):boolean filter callback for vim.lsp.buf.format
local function format_filter(omit_client_set)
    return function(fmt_client_name)
        if omit_client_set[fmt_client_name] then
            return false
        end
        return true
    end
end

function M.format(client_name)
    vim.lsp.buf.format {
        filter = function(fmt_client)
            if client_name == "astro" then
                return format_filter(astro_fmt_omit)(fmt_client.name)
            end
            return format_filter(default_fmt_omit)(fmt_client.name)
        end,
        async = true,
    }
end

local enable_autocmd = false
if enable_autocmd then
    local fmt_on_save = augroup("FmtOnSave", {})

    local function format_filetype(pattern, client_name)
        autocmd("BufWritePre", {
            group = fmt_on_save,
            pattern = pattern,
            callback = function()
                M.format(client_name)
            end,
        })
    end

    format_filetype {
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
    }

    format_filetype({ "*.astro" }, "astro")
end

return M
