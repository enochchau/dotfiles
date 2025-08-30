---@type (string | LazySpec)[]
return {
    {
        "nvim-mini/mini.icons",
        version = false,
        config = function()
            local MiniIcons = require("mini.icons")
            MiniIcons.setup()
            MiniIcons.mock_nvim_web_devicons()
        end,
    },
    { "j-hui/fidget.nvim", opts = {} },
    {
        "lukas-reineke/indent-blankline.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        main = "ibl",
        opts = {
            scope = { enabled = true },
            exclude = { filetypes = { "alpha" } },
        },
    },
    {
        "catgoose/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {
            lazy_load = true,
            filetypes = {
                "javascript",
                "javascriptreact",
                "svelte",
                "astro",
                "html",
                "typescript",
                "typescriptreact",
                "css",
                "scss",
            },
            user_default_options = { mode = "virtualtext" },
        },
    },
    {
        "goolord/alpha-nvim",
        config = function()
            local alpha = require("alpha")
            local startify = require("alpha.themes.startify")
            local fortune = require("alpha.fortune")

            -- ---@param message table
            local function cowsays(message)
                local says = {
                    "                         ",
                    "    o                    ",
                    "     o   ^__^            ",
                    "      o  (oo)\\_______    ",
                    "         (__)\\       )\\/\\",
                    "             ||----w |   ",
                    "             ||     ||   ",
                }

                for _, str in ipairs(says) do
                    table.insert(message, str)
                end

                return message
            end

            -- ---@param message table
            -- local function tuxsays(message)
            --     local says = {
            --         "    o              ",
            --         "     o     .--.    ",
            --         "      o   |o_o |   ",
            --         "          |:_/ |   ",
            --         "         //   \\ \\  ",
            --         "        (|     | ) ",
            --         "       /'\\_   _/`\\ ",
            --         "       \\___)=(___/ ",
            --     }

            --     for _, str in ipairs(says) do
            --         table.insert(message, str)
            --     end

            --     return message
            -- end

            startify.section.header.val = cowsays(fortune())
            alpha.setup(startify.config)
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            local lualine = require("lualine")

            local winbar = {
                lualine_c = {
                    function()
                        return vim.fn.expand("%:~:.")
                    end,
                },
            }

            lualine.setup({
                sections = {
                    lualine_b = {
                        "branch",
                        "diff",
                        { "diagnostics", sources = { "nvim_diagnostic" } },
                    },
                    lualine_c = {
                        "%{ObsessionStatus('󰆓 ', '󰆓 ')}",
                        "filename",
                    },
                },
                options = {
                    globalstatus = true,
                    section_separators = "",
                    component_separators = "│",
                },
                winbar = winbar,
                inactive_winbar = winbar,
            })
        end,
    },
}
