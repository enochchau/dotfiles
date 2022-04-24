(local pnp-checker (require :nvim-pnp-checker))
(local {: nnoremap : xnoremap} (require :enoch_fnl.helpers))

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

(fn sumneko_lua []
  (let [runtime_path (vim.split package.path ";")
        root (vim.fn.getcwd)
        opts {:settings {:Lua {:telemetry {:enable false}}}}]
    (table.insert runtime_path :lua/?.lua)
    (table.insert runtime_path :lua/?/init.lua)
    (if (string.match root :nvim)
        ((fn []
           (tset opts.settings.Lua :runtime
                 {:version :LuaJIT :path runtime_path})
           (tset opts.settings.Lua :diagnostics {:globals [:vim]})
           (tset opts.settings.Lua :workspace
                 {:library (vim.api.nvim_get_runtime_file "" true)})))
        (string.match root :hammerspoon)
        ((fn []
           (tset opts.settings.Lua :workspace
                 {:library {:/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/ true}})
           (tset opts.settings.Lua :diagnostics {:globals [:hs]}))))
    opts))

(fn eslint []
  (fn on-attach [client bufnr]
    (tset client.resolved_capabilities :document_formatting true)
    (common_on_attach client bufnr))

  (let [opts {:on_attach on-attach}]
    (if (pnp-checker.check_for_pnp) (tset opts :cmd (pnp-checker.get_pnp_cmd)))
    opts))

{: sumneko_lua : common_on_attach}
