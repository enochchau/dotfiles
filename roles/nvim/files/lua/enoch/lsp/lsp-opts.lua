local pnp_checker = require "nvim-pnp-checker"
local schemastore = require "schemastore"
local cmp_nvim_lsp = require "cmp_nvim_lsp"

local M = {}

function M.common_on_attach(client, bufnr)
    local map = vim.keymap.set
    local map_opts = { noremap = true, silent = true }

    local telescope = require "telescope.builtin"

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    map("n", "K", vim.lsp.buf.hover, map_opts)
    map("n", "gd", telescope.lsp_definitions, map_opts)
    map("n", "gi", telescope.lsp_implementations, map_opts)
    map("n", "gy", telescope.lsp_type_definitions, map_opts)
    map("n", "gr", telescope.lsp_references, map_opts)
    map("n", "gs", telescope.lsp_document_symbols, map_opts)
    map({ "x", "n" }, "<leader>f", function()
        require("enoch.format").format(client.name)
    end, map_opts)
    map("n", "[g", vim.diagnostic.goto_prev, map_opts)
    map("n", "g]", vim.diagnostic.goto_next, map_opts)
    map("n", "ga", function()
        return telescope.diagnostics { bufnr = 0 }
    end, map_opts)
    map("n", "gw", telescope.diagnostics, map_opts)
    map("n", "<leader>a", vim.lsp.buf.code_action, map_opts)
    map(
        "x",
        "<leader>a",
        ":<C-U>lua vim.lsp.buf.range_code_action()<CR>",
        map_opts
    )
    return map("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
end

---create default lsp client opts
---@param opts table?
---@return table
function M.create_default_opts(opts)
    -- create cmp capabilities
    local capabilities = cmp_nvim_lsp.default_capabilities()
    if opts and opts.add_snippet_support then
        capabilities.textDocument.completion.completionItem.snippetSupport =
            true
    end

    return {
        on_attach = M.common_on_attach,
        capabilities = capabilities,
    }
end

function M.sumneko_lua()
    local function get_runtime_path()
        local runtime_path = vim.split(package.path, ";")
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")
        return runtime_path
    end

    local root = vim.fn.getcwd()
    local opts = M.create_default_opts {}

    if string.match(root, "nvim") then
        opts.settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = get_runtime_path() },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
            },
        }
    elseif string.match(root, "hammerspoon") then
        opts.settings = {
            Lua = {
                diagnostics = { globals = { "hs" } },
                workspace = {
                    library = {
                        "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
                    },
                },
                telemetry = { enable = false },
            },
        }
    else
        opts.settings = {
            Lua = {
                telemetry = { enable = false },
            },
        }
    end

    return opts
end

function M.eslint()
    local opts = M.create_default_opts()

    opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        M.common_on_attach(client, bufnr)
    end

    local pnp_path = pnp_checker.find_pnp()
    if pnp_path then
        opts.cmd = pnp_checker.get_eslint_pnp_cmd(pnp_path)
    end

    return opts
end

function M.html()
    local opts = M.create_default_opts { add_snippet_support = true }
    return opts
end

function M.cssls()
    local opts = M.create_default_opts { add_snippet_support = true }
    return opts
end

function M.jsonls()
    local opts = M.create_default_opts {
        add_snippet_support = true,
    }

    opts.settings = {
        json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
        },
    }

    return opts
end

function M.yamlls()
    local opts = M.create_default_opts {}
    local jsonschemas = schemastore.json.schemas()
    local schemas = {}

    for _, schema in ipairs(jsonschemas) do
        schemas[schema.url] = schema.fileMatch
    end
    opts.settings = { schemas = schemas }
    return opts
end

function M.tsserver()
    local opts = M.create_default_opts {}

    local inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
    }
    opts.settings = {
        typescript = { inlayHints = inlayHints },
        javascript = { inlayHints = inlayHints },
    }

    return opts
end

return M
