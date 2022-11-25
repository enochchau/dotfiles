local fmt = require "enoch.format"
local opt = vim.opt
local command = vim.api.nvim_create_user_command

-- Clear all but the current buffer
command("BufClear", "%bd|e#|bd#", {})

-- Format cmd
command("Format", function()
    if vim.opt_local.filetype == "astro" then
        fmt.format "astro"
    else
        fmt.format()
    end
end, {})

-- swap nu to rnu and visa versa
command("SwapNu", function()
    opt.relativenumber = not opt.relativenumber._value
end, {})
