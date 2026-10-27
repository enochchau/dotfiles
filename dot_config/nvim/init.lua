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
    vim.o.mouse = "a"
    vim.o.updatetime = 300
    vim.o.smartcase = true
    vim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"

    vim.o.undofile = true

    -- color column @ 80 chars
    vim.o.colorcolumn = "80"
    -- true color, forced since auto-detection isn't guaranteed inside tmux
    vim.o.termguicolors = true
    vim.o.cursorline = true

    -- set tabs to 2 spaces
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.expandtab = true

    -- netrw
    vim.g.netrw_liststyle = 3
    vim.g.netrw_bufsettings = "nu rnu"
    vim.g.netrw_sort_by = "exten"
    vim.g.netrw_keepdir = 0

    -- I: disable startup screen
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
            ["mdx"] = "markdown",
            ["pro"] = "prolog",
            ["tf"] = "terraform",
            ["zshrc"] = "zsh",
            ["zshenv"] = "zsh",
            ["code-workspace"] = "json",
        },
        filename = {
            ["yabairc"] = "sh",
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

    vim.cmd.colorscheme("catppuccin-macchiato")
    if vim.fn.executable("rg") == 1 then
        -- --glob '!node_modules/*' tells ripgrep to ignore that folder
        -- nvim already sets grepformat to match rg --vimgrep
        vim.o.grepprg = "rg --vimgrep --smart-case --glob '!node_modules/*'"
    end

    if vim.fn.has("nvim-0.12") == 1 then
        require("vim._core.ui2").enable({})
    end
end
