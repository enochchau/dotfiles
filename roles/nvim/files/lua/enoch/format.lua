local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local fmt_on_save = augroup("FmtOnSave", {})

local function format_filetype(pattern, omit_clients)
    omit_clients = omit_clients or {}
    autocmd("BufWritePre", {
        group = fmt_on_save,
        pattern = pattern,
        callback = function()
            vim.lsp.buf.format {
                filter = function(client)
                    if omit_clients[client.name] then
                        return false
                    end
                    return true
                end,
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
    }, {
        ["tsserver"] = true,
        ["jsonls"] = true,
        ["yammls"] = true,
        ["sumneko_lua"] = true,
    })

    format_filetype({
        "*.astro",
    }, {
        ["astro"] = true,
        ["eslint"] = true,
    })
end
