(local cmp-nvim-lsp (require :cmp_nvim_lsp))
(local lsp-opts (require :enoch_fnl.lsp-opts))
(local lsp-installer (require :nvim-lsp-installer))
(local {: nnoremap} (require :enoch_fnl.helpers))
(local null-ls (require :null-ls))

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

;; lsp client setup
(lsp_installer.on_server_ready (fn [server]
                                 (let [opts-getter (. lsp-opts server.name)]
                                   (if opts-getter
                                       (server:setup (opts-getter))
                                       (server:setup (lsp-opts.create-default-opts))))))

;; null-ls setup
(let [formatting null-ls.builtins.formatting
      diagnostics null_ls.builtins.diagnostics]
  (null-ls.setup {:on_attach lsp-opts.common_on_attach
                  :sources [(formatting.prettierd.with {:env {:PRETTIERD_DEFAULT_CONFIG (vim.fn.expand "~/.config/nvim/.prettierrc")}})
                            formatting.stylua
                            formatting.fnlfmt
                            diagnostics.shellcheck]}))
