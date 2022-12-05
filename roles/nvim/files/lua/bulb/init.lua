_G.__bulb_internal = {
    rtp_updated = false,
    version = "0.0.0",
    plugin_name = "bulb",
}

--- Update `fennel.path` and `fennel.macro-path` with runtimepaths
--- We call this function during bootstrap and setup
local function update_fnl_rtp()
    -- stop rtp from being updated multiple times
    if _G.__bulb_internal.rtp_updated then
        return
    end

    local fennel = require "bulb.fennel"
    local rtps = vim.api.nvim_list_runtime_paths()
    local lua_templates = {
        ";%s/lua/?.fnl",
        ";%s/lua/?/init.fnl",
    }
    local fnl_templates = {
        ";%s/fnl/?.fnl",
        ";%s/fnl/?/init.fnl",
    }
    for _, rtp in ipairs(rtps) do
        for _, template in ipairs(lua_templates) do
            fennel["macro-path"] = fennel["macro-path"]
                .. string.format(template, rtp)
            fennel.path = fennel.path .. string.format(template, rtp)
        end
        for _, template in ipairs(fnl_templates) do
            fennel["macro-path"] = fennel["macro-path"]
                .. string.format(template, rtp)
            fennel.path = fennel.path .. string.format(template, rtp)
        end
    end

    _G.__bulb_internal.rtp_updated = true
end

--- Get the `.` separated module name from the fnl file name
---@param fnl_file string
---@return string
local function get_module_name(fnl_file)
    -- check both the fnl/ and lua/ directories
    local module_partial = string.match(fnl_file, "fnl/(.+)%.fnl$")
    if module_partial == nil then
        module_partial = string.match(fnl_file, "lua/(.+)%.fnl$")
    end

    assert(module_partial, "Coudn't get module name for: " .. fnl_file)
    local module_name = string.gsub(module_partial, "/", ".")
    return module_name
end

-- We compile and preload all of bulb's fennel files here to bootstrap it
-- Then we get access to compilation tools to create the cache
local function bootstrap()
    local fennel = require "bulb.fennel"
    -- this file should be at ./lua/bulb/bootstrap.lua
    local targetpath = debug.getinfo(1, "S").source:match "@?(.*)"
    -- lets go up to ./
    for _ = 1, 3 do
        targetpath = vim.fs.dirname(targetpath)
    end

    -- only compile bulb, we don't get full path names in `vim.fs.find`
    -- so we have to filter again
    local files = vim.fs.find(function(filename)
        return string.match(filename, "%.fnl$") ~= nil
    end, { path = targetpath, type = "file", limit = math.huge })
    files = vim.tbl_filter(function(filename)
        return string.match(
            filename,
            string.format("/%s/", _G.__bulb_internal.plugin_name)
        ) ~= nil
    end, files)

    local _debug_traceback = debug.traceback

    -- set debugger
    if debug.traceback ~= fennel.traceback then
        debug.traceback = fennel.traceback
    end

    for _, fnl_file in ipairs(files) do
        local f = assert(io.open(fnl_file, "r"))
        local input_fnl = f:read "*a"
        f:close()

        local result = fennel.compileString(
            input_fnl,
            { filename = fnl_file, compilerEnv = _G }
        )

        local module_name = get_module_name(fnl_file)

        -- preload files here
        package.preload[module_name] = package.preload[module_name]
            or function()
                return assert(
                    loadstring(result, module_name)(),
                    "Failed to load module: " .. module_name
                )
            end
    end

    -- reset debugger
    if debug.traceback == fennel.traceback then
        debug.traceback = _debug_traceback
    end
end

local function setup(user_config)
    if user_config.bootstrap then
        bootstrap()
    end

    update_fnl_rtp()

    -- everything after bootstrap can come from a fennel file
    require("bulb.setup").setup(user_config)
end

return {
    setup = setup,
}
