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
    'query',
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
    additional_vim_regex_highlighting = false
  },
  autotag = {
    enable = true
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
