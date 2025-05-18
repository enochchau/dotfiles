local open = require("enoch.open")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- move wrapped line wise
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
-- hold visual selection on tab
map("v", ">", ">gv", opts)
map("v", "<", "<gv", opts)
-- resize window
map("n", "<A-h>", "<C-w><", opts)
map("n", "<A-j>", "<C-w>-", opts)
map("n", "<A-k>", "<C-w>+", opts)
map("n", "<A-l>", "<C-w>>", opts)
-- cycle buffers
map("n", "]b", ":bnext<CR>", opts)
map("n", "[b", ":bprevious<CR>", opts)

-- map("n", "<leader>d", function()
--     return vim.diagnostic.open_float(nil, { focus = false })
-- end, opts)
map("n", "<leader>d", require("enoch.diagnostic").show_line_diagnostics, opts)

map("n", "<leader>cdg", ":Cdg<CR>:pwd<CR>", opts)
map("n", "<C-n>", require("enoch.netrw").toggle_netrw, opts)
map("n", "<C-\\>", ":vs|:term<CR>", opts)

map("n", "<leader>nf", ":Neogen<CR>", opts)

-- map("n", "]c", colo.cycle_colors_next, opts)
-- map("n", "[c", colo.cycle_colors_prev, opts)
-- map("n", "<leader>c", colo.save_color, opts)

map("n", "<leader>op", open.plugin_link, opts)
