(local cmp-nvim-lsp (require :cmp_nvim_lsp))
(local lsp-opts (require :enoch_fnl.lsp-opts))
(local lsp-installer (require :nvim-lsp-installer))
(local {: nnoremap : xnoremap : table-merge} (require :enoch_fnl.helpers))
(local null-ls (require :null-ls))

(fn telescope-cmd [picker]
  (.. "<cmd>lua require\"telescope.builtin\"." picker "()<CR>"))

(fn common_on_attach [client bufnr]
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

(fn enable-icon-signs []
  (let [signs {:Error " " :Warn " " :Hint " " :Info " "}]
    (each [type icon (pairs signs)]
      (let [hl (.. :DiagnosticSign type)]
        (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl})))))

(fn remap-diagnostic []
  (vim.diagnostic.config {:virtual_text false})
  (nnoremap :<leader>d
            "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>"))

(fn install-language-server [name]
  "install a language server if it is missing"
  (fn is-server-missing [server-is-found server]
    (and server_is_found (not (server:is_installed))))

  (fn install-server [name server]
    (print (.. "Installing " name))
    (server:install))

  (let [(server-is-found server) (lsp-installer.get_server name)]
    (if (is-server-missing server-is-found server) (install-server name server))))

(enable-icon-signs)
(remap-diagnostic)
(let [servers [:ansiblels
               :bashls
               :cssls
               :eslint
               :gopls
               :html
               :jsonls
               :sumneko_lua
               :terraformls
               :tsserver
               :vimls
               :yamlls
               :zls]]
  (each [index name (ipairs servers)]
    (install-language-server name)))

(let [capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                       (cmp-nvim-lsp.update_capabilities))]
  (lsp_installer.on_server_ready (fn [server]
                                   (let [opts {:on_attach common_on_attach
                                               : capabilities}]
                                     (if (. lsp-opts server.name)
                                         (table-merge opts
                                                      ((. lsp-opts server.name))))
                                     (server:setup opts)))))

(let [formatting null-ls.builtins.formatting]
  (null-ls.setup {:on_attach common_on_attach
                  :sources [(formatting.prettierd.with {:env {:PRETTIERD_DEFAULT_CONFIG (vim.fn.expand "~/.config/nvim/.prettierrc")}})
                            formatting.stylua
                            formatting.fnlfmt]}))
