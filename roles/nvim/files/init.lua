local autocmd = vim.api.nvim_create_autocmd
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

-- enable syntax and filetype detection
cmd.syntax "enable"
cmd.filetype "plugin indent on"

-- set tabs to 2 spaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- netrw
g.netrw_liststyle = 3
g.netrw_bufsettings = "nu rnu"
g.netrw_sort_by = "exten"

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

require "enoch.lazy"
require "enoch.keymaps"
require "enoch.commands"

-- theme
opt.bg = "dark"
vim.cmd.colorscheme "onedark"

-- use floating input for renaming stuff
vim.ui.input = function(opts, on_confirm)
    local prompt = opts.prompt or "Input: "
    local default = opts.default or ""

    -- Calculate a minimal width with a bit buffer
    local default_width = vim.str_utfindex(default) + 10
    local prompt_width = vim.str_utfindex(prompt) + 10
    local win_width = default_width > prompt_width and default_width
        or prompt_width

    local win_config = {
        relative = "cursor",
        row = 1,
        col = 0,
        width = win_width,
        height = 1,
        focusable = true,
        style = "minimal",
        border = "single",
    }
    if vim.fn.has("nvim-0.9") == 1 then
        win_config.title = prompt
    end


    local buffer = vim.api.nvim_create_buf(false, true)
    local window = vim.api.nvim_open_win(buffer, true, win_config)
    vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { opts.default })

    -- Put cursor at the end of the default value
    vim.cmd "startinsert"
    vim.api.nvim_win_set_cursor(window, { 1, vim.str_utfindex(default) + 1 })

    -- Enter to confirm
    vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
        local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
        if on_confirm then
            on_confirm(lines[1])
        end
        vim.api.nvim_win_close(window, true)
        vim.cmd "stopinsert"
    end, { buffer = buffer })

    -- Esc to close
    vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave" }, {
        buffer = buffer,
        callback = function()
            vim.api.nvim_win_close(window, true)
            vim.cmd "stopinsert"
        end,
    })
end
