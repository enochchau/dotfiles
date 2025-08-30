---@type LazySpec
return {
    "nvim-mini/mini.pick",
    version = false,
    dependencies = {
        "nvim-mini/mini.icons",
        { "nvim-mini/mini.extra", version = false, config = true },
    },
    config = function()
        local MiniPick = require("mini.pick")
        local MiniExtra = require("mini.extra")
        MiniPick.setup()
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }
        vim.ui.select = MiniPick.ui_select

        map("n", "<C-p>", MiniPick.builtin.files, opts)
        map("n", "<C-f>", MiniPick.builtin.grep_live, opts)
        map("n", "<C-b>", MiniPick.builtin.buffers, opts)
        map("n", "<leader>fh", MiniPick.builtin.help, opts)
        map("n", "z=", MiniExtra.pickers.spellsuggest, opts)
        map("n", "<leader>o", ":Pick list scope='jump'<CR>", opts)
        map("n", "<leader>'", MiniExtra.pickers.marks, opts)
    end,
}
