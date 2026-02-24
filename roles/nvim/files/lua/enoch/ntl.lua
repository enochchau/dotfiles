local ntl_root = vim.fn.expand("~/Numeric/fdp/master/workspaces/ntl/packages")

-- tree-sitter
local parser_path = ntl_root .. "/tree-sitter-ntl"
local parser_so = parser_path .. "/ntl.so"
if vim.uv.fs_stat(parser_so) then
    vim.opt.runtimepath:append(parser_path)
    vim.filetype.add({
        extension = { ["ntl"] = "ntl" },
    })
    vim.treesitter.language.add("ntl", { path = parser_so })
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
