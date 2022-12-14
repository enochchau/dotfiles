vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("n", "<A-h>", "<C-w><", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", "<C-w>-", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "<C-w>+", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>>", { noremap = true, silent = true })
vim.keymap.set("n", "]b", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[b", ":bprevious<CR>", { noremap = true, silent = true })
local function _1_()
    return vim.diagnostic.open_float(nil, { focus = false })
end
vim.keymap.set("n", "<leader>d", _1_, { noremap = true, silent = true })
vim.keymap.set(
    "n",
    "<C-p>",
    (require "telescope.builtin").find_files,
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<C-f>",
    (require "telescope.builtin").live_grep,
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<C-b>",
    (require "telescope.builtin").buffers,
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>fh",
    (require "telescope.builtin").help_tags,
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "z=",
    (require "telescope.builtin").spell_suggest,
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>o",
    (require "telescope.builtin").jumplist,
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>cdg",
    ":Telescope node-workspace<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set("n", "<C-n>", ":Explore<CR>", { noremap = true, silent = true })
vim.keymap.set(
    "n",
    "<C-\\>",
    ":vs|:term<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>nf",
    ":Neogen<CR>",
    { noremap = true, silent = true }
)
return vim.keymap.set(
    "n",
    "<leader>w",
    (require "nvim-window").pick,
    { noremap = true, silent = true }
)
