local vscode = require("vscode")
local map = vim.keymap.set

vim.notify = vscode.notify

--- run vscode.action
---@param action string
---@return function
function call(action)
    return function()
        vscode.call(action)
    end
end

local opts = { noremap = true, silent = true }

map("n", "K", call("editor.action.showHover"))
map("n", "<leader>b", call("workbench.action.showAllEditors"))
map("n", "<leader>f", call("editor.action.formatDocument"))
map("n", "<leader>a", call("editor.action.quickFix"))
map("n", "<leader>rn", call("editor.action.rename"))
map("n", "gr", call("editor.action.goToReferences"))
map("n", "gw", call("workbench.actions.view.problems"))
map("n", "]d", call("editor.action.marker.nextInFiles"))
map("n", "[d", call("editor.action.marker.prevInFiles"))

-- move wrapped line wise
map("n", "j", "gj", { remap = true })
map("n", "k", "gk", { remap = true })
-- hold visual selection on tab
map("v", ">", ">gv")
map("v", "<", "<gv")
-- resize window
map("n", "<A-h>", "<C-w><")
map("n", "<A-j>", "<C-w>-")
map("n", "<A-k>", "<C-w>+")
map("n", "<A-l>", "<C-w>>")
-- cycle buffers
map("n", "]b", ":bnext<CR>")
map("n", "[b", ":bprevious<CR>")

-- disable window swapping
map("n", "<C-w><C-h>", "<C-w>h", { remap = true })
map("n", "<C-w><C-j>", "<C-w>j", { remap = true })
map("n", "<C-w><C-k>", "<C-w>k", { remap = true })
map("n", "<C-w><C-l>", "<C-w>l", { remap = true })
