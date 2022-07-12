local lualine = require("lualine")

local function get_theme()
  local theme = vim.g.colors_name
  if theme == "one" then
    return "onedark"
  end
  return theme
end

lualine.setup({
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
})
