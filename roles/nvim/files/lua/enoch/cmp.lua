local luasnip = require "luasnip"
local lspkind = require "lspkind"
local cmp = require "cmp"

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api
                .nvim_buf_get_lines(0, line - 1, line, true)[1]
                :sub(col, col)
                :match "%s"
            == nil
end

---@param ... table
---@return table
local function source_group(...)
    local t = {}
    for _, value in ipairs { ... } do
        table.insert(t, { name = value })
    end
    return t
end

cmp.setup.cmdline("/", {
    sources = source_group "buffer",
    mapping = cmp.mapping.preset.cmdline(),
})

cmp.setup.cmdline(":", {
    sources = cmp.config.sources(source_group "path", source_group "cmdline"),
    mapping = cmp.mapping.preset.cmdline(),
})

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    },
    sources = cmp.config.sources(
        source_group("nvim_lsp", "luasnip"),
        source_group "buffer",
        source_group "path",
        source_group "spell"
    ),
    formatting = {
        format = lspkind.cmp_format {
            preset = "default",
            mode = "symbol_text",
        },
    },
}
