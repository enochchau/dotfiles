local colo = require("enoch.helpers").colo

vim.opt.bg = "dark"
vim.g.tokyonight_style = "storm"

-- colo "onedark"
-- colo "doom-one"

if vim.version().minor < 8 then
    colo "onenord"
else
    colo "juliana"
end
