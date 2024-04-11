local command = vim.api.nvim_create_user_command
local fn = vim.fn
local open = require "enoch.open"
local colorscheme = require "enoch.colorscheme"

command("BufClear", "%bd|e#|bd#", {})

-- command("Format", function()
--     return (require "enoch.format").format(vim.bo.filetype)
-- end, {})

command("SwapNu", function()
    vim.opt.relativenumber = not vim.opt.relativenumber._value
    return nil
end, {})

command("Cdg", function()
    return vim.api.nvim_set_current_dir(
        vim.trim(fn.system "git rev-parse --show-toplevel")
    )
end, {})

command("PluginOpen", open.plugin_link, {})
command("SaveColor", colorscheme.save_color, {})
