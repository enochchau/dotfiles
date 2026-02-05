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

        map("n", "<C-p>", MiniPick.builtin.files, { silent = true })
        map("n", "<C-f>", MiniPick.builtin.grep, { silent = true })
        map("n", "<C-b>", MiniPick.builtin.buffers, { silent = true })
        map("n", "<leader>fh", MiniPick.builtin.help, { silent = true })
        map("n", "z=", MiniExtra.pickers.spellsuggest, { silent = true })
        map("n", "<leader>o", ":Pick list scope='jump'<CR>", { silent = true })
        map("n", "<leader>'", MiniExtra.pickers.marks, { silent = true })
    end,
}
