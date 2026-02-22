---@type LazySpec
return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    opts = {},
    config = function()
        local FzfLua = require("fzf-lua")
        FzfLua.setup({
            lsp = {
                code_actions = {
                    prompt = "Actions> ",
                    -- This is the secret sauce
                    winopts = {
                        relative = "cursor", -- Open at the cursor position
                        row = 1, -- One line below the cursor
                        col = 0,
                        height = 0.25, -- Keep it short
                        width = 0.55, -- Keep it narrow
                        preview = {
                            vertical = "down:70%", -- Preview shows below the list
                            layout = "vertical",
                        },
                    },
                },
            },
        })
        local map = vim.keymap.set
        FzfLua.register_ui_select()

        map("n", "<C-p>", FzfLua.global, { silent = true })
        map("n", "<C-f>", FzfLua.grep, { silent = true })
        map("n", "z=", FzfLua.spell_suggest, { silent = true })
        map("n", "<leader>o", FzfLua.jumps, { silent = true })
        map("n", "<leader>'", FzfLua.marks, { silent = true })
    end,
}
