---@type (string|LazySpec)[]
local plugins = {
    { "nvim-mini/mini.pairs", version = false, config = true },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
}

return plugins
