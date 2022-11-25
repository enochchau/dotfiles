local function gen_map(modes)
  local function _1_(lhs, rhs, buffer)
    return vim.keymap.set(modes, lhs, rhs, {noremap = true, silent = true, buffer = buffer})
  end
  return _1_
end
local function _2_(modes, lhs, rhs, buffer)
  return gen_map(modes)(lhs, rhs, buffer)
end
return {nmap = gen_map("n"), vmap = gen_map("v"), xmap = gen_map("x"), tmap = gen_map("t"), map = _2_}
