local ntl_root = vim.fn.expand("~/Numeric/fdp/master/workspaces/ntl/packages")

-- tree-sitter
local parser_path = ntl_root .. "/tree-sitter-ntl"
if vim.uv.fs_stat(parser_path) then
    vim.filetype.add({
        extension = { ["ntl"] = "ntl" },
    })
    vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
            require("nvim-treesitter.parsers").ntl = {
                install_info = {
                    path = parser_path,
                    queries = "queries/ntl",
                },
                tier = 2,
            }
        end,
    })
end

-- lsp
local lsp_main = ntl_root .. "/ntl-language-server/out/main.js"
if vim.uv.fs_stat(lsp_main) then
    vim.lsp.config("ntl-language-server", {
        cmd = { "node", lsp_main, "--stdio" },
        filetypes = { "ntl" },
        root_markers = { ".git" },
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    vim.lsp.enable("ntl-language-server")
end
