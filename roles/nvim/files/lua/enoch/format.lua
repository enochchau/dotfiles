local M = {}

local client_omit = {
    astro = {
        ["astro"] = true,
        ["eslint"] = true,
    },
    default = {
        ["tsserver"] = true,
        ["jsonls"] = true,
        ["yammls"] = true,
        ["eslint"] = true,
        ["sumneko_lua"] = true,
    },
}

function M.format(client_name)
    local omit = client_omit[client_name] or client_omit.default

    vim.lsp.buf.format {
        filter = function(fmt_client)
            return not omit[fmt_client.name]
        end,
        async = true,
    }
end

return M
