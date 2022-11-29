local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {noremap = true, silent = true})
  vim.keymap.set("n", "gd", (require("telescope.builtin")).lsp_definitions, {noremap = true, silent = true})
  vim.keymap.set("n", "gi", (require("telescope.builtin")).lsp_implementations, {noremap = true, silent = true})
  vim.keymap.set("n", "gy", (require("telescope.builtin")).lsp_type_definitions, {noremap = true, silent = true})
  vim.keymap.set("n", "gr", (require("telescope.builtin")).lsp_references, {noremap = true, silent = true})
  vim.keymap.set("n", "gs", (require("telescope.builtin")).lsp_document_symbols, {noremap = true, silent = true})
  local function _1_()
    return (require("enoch.format")).format(client.name)
  end
  vim.keymap.set({"x", "n"}, "<leader>f", _1_, {noremap = true, silent = true})
  vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, {noremap = true, silent = true})
  vim.keymap.set("n", "g]", vim.diagnostic.goto_next, {noremap = true, silent = true})
  local function _2_()
    return (require("telescope.builtin")).diagnostics({bufnr = 0})
  end
  vim.keymap.set("n", "ga", _2_, {noremap = true, silent = true})
  vim.keymap.set("n", "gw", (require("telescope.builtin")).diagnostics, {noremap = true, silent = true})
  vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, {noremap = true, silent = true})
  vim.keymap.set("x", "<Plug>(leap-backward-x)", ":<C-U>lua vim.lsp.buf.range_code_action()<CR>", {noremap = true, silent = true})
  return vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {noremap = true, silent = true})
end
return {["on-attach"] = on_attach}