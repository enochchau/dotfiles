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
        lualine_c = { "%{ObsessionStatus('', '')}", "filename" },
    },
    options = {
        globalstatus = true,
        theme = (function()
            local theme = vim.g.colors_name
            if theme == "one" then
                return "onedark"
            end
            if theme == "doom-one" then
                return "auto"
            end
            return theme
        end)(),
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
