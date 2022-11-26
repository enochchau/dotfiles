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

return M
