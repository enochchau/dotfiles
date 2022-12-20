local fzf = require('fzf-lua')
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("v", ">", ">gv", opts)
map("v", "<", "<gv", opts)
map("n", "<A-h>", "<C-w><", opts)
map("n", "<A-j>", "<C-w>-", opts)
map("n", "<A-k>", "<C-w>+", opts)
map("n", "<A-l>", "<C-w>>", opts)
map("n", "]b", ":bnext<CR>", opts)
map("n", "[b", ":bprevious<CR>", opts)
map("n", "<leader>d", function()
    return vim.diagnostic.open_float(nil, { focus = false })
end, opts)

-- fzf
map("n", "<C-p>", fzf.files, opts)
map("n", "<C-f>", fzf.live_grep, opts)
map("n", "<C-b>", fzf.buffers, opts)
map("n", "<leader>fh", fzf.help_tags, opts)
map("n", "z=", fzf.spell_suggest, opts)
map("n", "<leader>o", fzf.jumps, opts)
map("n", "<leader>'", fzf.marks, opts)
map("n", "<leader>nw", require('enoch.fzf').fzf_node_workspaces, opts)

map("n", "<leader>cdg", ":Cdg<CR>:pwd<CR>", opts)
map("n", "<C-n>", ":Explore<CR>", opts)
map("n", "<C-\\>", ":vs|:term<CR>", opts)

map("n", "<leader>nf", ":Neogen<CR>", opts)
map("n", "<leader>w", (require "nvim-window").pick, opts)
