---@type LazySpec
return {
    "ibhagwan/fzf-lua",
    config = function()
        local fzf = require "fzf-lua"
        fzf.register_ui_select()
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }

        map("n", "<C-p>", fzf.files, opts)
        map("n", "<C-f>", fzf.live_grep, opts)
        map("n", "<C-b>", fzf.buffers, opts)
        map("n", "<leader>fh", fzf.help_tags, opts)
        map("n", "z=", fzf.spell_suggest, opts)
        map("n", "<leader>o", fzf.jumps, opts)
        map("n", "<leader>'", fzf.marks, opts)
        map("n", "<leader>nw", require("enoch.fzf").node_workspaces, opts)
    end,
}
