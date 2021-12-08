lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript", "bash", "jsdoc", "json", "julia", "lua", "scss", "svelte", "tsx", "vim", "yaml", "css"}, 
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  }
}
EOF
