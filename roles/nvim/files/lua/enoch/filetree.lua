local nmap = require("enoch.helpers").nmap
local width = vim.api.nvim_win_get_width(0)
require("nvim-tree").setup {
    view = {
        side = "right",
        relativenumber = true,
        float = {
            enable = true,
            open_win_config = {
                row = 1,
                col = width,
            },
        },
    },
    filters = {
        exclude = { ".DS_Store" },
    },
    renderer = {
        indent_markers = {
            enable = true,
        },
    },
    git = { ignore = false },
}
nmap("<leader>n", ":NvimTreeFindFile<CR>")
nmap("<C-n>", ":NvimTreeToggle<CR>")
