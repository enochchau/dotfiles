(local pnp-checker (require :nvim-pnp-checker))
(local lsp-ts-utils (require :nvim-lsp-ts-utils))
(local {: nnoremap : xnoremap} (require :enoch_fnl.helpers))

(fn schema-store [file-name]
  (.. "https://json.schemastore.org/" file-name))

(fn common_on_attach [client bufnr]
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
  (nnoremap :<leader>a (telescope-cmd :lsp_code_actions))
  (xnoremap :<leader>a ":<C-U>Telescope lsp_range_code_actions<CR>")
  (nnoremap :<leader>rn "<cmd>lua vim.lsp.buf.rename()<CR>"))

(fn sumneko_lua [opts]
  (fn get-runtime-path []
    (let [runtime-path (vim.split package.path ";")]
      (table.insert runtime-path :lua/?.lua)
      (table.insert runtime-path :lua/?/init.lua)
      runtime-path))

  (let [root (vim.fn.getcwd)]
    (if (string.match root :nvim)
        ((fn []
           (tset opts :settings
                 {:Lua {:runtime {:version :LuaJIT :path (get-runtime-path)}
                        :diagnostics {:globals [:vim]}
                        :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                            true)}
                        :telemetry {:enable false}}})
           (string.match root :hammerspoon)
           ((fn []
              (tset opts :settings
                    {:Lua {:workspace {:library {:/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/ true}}
                           :diagnostics {:globals [:hs]}
                           :telemetry {:enable false}}})))
           (tset opts :settings {:Lua {:telemetry {:enable false}}})))))
  opts)

(fn eslint [opts]
  (let [common_on_attach opts.on_attach]
    (if (pnp-checker.check_for_pnp)
        (tset opts :cmd (pnp-checker.get_pnp_cmd)))
    (tset opts :on-attach
          (fn [client bufnr]
            (tset client.resolved_capabilities :document_formatting true)
            (common_on_attach client bufnr))))
  opts)

(fn html [opts]
  (tset opts.capabilities.textDocument.completion.completionItem
        :snippetSupport true)
  opts)

(fn cssls [opts]
  (tset opts.capabilities.textDocument.completion.completionItem
        :snippetSupport true)
  opts)

(fn jsonls [opts]
  (fn get-schema [file-match file-url-name]
    {:fileMatch file-match :url (schema-store file-url-name)})

  (tset opts.capabilities.textDocument.completion.completionItem
        :snippetSupport true)
  (tset opts :settings
        {:json {"schemas:" [(get-schema [:package.json] :package.json)
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
                            (get-schema [:lerna.json] :lerna.json)]}})
  (tset opts :on_attach
        (fn [client bufnr]
          (tset client.resolved_capabilities :document_formatting false)
          (tset client.resolved_capabilities :document_range_formatting false)
          (common_on_attach client bufnr)))
  opts)

(fn yamlls [opts]
  (tset opts :settings
        {:schemas {"https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" "docker-compose*.{yml,yaml}"
                   (schema-store :github-workflow.json) ".github/workflows/*.{yml,yaml}"
                   (schema-store :github-action.json) ".github/action.{yml,yaml}"
                   (schema-store :prettierrc.json) ".prettierrc.{yml,yaml}"}})
  (tset opts :on_attach
        (fn [client bufnr]
          (tset client.resolved_capabilities :document_formatting false)
          (common_on_attach client bufnr)))
  opts)

(fn tsserver [opts]
  (tset opts :init_options lsp-ts-utils.init_options)
  (tset opts :on_attach
        (fn [client bufnr]
          (lsp-ts-utils.setup {:auto_inlay_hints false})
          (nnoremap :<leader>o ":TSLspOrganize<CR>")
          (nnoremap :<leader>rf ":TSLspRenameFile<CR>")
          (nnoremap :<leader>i ":TSLspImportAll<CR>")
          (tset client.resolved_capabilities :document_formatting false)
          (tset client.resolved_capabilities :document_range_formatting false)
          (common_on_attach client bufnr)))
  opts)

{: common_on_attach
 : cssls
 : eslint
 : html
 : jsonls
 : sumneko_lua
 : yamlls
 : tsserver}
