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

map("n", "<leader>d", function()
    return vim.diagnostic.open_float(nil, { focus = false })
end, opts)

map("n", "<leader>cdg", ":Cdg<CR>:pwd<CR>", opts)
map("n", "<C-n>", require("enoch.netrw").toggle_netrw, opts)
map("n", "<C-\\>", ":vs|:term<CR>", opts)

map("n", "<leader>nf", ":Neogen<CR>", opts)


local colorschemes = vim.fn.getcompletion("", "color")
local i = 1

local function cycle_colors_next()
    i = i + 1
    if i > #colorschemes then
        i = 1
    end
    local c = colorschemes[i]
    print(c, i)
    vim.cmd.colorscheme(c)
end

local function cycle_colors_prev()
    i = i - 1
    if i < 1 then
        i = #colorschemes
    end
    local c = colorschemes[i]
    vim.cmd.colorscheme(c)
    print(c, i)
end

vim.keymap.set("n", "]c", cycle_colors_next, {})
vim.keymap.set("n", "[c", cycle_colors_prev, {})
-- vim.keymap.set("n", "<leader>c", function()
--     vim.fn.system("echo " .. vim.g.colors_name .. " >> " .. vim.fn.stdpath("config") .. "/colo.txt")
-- end)
