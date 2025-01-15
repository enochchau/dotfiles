local vscode = require("vscode")
local map = vim.keymap.set

vim.notify = vscode.notify

--- run vscode.action
---@param action string
---@return function
function act(action)
    return function()
        vscode.action(action)
    end
end

map("n", "K", act("editor.action.showHover"))
map("n", "<leader>b", act("workbench.action.showAllEditors"))
map("n", "<leader>f", act("editor.action.formatDocument"))
map("n", "<leader>a", act("editor.action.quickFix"))
map("n", "<leader>rn", act("editor.action.rename"))
map("n", "gr", act("editor.action.goToReferences"))
map("n", "gw", act("workbench.actions.view.problems"))
map("n", "]d", act("editor.action.marker.nextInFiles"))
map("n", "[d", act("editor.action.marker.prevInFiles"))
