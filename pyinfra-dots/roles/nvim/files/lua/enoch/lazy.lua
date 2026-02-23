local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

if vim.g.vscode then
    require("lazy").setup("enoch.vscode.plugins", {
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "matchparen",
                    "netrwPlugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
    })
else
    require("lazy").setup("enoch.plugins", {
        performance = {
            rtp = {
                disabled_plugins = {
                    "tutor",
                    "tohtml",
                },
            },
        },
    })
end
