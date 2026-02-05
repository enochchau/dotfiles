local open = require("enoch.open")

local map = vim.keymap.set

-- move wrapped line wise
map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })
-- hold visual selection on tab
map("v", ">", ">gv", { silent = true })
map("v", "<", "<gv", { silent = true })
-- resize window
map("n", "<A-h>", "<C-w><", { silent = true })
map("n", "<A-j>", "<C-w>-", { silent = true })
map("n", "<A-k>", "<C-w>+", { silent = true })
map("n", "<A-l>", "<C-w>>", { silent = true })
-- cycle buffers
map("n", "]b", ":bnext<CR>", { desc = "Next Buffer" })
map("n", "[b", ":bprevious<CR>", { desc = "Previous Buffer" })
map("n", "]l", ":lnext<CR>", { desc = "Next Location List item" })
map("n", "[l", ":lprev<CR>", { desc = "Previous Location List item" })
map("n", "]q", ":cnext<CR>", { desc = "Next Quickfix item" })
map("n", "[q", ":cprev<CR>", { desc = "Previous Quickfix item" })

map("n", "<leader>d", function()
    local success, result =
        pcall(require("enoch.diagnostic").show_line_diagnostics)
    if not success then
        vim.print(result)
        vim.diagnostic.open_float()
    end
end, { desc = "Open diagnostic float" })

-- toggle quickfix
map("n", "<leader>q", function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_exists = true
        end
    end
    if qf_exists then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end, { desc = "Toggle Quickfix Window" })

-- toggle loclist
map("n", "<leader>l", function()
    local ll_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            ll_exists = true
        end
    end
    if ll_exists then
        vim.cmd("lclose")
    else
        vim.cmd("lopen")
    end
end, { desc = "Toggle Loclist Window" })

map(
    "n",
    "<leader>cdg",
    ":Cdg<CR>:pwd<CR>",
    { desc = "Change pwd to nearest git root" }
)
map("n", "<C-n>", require("enoch.netrw").toggle_netrw, { silent = true })
map("n", "<C-\\>", ":vs|:term<CR>", { silent = true })

-- map("n", "]c", colo.cycle_colors_next, opts)
-- map("n", "[c", colo.cycle_colors_prev, opts)
-- map("n", "<leader>c", colo.save_color, opts)

map("n", "<leader>op", open.plugin_link, { silent = true })
