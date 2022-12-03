vim.api.nvim_create_user_command("BufClear", "%bd|e#|bd#", {})
local function _1_()
  return (require("enoch.format")).format(vim.bo.filetype._value)
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
vim.api.nvim_create_user_command("Cdg", _3_, {})
local function open_plugin_link()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local function open_url(url)
    local has = vim.fn.has
    local system = vim.fn.system
    if has("mac") then
      return system(("open " .. url))
    elseif has("wsl") then
      return system(("explorer.exe " .. url))
    elseif has("win32") then
      return system(("start " .. url))
    elseif has("linux") then
      return system(("xdg-open " .. url))
    else
      return nil
    end
  end
  local function get_text_at_cursor()
    return string.gsub(vim.treesitter.query.get_node_text(ts_utils.get_node_at_cursor(), 0), "^[\"'](.*)[\"']$", "%1")
  end
  local function url_3f(url)
    return url:match("^https://")
  end
  local function github_3f(str)
    return str:match("^([a-zA-Z0-9-_.]+)/([a-zA-Z0-9-_.]+)$")
  end
  local text = get_text_at_cursor()
  if url_3f(text) then
    return open_url(text)
  elseif github_3f(text) then
    return open_url(("https://github.com/" .. text))
  else
    return nil
  end
end
return vim.api.nvim_create_user_command("PackerOpen", open_plugin_link, {})