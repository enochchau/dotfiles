---@type LazySpec
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
        "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
        vim.treesitter.language.register("markdown", "mdx")

        require("nvim-treesitter.configs").setup {
            ignore_install = {},
            ensure_installed = {},
            sync_install = false,
            auto_install = true,
            modules = {},

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
        }

        require("treesitter-context").setup {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 5, -- Maximum number of lines to show for a single context
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
        }
    end,
}
