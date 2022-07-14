local nmap = require("enoch.helpers").nmap

require("enoch.plugins")
require("enoch.alpha")
require("enoch.filetree")
require("enoch.cmp")
require("enoch.format")
require("enoch.lsp")
require("enoch.statusline")
require("enoch.telescope")
require("enoch.term")
require("enoch.theme")
require("enoch.treesitter")

nmap("<leader>nf", require("neogen").generate)
nmap("<CR>", ":MarkdownPreviewToggle<CR>")
