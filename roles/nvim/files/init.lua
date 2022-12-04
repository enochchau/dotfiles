pcall(require, "impatient")

require("bulb").setup { debug = true }

if vim.env["FENNEL_COMPILE"] then
    return
end

local autocmd = vim.api.nvim_create_autocmd
local has = vim.fn.has
local g = vim.g
local opt = vim.opt
local cmd = vim.cmd

-- theme
vim.opt.bg = "light"
vim.cmd.colorscheme "tokyonight"

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

-- enable syntax and filetype detection
cmd.syntax "enable"
cmd.filetype "plugin indent on"

-- set tabs to 2 spaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

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
require "enoch.keymaps"
require "enoch.commands"
