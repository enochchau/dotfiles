local lualine = require "lualine"

local function get_theme()
    local theme = vim.g.colors_name
    if theme == "one" then
        return "onedark"
    end
    if theme == "doom-one" then
        return "auto"
    end
    return theme
end

local winbar = {
    lualine_c = {
        -- function()
        --     return vim.fn.pathshorten(vim.fn.expand "%f", 5)
        -- end,
        "%f",
    },
}

lualine.setup {
    sections = {
        lualine_b = {
            "branch",
            "b:gitsigns_status",
            { "diagnostics", sources = { "nvim_diagnostic" } },
        },
        lualine_c = { "%{ObsessionStatus('', '')}", "filename" },
    },
    options = {
        theme = get_theme(),
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
