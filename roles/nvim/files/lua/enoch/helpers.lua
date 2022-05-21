local M = {}

M.nnoremap = function(lhs, rhs, buffer)
  vim.keymap.set(
    "n",
    lhs,
    rhs,
    { noremap = true, silent = true, buffer = buffer }
  )
end

M.xnoremap = function(lhs, rhs, buffer)
  vim.keymap.set(
    "x",
    lhs,
    rhs,
    { noremap = true, silent = true, buffer = buffer }
  )
end

---@param theme string
M.colo = function(theme)
  vim.cmd("colo " .. theme)
end

return M
