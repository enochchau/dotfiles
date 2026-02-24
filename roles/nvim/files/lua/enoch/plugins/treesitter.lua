---@class SetupTreesitterArgs
---@field ensure_installed string[]
---@field highlight_disable string[]

---@param opts SetupTreesitterArgs
local function setup_treesitter(opts)
    local ntl_path = vim.fn.expand(
        "~/Numeric/fdp/vibing/workspaces/ntl/packages/tree-sitter-ntl/ntl.so"
    )
    if vim.uv.fs_stat(ntl_path) then
        vim.opt.runtimepath:append(
            vim.fn.expand("~/Numeric/fdp/vibing/workspaces/ntl/packages/tree-sitter-ntl")
        )
        vim.filetype.add({
            extension = { ["ntl"] = "ntl" },
        })
        vim.treesitter.language.add("ntl", { path = ntl_path })
    end

    local highlight_disable = opts.highlight_disable or {}
    local ensure_installed = opts.ensure_installed or {}

    -- replicate `ensure_installed`, runs asynchronously, skips existing languages
    local nvim_treesitter = require("nvim-treesitter")
    nvim_treesitter.install(ensure_installed):wait(300000)

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter.setup", {}),
        callback = function(args)
            local buf = args.buf
            local filetype = args.match

            if vim.tbl_contains(highlight_disable, filetype) then
                return
            end

            -- you need some mechanism to avoid running on buffers that do not
            -- correspond to a language (like oil.nvim buffers), this implementation
            -- checks if a parser exists for the current language
            local language = vim.treesitter.language.get_lang(filetype)
                or filetype
            if not vim.treesitter.language.add(language) then
                return
            end
            nvim_treesitter.install({ language }):await(function()
                -- replicate `fold = { enable = true }`
                -- vim.wo.foldmethod = 'expr'
                -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                if vim.api.nvim_buf_is_valid(buf) then
                    vim.treesitter.start(buf, language)
                    vim.bo[buf].indentexpr =
                        "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end)
        end,
    })
end

---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            setup_treesitter({
                ensure_installed = {
                    "styled",
                    "css",
                    "comment",
                    "markdown_inline",
                    "markdown",
                    "jsdoc",
                },
                highlight_disable = { "csv" },
            })
        end,
    },

    { "windwp/nvim-ts-autotag", config = true },
    { "nvim-treesitter/nvim-treesitter-context" },
    {
        "davidmh/mdx.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
}
