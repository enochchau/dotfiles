local colo = require("enoch.helpers").colo

vim.opt.bg = "light"
vim.g.tokyonight_style = "storm"

-- colo "onedark"
-- colo "nightfox"
-- colo "doom-one"

if vim.version().minor < 8 then
    colo "juliana"
else
    colo "tokyonight"
end
