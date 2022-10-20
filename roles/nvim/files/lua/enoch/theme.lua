local has = vim.fn.has

vim.g.gruvbox_contrast_light = "soft"

vim.opt.bg = "light"
local theme = "onedark"

if theme == "oxocarbon-lua" then
    require("transparent").setup { enable = true }
end

vim.cmd.colorscheme(theme)
