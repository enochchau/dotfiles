local g = vim.g
local opt = vim.opt

opt.spelllang = "en_us"
opt.ignorecase = true
g.mapleader = ","

if g.vscode then
    require("enoch.lazy")
    require("enoch.vscode.keymaps")
else
    local autocmd = vim.api.nvim_create_autocmd
    local has = vim.fn.has
    local cmd = vim.cmd

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
    if has("termguicolors") then
        opt.termguicolors = true
    end
    -- highlight all search pattern matches
    opt.hlsearch = true
    opt.cursorline = true

    -- don't enable syntax because it causes issues with lsp starting
    -- cmd.syntax "enable"
    cmd.filetype("plugin indent on")

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

    local rnu_toggle_id =
        vim.api.nvim_create_augroup("RelativeNumberToggle", { clear = true })

    -- Autocmd to toggle relative number based on mode
    autocmd("InsertEnter", {
        pattern = "*",
        callback = function()
            vim.wo.relativenumber = false
        end,
        group = rnu_toggle_id,
    })
    autocmd("InsertLeave", {
        pattern = "*",
        callback = function()
            vim.wo.relativenumber = true
        end,
        group = rnu_toggle_id,
    })

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

    -- Configure additional filetypes
    vim.filetype.add({
        extension = {
            ["cr"] = "crystal",
            ["mdx"] = "mdx",
            ["pro"] = "prolog",
            ["tf"] = "terraform",
            ["zshrc"] = "zsh",
            ["zshenv"] = "zsh",
            ["applescript"] = "applescript",
        },
        filename = {
            ["yabairc"] = "sh",
            ["skhdrc"] = "config",
            [".swcrc"] = "json",
            [vim.env.XDG_CONFIG_HOME .. "/ghostty/config"] = "ini",
        },
    })

    require("enoch.deps")
    require("enoch.keymaps")
    require("enoch.commands")
    require("enoch.diagnostic")

    opt.bg = "dark"
    cmd.colorscheme("catppuccin-macchiato")
end
