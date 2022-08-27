local nmap = require("enoch.helpers").nmap

nmap([[<C-\>]], require("FTerm").toggle)

vim.api.nvim_create_user_command(
    "FTermOpen",
    require("FTerm").open,
    { bang = true }
)
vim.api.nvim_create_user_command(
    "FTermClose",
    require("FTerm").close,
    { bang = true }
)
vim.api.nvim_create_user_command(
    "FTermExit",
    require("FTerm").exit,
    { bang = true }
)
vim.api.nvim_create_user_command(
    "FTermToggle",
    require("FTerm").toggle,
    { bang = true }
)
