local nnoremap = require("enoch.helpers").nnoremap
local vnoremap = require("enoch.helpers").vnoremap
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local has = vim.fn.has
local mode = vim.fn.mode
local g = vim.g
local opt = vim.opt
local opt_local = vim.opt_local

g.mapleader = ","
opt.signcolumn = "yes:1"
opt.number = true
opt.wrap = true
opt.encoding = "utf-8"
opt.mouse = "a"
opt.wildmenu = true
opt.showmatch = true
opt.laststatus = 2
opt.ruler = true
opt.hidden = true
opt.updatetime = 300
opt.smartcase = true
opt.ignorecase = true
opt.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"
-- color column @ 80 chars
opt.colorcolumn = "80"
-- disable startup screen
opt.shortmess = "I"
-- true color
if has("termguicolors") then
  opt.termguicolors = true
end
-- highlight all search pattern matches
opt.hlsearch = true
opt.cursorline = true
opt.spelllang = "en_us"

-- move vertically by visual line, don't skip wrapped lines
nnoremap("j", "gj")
nnoremap("k", "gk")

-- enable syntax and filetype detection
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- set tabs to 2 spaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Hold visual mode after indent
vnoremap(">", ">gv")
vnoremap("<", "<gv")

-- Maps Alt-[h,j,k,l] to resizing a window split
nnoremap("<A-h>", "<C-w><")
nnoremap("<A-j>", "<C-w>-")
nnoremap("<A-k>", "<C-w>+")
nnoremap("<A-l>", "<C-w>>")

-- auto resize
autocmd("VimResized", { pattern = "*", command = "wincmd =" })

-- use system clipboard
-- improved startup times by defining the unnamed clipboard
if has("mac") == 1 then
  g.clipboard = {
    name = "pbcopy",
    cache_enabled = 0,
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
  }
elseif has("wsl") == 1 then
  g.clipboard = {
    cache_enabled = 0,
    name = "win32yank",
    copy = {
      ["*"] = "win32yank.exe -i --crlf",
      ["+"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["*"] = "win32yank.exe -o --lf",
      ["+"] = "win32yank.exe -o --lf",
    },
  }
end
opt.clipboard = "unnamedplus"

-- traverse buffers
nnoremap("]b", ":bnext<CR>")
nnoremap("[b", ":bprevious<CR>")

-- relative line numbers
local number_toggle = augroup("NumberToggle", {})
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  pattern = "*",
  callback = function()
    if opt_local.number._value and mode() ~= "i" then
      opt_local.relativenumber = true
    end
  end,
  group = number_toggle,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  pattern = "*",
  callback = function()
    if opt_local.number._value then
      opt_local.relativenumber = false
    end
  end,
  group = number_toggle,
})

vim.api.nvim_create_user_command("BufClear", "%bd|e#|bd#", {})

-- detect prolog
local detect_extras = augroup("DetectExtras", {})
autocmd({ "BufRead", "BufNewFile" }, {
  callback = function()
    opt_local.filetype = "prolog"
  end,
  pattern = "*.pro",
  group = detect_extras,
})
