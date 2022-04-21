local opts = {
  open_mapping = [[<c-\>]],
}
if vim.g.colors_name == "gruvbox" then
  opts.shading_factor = 5
end

require("toggleterm").setup(opts)
