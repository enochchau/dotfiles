local has = vim.fn.has

vim.g.tokyonight_style = "storm"

vim.opt.bg = "dark"
local theme = "oxocarbon-lua"

if theme == "oxocarbon-lua" then
    require("transparent").setup { enable = true }
end

if theme == "tokyonight" then
    vim.opt.bg = "light"
end


vim.cmd("colo " .. theme)
