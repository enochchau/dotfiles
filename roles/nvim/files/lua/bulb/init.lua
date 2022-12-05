_G.__bulb_internal = {
    rtp_updated = false,
    macro_searcher_updated = false,
    version = "0.0.0",
    plugin_name = "bulb",
}

-- We compile and preload all of bulb's fennel files here to bootstrap it
-- Then we get access to compilation tools to create the cache
local function bootstrap()
    local lutil = require "bulb.lutil"
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

    lutil["update-fnl-macro-rtp"]()

    for _, fnl_file in ipairs(files) do
        local f = assert(io.open(fnl_file, "r"))
        local input_fnl = f:read "*a"
        f:close()

        local result = fennel.compileString(
            input_fnl,
            { filename = fnl_file, compilerEnv = _G }
        )

        local module_name = lutil["get-module-name"](fnl_file)

        -- preload files here
        package.preload[module_name] = package.preload[module_name]
            or function()
                local f = assert(
                    loadstring(result, module_name),
                    "bulb: Failed to load module " .. module_name
                )
                return f()
            end
    end

    -- reset debugger
    if debug.traceback == fennel.traceback then
        debug.traceback = _debug_traceback
    end
end

--- we have to wrap this function b/c we don't know if bulb.setup will be
--- compiled yet
local function setup(user_config)
    local function load_cache()
        local cache_path = require("bulb.config").cfg["cache-path"]
        local f = assert(loadfile(cache_path), "bulb: Failed to load cache")
        return f()
    end

    if user_config.bootstrap then
        bootstrap()
        require("bulb.setup").setup(user_config)
        vim.cmd "BulbPreload"
        load_cache()
    elseif user_config.loadonly then
        load_cache()
    else
        load_cache()
        require("bulb.setup").setup(user_config)
    end
end

return {
    setup = setup,
}
