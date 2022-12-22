local ft = {
    "javascript",
    "javascriptreact",
    "svelte",
    "astro",
    "typescript",
    "typescriptreact",
    "css",
    "scss",
}

---@type LazyPlugin
local M = {
    "NvChad/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup {
            filetypes = ft,
            user_default_options = {
                names = false,
                mode = "virtualtext",
            },
        }
    end,
    ft = ft,
}
return M
