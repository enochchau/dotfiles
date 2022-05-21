local toggleterm = require("toggleterm")

local opts = {
  open_mapping = "<c-\\>",
}

local colors_name = vim.g.colors_name
if colors_name == "gruvbox" then
  opts.shading_factor = 5
elseif colors_name == "onedark" then
  opts.shading_factor = 3
end

toggleterm.setup(opts)
