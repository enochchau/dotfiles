---@type (string | LazySpec)[]
local plugins = {
    { "williamboman/mason.nvim", config = true },
    -- editing
    "tpope/vim-obsession",

    -- themes
    "navarasu/onedark.nvim",
    "folke/tokyonight.nvim",

    -- additional language support
    "pearofducks/ansible-vim",
    "amadeus/vim-mjml",

    -- qol
    {
        "almo7aya/openingh.nvim",
        cmd = { "OpenInGHFile", "OpenInGHRepo" },
        config = true,
    },
    "nvim-lua/plenary.nvim",

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
