---@type (string | LazySpec)[]
local plugins = {
    -- editing
    "tpope/vim-obsession",

    -- themes
    "navarasu/onedark.nvim",
    "folke/tokyonight.nvim",

    -- additional language support
    "pearofducks/ansible-vim",
    "vim-scripts/applescript.vim",
    "amadeus/vim-mjml",

    -- qol
    {
        "almo7aya/openingh.nvim",
        cmd = { "OpenInGHFile", "OpenInGHRepo" },
        config = true,
    },

    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").create_default_mappings()
        end,
    },

    "tpope/vim-eunuch",

    -- window picker
    {
        url = "https://gitlab.com/yorickpeterse/nvim-window.git",
        opts = {
            chars = {

                "f",
                "j",
                "d",
                "k",
                "s",
                "l",
                "a",
                ";",
                "c",
                "m",
                "r",
                "u",
                "e",
                "i",
                "w",
                "o",
                "q",
                "p",
            },
        },
        keys = {
            {

                "<leader>w",
                function()
                    (require "nvim-window").pick()
                end,
                mode = "",
                desc = "Pick window",
                noremap = true,
            },
        },
    },
}

return plugins
