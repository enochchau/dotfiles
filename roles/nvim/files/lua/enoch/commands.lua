vim.api.nvim_create_user_command("BufClear", "%bd|e#|bd#", {})
local function _1_()
  return (require("enoch.format")).format(vim.opt_local.filetype)
end
vim.api.nvim_create_user_command("Format", _1_, {})
local function _2_()
  opt.relativenumber = not opt.relativenumber._value
  return nil
end
vim.api.nvim_create_user_command("SwapNu", _2_, {})
vim.api.nvim_create_user_command("FTermOpen", (require("FTerm")).open, {bang = true})
vim.api.nvim_create_user_command("FTermClose", (require("FTerm")).close, {bang = true})
vim.api.nvim_create_user_command("FTermExit", (require("FTerm")).exit, {bang = true})
vim.api.nvim_create_user_command("FTermToggle", (require("FTerm")).toggle, {bang = true})
local function _3_()
  return vim.api.nvim_set_current_dir(vim.trim(vim.fn.system("git rev-parse --show-toplevel")))
end
return vim.api.nvim_create_user_command("Cdg", _3_, {})