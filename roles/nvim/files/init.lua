pcall(require, "impatient")

local nmap = require("enoch.helpers").nmap
local vmap = require("enoch.helpers").vmap
local autocmd = vim.api.nvim_create_autocmd
local fmt = require "enoch.format"
local augroup = vim.api.nvim_create_augroup
local has = vim.fn.has
local g = vim.g
local opt = vim.opt
local cmd = vim.cmd

g.mapleader = ","
opt.signcolumn = "yes:1"
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.wrap = true
opt.encoding = "utf-8"
opt.mouse = "a"
opt.wildmenu = true
opt.showmatch = false
opt.ruler = true
opt.hidden = true
opt.updatetime = 300
opt.smartcase = true
opt.ignorecase = true
opt.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"

opt.swapfile = true
opt.writebackup = true
opt.backup = false
opt.backupcopy = "auto"
opt.undofile = true

-- color column @ 80 chars
opt.colorcolumn = "80"
-- disable startup screen
opt.shortmess = "I"
-- true color
if has "termguicolors" then
    opt.termguicolors = true
end
-- highlight all search pattern matches
opt.hlsearch = true
opt.cursorline = true
opt.spelllang = "en_us"

-- move vertically by visual line, don't skip wrapped lines
nmap("j", "gj")
nmap("k", "gk")

-- enable syntax and filetype detection
cmd.syntax "enable"
cmd.filetype "plugin indent on"

-- set tabs to 2 spaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Hold visual mode after indent
vmap(">", ">gv")
vmap("<", "<gv")

-- Maps Alt-[h,j,k,l] to resizing a window split
nmap("<A-h>", "<C-w><")
nmap("<A-j>", "<C-w>-")
nmap("<A-k>", "<C-w>+")
nmap("<A-l>", "<C-w>>")

-- auto resize
autocmd("VimResized", { pattern = "*", command = "wincmd =" })

-- use system clipboard
-- improved startup times by defining the unnamed clipboard
if has "mac" == 1 then
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
elseif has "wsl" == 1 then
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
nmap("]b", ":bnext<CR>")
nmap("[b", ":bprevious<CR>")

-- Clear all but the current buffer
vim.api.nvim_create_user_command("BufClear", "%bd|e#|bd#", {})

-- Format cmd
vim.api.nvim_create_user_command("Format", function()
    if vim.opt_local.filetype == "astro" then
        fmt.format "astro"
    else
        fmt.format()
    end
end, {})

-- swap nu to rnu and visa versa
vim.api.nvim_create_user_command("SwapNu", function()
    opt.relativenumber = not opt.relativenumber._value
end, {})

-- Configure additional filetypes
vim.filetype.add {
    extension = {
        ["cr"] = "crystal",
        ["mdx"] = "markdown",
        ["pro"] = "prolog",
        ["tf"] = "terraform",
    },
    filename = {
        ["yabairc"] = "sh",
        ["skhdrc"] = "config",
    },
}

require "enoch.plugins"

require "enoch.alpha"
require "enoch.theme"
require "enoch.lsp"
require "enoch.filetree"

require "enoch.cmp"
require "enoch.format"
require "enoch.statusline"
require "enoch.telescope"
require "enoch.term"
require "enoch.treesitter"

vim.cmd "source ~/.config/nvim/rzip.vim"
