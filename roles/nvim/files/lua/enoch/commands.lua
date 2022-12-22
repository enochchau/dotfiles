local command = vim.api.nvim_create_user_command
local fn = vim.fn

command("BufClear", "%bd|e#|bd#", {})

command("Format", function()
    return (require "enoch.format").format(vim.bo.filetype)
end, {})

command("SwapNu", function()
    vim.opt.relativenumber = not vim.opt.relativenumber._value
    return nil
end, {})

command("Cdg", function()
    return vim.api.nvim_set_current_dir(
        vim.trim(fn.system "git rev-parse --show-toplevel")
    )
end, {})

command("PluginOpen", require("enoch.open").open_plugin_link, {})

local color_save_filename = "colo.txt"
command("SaveColor", function()
    local full_path = vim.fn.stdpath "config" .. "/" .. color_save_filename
    local colors_name = vim.g.colors_name
    local already_saved =
        vim.trim(fn.system(string.format("grep %s %s", colors_name, full_path)))

    if already_saved ~= colors_name then
        fn.system(string.format("echo %s >> %s", colors_name, full_path))
    else
        print(colors_name, "is already saved")
    end
end, {})
