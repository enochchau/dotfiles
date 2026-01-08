--- Check if a string is a url (kind dumb but it works)
---@param url string
---@return boolean
local function is_url(url)
    return url:match("^https://")
end

--- Check if a string is in github repo format of username/repo_name
---@param str string
---@return boolean
local function is_github(str)
    return str:match("^([a-zA-Z0-9-_.]+)/([a-zA-Z0-9-_.]+)$")
end

--- Use treesitter to get the text of the string under the cursor
--- Only works forlanguages that use " or ' as strings
local function ts_string_under_cursor()
    local node = vim.treesitter.get_node()
    if not node then
        return ""
    end

    return string.gsub(vim.treesitter.get_node_text(node, 0), "^[\"'](.*)[\"']$", "%1")
end

--- Open the (plugin under the cursor)'s homepage
local function plugin_link()
    local text = ts_string_under_cursor()

    if is_url(text) then
        return vim.ui.open(text)
    elseif is_github(text) then
        return vim.ui.open(("https://github.com/" .. text))
    else
        return nil
    end
end

return { plugin_link = plugin_link }
