local command = vim.api.nvim_create_user_command

command("BufClear", "%bd|e#|bd#", {})
command("Format", function()
    return (require "enoch.format").format(vim.bo.filetype._value)
end, {})
command("SwapNu", function()
    vim.opt.relativenumber = not vim.opt.relativenumber._value
    return nil
end, {})
command("Cdg", function()
    return vim.api.nvim_set_current_dir(
        vim.trim(vim.fn.system "git rev-parse --show-toplevel")
    )
end, {})
local function open_plugin_link()
    local ts_utils = require "nvim-treesitter.ts_utils"

    local function open_url(url)
        if vim.fn.has "mac" == 1 then
            return vim.fn.system(("open" .. " " .. url))
        elseif vim.fn.has "wsl" == 1 then
            return vim.fn.system(("explorer.exe" .. " " .. url))
        elseif vim.fn.has "win32" == 1 then
            return vim.fn.system(("start" .. " " .. url))
        elseif vim.fn.has "linux" == 1 then
            return vim.fn.system(("xdg-open" .. " " .. url))
        else
            return nil
        end
    end

    local function get_text_at_cursor()
        return string.gsub(
            vim.treesitter.query.get_node_text(ts_utils.get_node_at_cursor(), 0),
            "^[\"'](.*)[\"']$",
            "%1"
        )
    end

    local function is_url(url)
        return url:match "^https://"
    end

    local function is_github(str)
        return str:match "^([a-zA-Z0-9-_.]+)/([a-zA-Z0-9-_.]+)$"
    end

    local text = get_text_at_cursor()

    if is_url(text) then
        return open_url(text)
    elseif is_github(text) then
        return open_url(("https://github.com/" .. text))
    else
        return nil
    end
end
return command("PackerOpen", open_plugin_link, {})
