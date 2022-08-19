local has = vim.fn.has

-- "catppuccin"
-- "doom-one"
-- "juliana"
-- "moonlight"
-- "onedark"
-- "onenord"
-- "tokyonight"
-- "oxocarbon-lua"

local theme = "minimal"

if has "wsl" == 0 then
    if theme == "oxocarbon-lua" then
        require("transparent").setup { enable = true }
    end
end

vim.opt.bg = "dark"
if theme == "tokyonight" then
    vim.opt.bg = "light"
end

vim.g.tokyonight_style = "storm"
vim.g.catppuccin_flavour = "frappe"

vim.cmd("colo " .. theme)
