local colo = require("enoch.helpers").colo

if vim.fn.has "wsl" == 0 then
    -- require("transparent").setup { enable = true }
end

vim.opt.bg = "light"
vim.g.tokyonight_style = "storm"
vim.g.catppuccin_flavour = "frappe"

-- colo "catppuccin"
-- colo "doom-one"
-- colo "juliana"
-- colo "moonlight"
-- colo "onedark"
-- colo "onenord"
colo "tokyonight"
-- colo "oxocarbon-lua"
