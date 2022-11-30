vim.api.nvim_create_user_command("BufClear", "%bd|e#|bd#", {})
local function _1_()
  if (vim.opt_local.filetype == "astro") then
    return (require("enoch.format")).format("astro")
  else
    return (require("enoch.format")).format()
  end
end
vim.api.nvim_create_user_command("Format", _1_, {})
local function _3_()
  opt.relativenumber = not opt.relativenumber._value
  return nil
end
vim.api.nvim_create_user_command("SwapNu", _3_, {})
vim.api.nvim_create_user_command("FTermOpen", (require("FTerm")).open, {bang = true})
vim.api.nvim_create_user_command("FTermClose", (require("FTerm")).close, {bang = true})
vim.api.nvim_create_user_command("FTermExit", (require("FTerm")).exit, {bang = true})
return vim.api.nvim_create_user_command("FTermToggle", (require("FTerm")).toggle, {bang = true})