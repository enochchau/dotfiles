local languages = { "styled", "css", "comment", "markdown_inline" }
local highlight_disable = { "csv" }

---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'main',
        build = ":TSUpdate",
        config = function()
            -- replicate `ensure_installed`, runs asynchronously, skips existing languages
            require('nvim-treesitter').install(languages)

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('treesitter.setup', {}),
                callback = function(args)
                    local buf = args.buf
                    local filetype = args.match

                    if vim.tbl_contains(highlight_disable, filetype) then
                        return
                    end

                    -- you need some mechanism to avoid running on buffers that do not
                    -- correspond to a language (like oil.nvim buffers), this implementation
                    -- checks if a parser exists for the current language
                    local language = vim.treesitter.language.get_lang(filetype) or filetype
                    if not vim.treesitter.language.add(language) then
                        return
                    end

                    -- replicate `fold = { enable = true }`
                    -- vim.wo.foldmethod = 'expr'
                    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

                    -- replicate `highlight = { enable = true }`
                    vim.treesitter.start(buf, language)

                    -- replicate `indent = { enable = true }`
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    -- `incremental_selection = { enable = true }` cannot be easily replicated
                end,
            })
            -- require("nvim-treesitter.configs").setup({
            --     ignore_install = {},
            --     ensure_installed = { "styled", "css", "comment", "markdown_inline" },
            --     sync_install = false,
            --     auto_install = true,
            --     modules = {},
            --
            --     highlight = {
            --         enable = true,
            --         additional_vim_regex_highlighting = false,
            --         disable = { "csv" }
            --     },
            -- })
        end,
    },

    { "windwp/nvim-ts-autotag", config = true },
    {
        "nvim-treesitter/nvim-treesitter-context",

        opts = {
            enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 0,           -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 1, -- Maximum number of lines to show for a single context
            trim_scope = "outer",    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = "cursor",         -- Line used to calculate context. Choices: 'cursor', 'topline'
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
        dependencies = { "nvim-treesitter/nvim-treesitter" }
    }
}
