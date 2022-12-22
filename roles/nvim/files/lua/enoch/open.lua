local M = {}

--- Open a URL in the browser
---@param url string
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

--- Check if a string is a url (kind dumb but it works)
---@param url string
---@return boolean
local function is_url(url)
    return url:match "^https://"
end

--- Check if a string is in github repo format of username/repo_name
---@param str string
---@return boolean
local function is_github(str)
    return str:match "^([a-zA-Z0-9-_.]+)/([a-zA-Z0-9-_.]+)$"
end

--- Open the plugin under the cursor's homepage
function M.open_plugin_link()
    local ts_utils = require "nvim-treesitter.ts_utils"

    local text = string.gsub(
        vim.treesitter.query.get_node_text(ts_utils.get_node_at_cursor(), 0),
        "^[\"'](.*)[\"']$",
        "%1"
    )

    if is_url(text) then
        return open_url(text)
    elseif is_github(text) then
        return open_url(("https://github.com/" .. text))
    else
        return nil
    end
end

return M
