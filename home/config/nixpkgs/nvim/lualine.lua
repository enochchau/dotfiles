require("lualine").setup({
  sections = {
    lualine_b = {
      "branch",
      "b:gitsigns_status",
      {
        "diagnostics",
        sources = {
          "nvim_diagnostic",
        },
      },
    },
    lualine_c = {
      "%{ObsessionStatus('', '')}",
      "filename",
    },
  },
  options = {
    theme = vim.g.colors_name,
    section_separators = "",
    component_separators = "│",
  },
  extensions = {
    "nvim-tree",
    "toggleterm",
  },
})
