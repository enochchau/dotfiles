local uv = vim.loop
local command = vim.api.nvim_create_user_command

_G.__bulb_internal = {
    rtp_updated = false,
}

local plugin_meta = {
    name = "bulb",
    version = "0.0.0",
}

local boostrap_compiler_options = {
    compilerEnv = _G,
}

local function read_stream(filepath)
    local f = assert(io.open(filepath, "rb"))

    return function()
        local c = f:read(1)
        if c ~= nil then
            return c:byte()
        end

        f:close()
        return nil
    end
end

--- Update `fennel.path` and `fennel.macro-path` with runtimepaths
local function update_fnl_rtp()
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
    -- we activate the bootstrap with an ENV var
    if vim.env.FENNEL_COMPILE then
        local fennel = require "bulb.fennel"
        -- this file should be at ./lua/bulb/bootstrap.lua
        local targetpath = debug.getinfo(1, "S").source:match "@?(.*)"
        -- lets go up to ./
        for _ = 1, 3 do
            targetpath = vim.fs.dirname(targetpath)
        end

        -- and compile all the fnl files
        local files = vim.fs.find(function(filename)
            return string.match(filename, "%.fnl$") ~= nil
        end, { path = targetpath, type = "file", limit = math.huge })

        -- only compile bulb
        files = vim.tbl_filter(function(filename)
            return string.match(filename, "/bulb/") ~= nil
        end, files)

        local _debug_traceback = debug.traceback

        update_fnl_rtp()

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
end

local function setup(user_config)
    bootstrap()

    -- everything after bootstrap can come from a fennel file
    require("bulb.setup").setup(user_config)
end

return {
    bootstrap = bootstrap,
    update_fnl_rtp = update_fnl_rtp,
    ["update-fnl-rtp"] = update_fnl_rtp,
    setup = setup,
}
