vim.o.spelllang = "en_us"
vim.o.ignorecase = true
vim.g.mapleader = ","

if vim.g.vscode then
    require("enoch.lazy")
    require("enoch.vscode.keymaps")
else
    vim.o.signcolumn = "yes:1"
    vim.o.laststatus = 3
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.wrap = true
    vim.o.encoding = "utf-8"
    vim.o.mouse = "a"
    vim.o.wildmenu = true
    vim.o.showmatch = false
    vim.o.ruler = true
    vim.o.hidden = true
    vim.o.updatetime = 300
    vim.o.smartcase = true
    vim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"

    vim.o.swapfile = true
    vim.o.writebackup = true
    vim.o.backup = false
    vim.o.backupcopy = "auto"
    vim.o.undofile = true

    -- color column @ 80 chars
    vim.o.colorcolumn = "80"
    -- disable startup screen
    vim.o.shortmess = "I"
    -- true color
    if vim.fn.has("termguicolors") == 1 then
        vim.o.termguicolors = true
    end
    -- highlight all search pattern matches
    vim.o.hlsearch = true
    vim.o.cursorline = true

    -- don't enable syntax because it causes issues with lsp starting
    -- cmd.syntax "enable"
    vim.cmd.filetype("plugin indent on")

    -- set tabs to 2 spaces
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.expandtab = true

    -- netrw
    vim.g.netrw_liststyle = 3
    vim.g.netrw_bufsettings = "nu rnu"
    vim.g.netrw_sort_by = "exten"

    vim.o.shortmess = "IcF"

    -- auto resize
    vim.api.nvim_create_autocmd(
        "VimResized",
        { pattern = "*", command = "wincmd =" }
    )

    local rnu_toggle_id =
        vim.api.nvim_create_augroup("RelativeNumberToggle", { clear = true })

    -- Autocmd to toggle relative number based on mode
    vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = "*",
        callback = function()
            vim.wo.relativenumber = false
        end,
        group = rnu_toggle_id,
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = "*",
        callback = function()
            vim.wo.relativenumber = true
        end,
        group = rnu_toggle_id,
    })

    -- use system clipboard
    -- improved startup times by defining the unnamed clipboard
    if vim.fn.has("mac") == 1 then
        vim.g.clipboard = "pbcopy"
    elseif vim.fn.has("wsl") == 1 then
        vim.g.clipboard = "win32yank"
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
            ["code-workspace"] = "json",
            ["applescript"] = "applescript",
        },
        filename = {
            ["yabairc"] = "sh",
            ["skhdrc"] = "config",
            [".swcrc"] = "json",
        },
        pattern = {
            ["${XDG_CONFIG_HOME}/ghostty/config"] = "ini",
        },
    })

    require("enoch.lazy")
    require("enoch.keymaps")
    require("enoch.commands")
    require("enoch.diagnostic")
    require("enoch.ntl")

    vim.o.bg = "dark"
    vim.cmd.colorscheme("catppuccin-macchiato")
    -- In your init.lua
    if vim.fn.executable("rg") == 1 then
        -- --glob '!node_modules/*' tells ripgrep to ignore that folder
        vim.o.grepprg = "rg --vimgrep --smart-case --glob '!node_modules/*'"
        vim.o.grepformat = "%f:%l:%c:%m"
    end
end
