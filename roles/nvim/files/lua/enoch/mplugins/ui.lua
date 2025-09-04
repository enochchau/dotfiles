local add = MiniDeps.add
local later = MiniDeps.later

add("j-hui/fidget.nvim")
add({
    source = "lukas-reineke/indent-blankline.nvim",
    depends = { "nvim-treesitter/nvim-treesitter" },
})
later(function()
    require("ibl").setup({
        scope = { enabled = true },
        exclude = { filetypes = { "alpha" } },
    })
end)

add("catgoose/nvim-colorizer.lua")
later(function()
    require("colorizer").setup({
        lazy_load = true,
        filetypes = {
            "javascript",
            "javascriptreact",
            "svelte",
            "astro",
            "html",
            "typescript",
            "typescriptreact",
            "css",
            "scss",
        },
        user_default_options = { mode = "virtualtext" },
    })
end)

add({ source = "goolord/alpha-nvim" })
local alpha = require("alpha")
local startify = require("alpha.themes.startify")
local fortune = require("alpha.fortune")

-- ---@param message table
local function cowsays(message)
    local says = {
        "                         ",
        "    o                    ",
        "     o   ^__^            ",
        "      o  (oo)\\_______    ",
        "         (__)\\       )\\/\\",
        "             ||----w |   ",
        "             ||     ||   ",
    }

    for _, str in ipairs(says) do
        table.insert(message, str)
    end

    return message
end

-- ---@param message table
-- local function tuxsays(message)
--     local says = {
--         "    o              ",
--         "     o     .--.    ",
--         "      o   |o_o |   ",
--         "          |:_/ |   ",
--         "         //   \\ \\  ",
--         "        (|     | ) ",
--         "       /'\\_   _/`\\ ",
--         "       \\___)=(___/ ",
--     }

--     for _, str in ipairs(says) do
--         table.insert(message, str)
--     end

--     return message
-- end

startify.section.header.val = cowsays(fortune())
alpha.setup(startify.config)

add("nvim-lualine/lualine.nvim")
local lualine = require("lualine")

local winbar = {
    lualine_c = {
        function()
            return vim.fn.expand("%:~:.")
        end,
    },
}

lualine.setup({
    sections = {
        lualine_b = {
            "branch",
            "diff",
            { "diagnostics", sources = { "nvim_diagnostic" } },
        },
        lualine_c = {
            "%{ObsessionStatus('󰆓 ', '󰆓 ')}",
            "filename",
        },
    },
    options = {
        globalstatus = true,
        section_separators = "",
        component_separators = "│",
    },
    winbar = winbar,
    inactive_winbar = winbar,
})
