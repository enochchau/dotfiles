local nmap = require("enoch.helpers").nmap

require("nvim-tree").setup {
    sync_root_with_cwd = true,
    view = {
        side = "right",
        relativenumber = true,
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
    actions = {
        open_file = {
            window_picker = {
                chars = "FJDKSLA;CMRUEIWOQP",
            },
        },
    },
}

nmap("<leader>n", ":NvimTreeFindFile<CR>")
nmap("<C-n>", ":NvimTreeToggle<CR>")
