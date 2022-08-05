local pnp_checker = require "nvim-pnp-checker"
local schemastore = require "schemastore"
local telescope_builtin = require "telescope.builtin"
local lsp_ts_utils = require "nvim-lsp-ts-utils"
local nmap = require("enoch.helpers").nmap
local xmap = require("enoch.helpers").xmap
local cmp_nvim_lsp = require "cmp_nvim_lsp"

require("lsp-inlayhints").setup()

local function common_on_attach(client, bufnr)
    require("lsp-inlayhints").on_attach(bufnr, client, false)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    nmap("gd", telescope_builtin.lsp_definitions)
    nmap("K", vim.lsp.buf.hover)
    nmap("gi", telescope_builtin.lsp_implementations)
    nmap("gy", telescope_builtin.lsp_type_definitions)
    nmap("gr", telescope_builtin.lsp_references)
    nmap("gs", telescope_builtin.lsp_document_symbols)

    xmap("<leader>f", ":<C-U>lua vim.lsp.buf.range_formatting()<CR>")
    nmap("<leader>f", vim.lsp.buf.format)

    nmap("[g", vim.diagnostic.goto_prev)
    nmap("g]", vim.diagnostic.goto_next)
    nmap("ga", function()
        telescope_builtin.diagnostics { bufnr = 0 }
    end)
    nmap("gw", telescope_builtin.diagnostics)

    nmap("<leader>a", vim.lsp.buf.code_action)
    xmap("<leader>a", ":<C-U>lua vim.lsp.buf.range_code_action()<CR>")
    nmap("<leader>rn", vim.lsp.buf.rename)
end

--- create cmp-nvim-lsp client capabilities
---@param opts table?
local function create_capabilities(opts)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if opts and opts.add_snippet_support then
        capabilities.textDocument.completion.completionItem.snippetSupport =
            true
    end
    return cmp_nvim_lsp.update_capabilities(capabilities)
end

local function create_on_attach(opts)
    return common_on_attach
end

---create default lsp client opts
---@param opts table?
---@return table
local function create_default_opts(opts)
    return {
        on_attach = create_on_attach(opts),
        capabilities = create_capabilities(opts),
    }
end

local function sumneko_lua()
    local function get_runtime_path()
        local runtime_path = vim.split(package.path, ";")
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")
        return runtime_path
    end

    local root = vim.fn.getcwd()
    local opts = create_default_opts {}

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

local function eslint()
    local opts = create_default_opts()

    opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        common_on_attach(client, bufnr)
    end

    local pnp_path = pnp_checker.find_pnp()
    if pnp_path then
        opts.cmd = pnp_checker.get_eslint_pnp_cmd(pnp_path)
    end

    return opts
end

local function html()
    local opts = create_default_opts { add_snippet_support = true }
    return opts
end

local function cssls()
    local opts = create_default_opts { add_snippet_support = true }
    return opts
end

local function jsonls()
    local opts = create_default_opts {
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

local function yammls()
    local opts = create_default_opts {}

    local jsonls_schemas = schemastore.json.schemas()
    local schemas = {}
    for _, schema in ipairs(jsonls_schemas) do
        schemas[schema.url] = schema.fileMatch
    end

    opts.settings = { schemas }
    return opts
end

local function tsserver()
    local opts = create_default_opts {}
    local original_on_attach = opts.on_attach

    opts.on_attach = function(client, bufnr)
        lsp_ts_utils.setup { auto_inlay_hints = false }
        lsp_ts_utils.setup_client(client)

        nmap("<leader>o", ":TSLspOrganize<CR>")
        nmap("<leader>rf", ":TSLspRenameFile<CR>")
        nmap("<leader>i", ":TSLspImportAll<CR>")

        original_on_attach(client, bufnr)
    end

    opts.init_options = lsp_ts_utils.init_options

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

return {
    common_on_attach = common_on_attach,
    create_default_opts = create_default_opts,
    sumneko_lua = sumneko_lua,
    eslint = eslint,
    html = html,
    cssls = cssls,
    jsonls = jsonls,
    yammls = yammls,
    tsserver = tsserver,
}
