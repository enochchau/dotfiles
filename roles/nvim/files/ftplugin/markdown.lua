local nmap = require("enoch.helpers").nmap

vim.opt_local.spell = true
nmap("<CR>", ":MarkdownPreviewToggle<CR>")
