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
    local omit
    if client_name == "astro" then
        omit = astro_omit
    else
        omit = default_omit
    end

    vim.lsp.buf.format {
        filter = function(fmt_client)
            return not omit[fmt_client.name]
        end,
        async = true,
    }
end

return M
