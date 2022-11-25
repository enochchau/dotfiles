local nmap = require("enoch.helpers").nmap
local vmap = require("enoch.helpers").vmap

-- move vertically by visual line, don't skip wrapped lines
nmap("j", "gj")
nmap("k", "gk")

-- Hold visual mode after indent
vmap(">", ">gv")
vmap("<", "<gv")

-- Maps Alt-[h,j,k,l] to resizing a window split
nmap("<A-h>", "<C-w><")
nmap("<A-j>", "<C-w>-")
nmap("<A-k>", "<C-w>+")
nmap("<A-l>", "<C-w>>")

-- traverse buffers
nmap("]b", ":bnext<CR>")
nmap("[b", ":bprevious<CR>")
