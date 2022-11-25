local function _1_(lhs_2_auto, rhs_3_auto, buffer_4_auto)
  return vim.keymap.set("n", lhs_2_auto, rhs_3_auto, {buffer = buffer_4_auto, noremap = true, silent = true})
end
local function _2_(lhs_2_auto, rhs_3_auto, buffer_4_auto)
  return vim.keymap.set("v", lhs_2_auto, rhs_3_auto, {buffer = buffer_4_auto, noremap = true, silent = true})
end
local function _3_(lhs_2_auto, rhs_3_auto, buffer_4_auto)
  return vim.keymap.set("x", lhs_2_auto, rhs_3_auto, {buffer = buffer_4_auto, noremap = true, silent = true})
end
local function _4_(lhs_2_auto, rhs_3_auto, buffer_4_auto)
  return vim.keymap.set("t", lhs_2_auto, rhs_3_auto, {buffer = buffer_4_auto, noremap = true, silent = true})
end
local function _5_(modes, lhs, rhs, buffer)
  local function _6_(lhs_2_auto, rhs_3_auto, buffer_4_auto)
    return vim.keymap.set(modes, lhs_2_auto, rhs_3_auto, {buffer = buffer_4_auto, noremap = true, silent = true})
  end
  return _6_(lhs, rhs, buffer)
end
return {nmap = _1_, vmap = _2_, xmap = _3_, tmap = _4_, map = _5_}
