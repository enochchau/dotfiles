vim.keymap.set(
    "t",
    "<C-\\><C-\\>",
    (require "FTerm").toggle,
    { noremap = true, silent = true }
)
