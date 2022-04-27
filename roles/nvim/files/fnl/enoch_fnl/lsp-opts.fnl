(local pnp-checker (require :nvim-pnp-checker))
(local lsp-ts-utils (require :nvim-lsp-ts-utils))
(local {: nnoremap : xnoremap} (require :enoch_fnl.helpers))
(local cmp-nvim-lsp (require :cmp_nvim_lsp))

(fn schema-store [file-name]
  (.. "https://json.schemastore.org/" file-name))

(fn common-on-attach [client bufnr]
  "add buffer mappings for lsp client on-attach"
  (fn telescope-cmd [picker]
    (.. "<cmd>lua require\"telescope.builtin\"." picker "()<CR>"))

  (vim.api.nvim_buf_set_option bufnr :omnifunc "v:lua.vim.lsp.omnifunc")
  (nnoremap :gd (telescope-cmd :lsp_definitions))
  (nnoremap :K "<cmd>lua vim.lsp.buf.hover()<CR>")
  (nnoremap :gi (telescope-cmd :lsp_implementations))
  (nnoremap :gy (telescope-cmd :lsp_type_definitions))
  (nnoremap :gr (telescope-cmd :lsp_references))
  (nnoremap :gs (telescope-cmd :lsp_document_symbols))
  (nnoremap "[g" "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  (nnoremap "]g" "<cmd>lua vim.diagnostic.goto_next()<CR>")
  (xnoremap :<leader>f ":<C-U>lua vim.lsp.buf.range_formatting()<CR>")
  (nnoremap :<leader>f "<cmd>lua vim.lsp.buf.formatting()<CR>")
  (nnoremap :ga "<cmd>Telescope diagnostics bufnr=0<CR>")
  (nnoremap :gc "<cmd>Telescope diagnostics<CR>")
  (nnoremap :<leader>a "<cmd>lua vim.lsp.buf.code_action()<CR>")
  (xnoremap :<leader>a ":<C-U>lua vim.lsp.buf.range_code_action()<CR>")
  (nnoremap :<leader>rn "<cmd>lua vim.lsp.buf.rename()<CR>"))

(fn create-capabilities []
  "create cmp-nvim-lsp client capabilities"
  (-> (vim.lsp.protocol.make_client_capabilities)
      (cmp-nvim-lsp.update_capabilities)))

(fn create-default-opts []
  "create default lsp client opts"
  {:on_attach common-on-attach :capabilities (create-capabilities)})

(fn add-snippet-support [capabilities]
  (tset capabilities.textDocument.completion.completionItem :snippetSupport
        true)
  capabilities)

;; SERVER CONFIG start

(fn sumneko_lua []
  (fn get-runtime-path []
    "get neovim runtime path"
    (let [runtime-path (vim.split package.path ";")]
      (table.insert runtime-path :lua/?.lua)
      (table.insert runtime-path :lua/?/init.lua)
      runtime-path))

  (let [root (vim.fn.getcwd)
        opts (create-default-opts)]
    (if (string.match root :nvim)
        (tset opts :settings
              {:Lua {:runtime {:version :LuaJIT :path (get-runtime-path)}
                     :diagnostics {:globals [:vim]}
                     :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                         true)}
                     :telemetry {:enable false}}})
        (string.match root :hammerspoon)
        (tset opts :settings
              {:Lua {:workspace {:library {:/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/ true}}
                     :diagnostics {:globals [:hs]}
                     :telemetry {:enable false}}})
        (tset opts :settings {:Lua {:telemetry {:enable false}}}))
    opts))

(fn eslint []
  (fn on-attach [client bufnr]
    (tset client.resolved_capabilities :document_formatting true)
    (common-on-attach client bufnr))

  (let [opts {:capabilities (create-capabilities) :on_attach on-attach}]
    (if (pnp-checker.check_for_pnp)
        (tset opts :cmd (pnp-checker.get_pnp_cmd)))
    opts))

(fn html []
  (let [opts (create-default-opts)]
    (add-snippet-support opts.capabilities)
    opts))

(fn cssls []
  (let [opts (create-default-opts)]
    (add-snippet-support opts.capabilities)
    opts))

(fn jsonls [opts]
  (fn get-schema [file-match file-url-name]
    {:fileMatch file-match :url (schema-store file-url-name)})

  {:capabilities (add-snippet-support (create-capabilities))
   :settings {:json {"schemas:" [(get-schema [:package.json] :package.json)
                                 (get-schema [:tsconfig*.json] :tsconfig.json)
                                 (get-schema [:.prettierrc
                                              :.prettierrc.json
                                              :prettier.config.json]
                                             :prettierrc.json)
                                 (get-schema [:.eslintrc :.eslintrc.json]
                                             :eslintrc.json)
                                 (get-schema [:.babelrc
                                              :.babelrc.json
                                              :babel.config.json]
                                             :babelrc.json)
                                 (get-schema [:lerna.json] :lerna.json)]}}
   :on_attach (fn [client bufnr]
                ;; use prettier through null-ls for formatting
                (tset client.resolved_capabilities :document_formatting false)
                (tset client.resolved_capabilities :document_range_formatting
                      false)
                (common-on-attach client bufnr))})

(fn yamlls []
  {:capabilities (create-capabilities)
   :settings {:schemas {"https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" "docker-compose*.{yml,yaml}"
                        (schema-store :github-workflow.json) ".github/workflows/*.{yml,yaml}"
                        (schema-store :github-action.json) ".github/action.{yml,yaml}"
                        (schema-store :prettierrc.json) ".prettierrc.{yml,yaml}"}}
   :on_attach (fn [client bufnr]
                (tset client.resolved_capabilities :document_formatting false)
                (common-on-attach client bufnr))})

(fn tsserver []
  (fn on-attach [client bufnr]
    ;; setup nvim-lsp-ts-utils
    (lsp-ts-utils.setup {:auto_inlay_hints false})
    (lsp-ts-utils.setup client)
    (nnoremap :<leader>o ":TSLspOrganize<CR>")
    (nnoremap :<leader>rf ":TSLspRenameFile<CR>")
    (nnoremap :<leader>i ":TSLspImportAll<CR>")
    ;; use prettierd and eslint for formatting
    (tset client.resolved_capabilities :document_formatting false)
    (tset client.resolved_capabilities :document_range_formatting false)
    (common-on-attach client bufnr))

  {:init_options lsp-ts-utils.init_options
   :on_attach on-attach
   :capabilities (create-capabilities)})

{: common-on-attach
 : create-default-opts
 : cssls
 : eslint
 : html
 : jsonls
 : sumneko_lua
 : yamlls
 : tsserver}
