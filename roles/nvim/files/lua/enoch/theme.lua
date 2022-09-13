local has = vim.fn.has

vim.g.tokyonight_style = "storm"
vim.g.aurora_italic = 1
vim.g.aurora_bold = 1

vim.opt.bg = "dark"
local theme = "onedark"

if theme == "oxocarbon-lua" or theme == "aurora" then
    require("transparent").setup { enable = true }
end

vim.cmd("colo " .. theme)
