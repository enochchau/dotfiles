local add = MiniDeps.add
local later = MiniDeps.later
local map = vim.keymap.set

add("nvim-mini/mini.pairs")
require("mini.pairs").setup()

add("kylechui/nvim-surround")
later(function()
    require("nvim-surround").setup()
end)

local prettier_fmt = { "prettierd", "prettier" }
add("stevearc/conform.nvim")
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "black" },
        javascript = prettier_fmt,
        typescript = prettier_fmt,
        typescriptreact = prettier_fmt,
        javascriptreact = prettier_fmt,
        css = prettier_fmt,
        scss = prettier_fmt,
        less = prettier_fmt,
        html = prettier_fmt,
        json = prettier_fmt,
        jsonc = prettier_fmt,
        yaml = prettier_fmt,
        markdown = prettier_fmt,
        ["markdown.mdx"] = prettier_fmt,
        graphql = prettier_fmt,
        handlebars = prettier_fmt,
        bash = { "beautysh", "shellcheck" },
        sh = { "beautysh", "shellcheck" },
        zsh = { "beautysh" },
    },
})
map("n", "<leader>f", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
        stop_after_first = true,
    })
end, { desc = "Format buffer", noremap = true })

add("folke/ts-comments.nvim")
require("ts-comments").setup()

add("numToStr/Comment.nvim")
require("Comment").setup()

add("Darazaki/indent-o-matic")
later(require("indent-o-matic").setup({}))

local function build_blink(params)
    vim.notify("Building blink.cmp", vim.log.levels.INFO)
    local obj = vim.system(
        { "cargo", "build", "--release" },
        { cwd = params.path }
    )
        :wait()
    if obj.code == 0 then
        vim.notify("Building blink.cmp done", vim.log.levels.INFO)
    else
        vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
    end
end

add({
    source = "Saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    hooks = {
        post_install = build_blink,
        post_checkout = build_blink,
    },
})
require("blink-cmp").setup({
    keymap = { preset = "super-tab" },
    completion = {
        documentation = {
            auto_show = true,
        },
    },
})
