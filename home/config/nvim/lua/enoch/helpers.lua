local G = {}

function G.nnoremap(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, {
    noremap = true,
    silent = true
  })
end

return G
