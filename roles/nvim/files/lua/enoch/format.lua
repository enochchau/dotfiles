local M = {}

local default_omit = {
    ["tsserver"] = true,
    ["jsonls"] = true,
    ["yammls"] = true,
    ["eslint"] = true,
    ["sumneko_lua"] = true,
}

local astro_omit = {
    ["astro"] = true,
    ["eslint"] = true,
}

function M.format(client_name)
    vim.lsp.buf.format {
        filter = function(fmt_client)
            local omit
            if client_name == "astro" then
                omit = astro_omit
            else
                omit = default_omit
            end

            return not omit[fmt_client]
        end,
        async = true,
    }
end

local enable_autocmd = false
if enable_autocmd then
    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd

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
