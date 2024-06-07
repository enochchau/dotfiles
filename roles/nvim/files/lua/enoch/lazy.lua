local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("enoch.plugins", {
    performance = {
        rtp = {
            disabled_plugins = {
                "tutor",
                "tohtml",
            },
        },
    },
    dev = {
        path = "~/code",
        patterns = { "ec965" },
    },
})
