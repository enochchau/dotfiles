local nmap = (require("enoch.helpers")).nmap
nmap("<C-\\>", (require("FTerm")).toggle)
vim.api.nvim_create_user_command("Open", (require("FTerm")).open, {bang = true})
vim.api.nvim_create_user_command("Close", (require("FTerm")).close, {bang = true})
vim.api.nvim_create_user_command("Exit", (require("FTerm")).exit, {bang = true})
return vim.api.nvim_create_user_command("Toggle", (require("FTerm")).toggle, {bang = true})
