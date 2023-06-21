---@type LazyPlugin
local M = {
    "nvim-lualine/lualine.nvim",
    config = function()
        local lualine = require "lualine"

        local winbar = {
            lualine_c = {
                function()
                    return vim.fn.expand "%:~:."
                end,
            },
        }

        lualine.setup {
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
            extensions = {
                "neo-tree",
                "toggleterm",
            },
            winbar = winbar,
            inactive_winbar = winbar,
        }
    end,
}
return M
