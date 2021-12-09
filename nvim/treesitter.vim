lua << EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { 
      'bash', 
      'comment',
      'css',
      'dockerfile',
      'dot',
      'graphql',
      'hcl',
      'html',
      'javascript',
      'jsdoc', 
      'json', 
      'jsonc',
      'julia', 
      'lua', 
      'regex',
      'scss', 
      'svelte', 
      'tsx', 
      'typescript', 
      'vim', 
      'yaml'
    }, 
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
