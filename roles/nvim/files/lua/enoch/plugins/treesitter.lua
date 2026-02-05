---@class SetupTreesitterArgs
---@field ensure_installed string[]
---@field highlight_disable string[]

---@param opts SetupTreesitterArgs
local function setup_treesitter(opts)
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
    {
        "nvim-treesitter/nvim-treesitter-context",

        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 1, -- Maximum number of lines to show for a single context
            trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = "_",
            zindex = 20, -- The Z-index of the context window
            on_attach = function(bufnr)
                -- disable for mdx because of bug
                if vim.bo[bufnr].ft == "mdx" then
                    return false
                end
                return true
            end,
        },
    },
    {
        "davidmh/mdx.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
}
