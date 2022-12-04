local M = {
    rtp_updated = false,
}

local command = vim.api.nvim_create_user_command

local cfg = {
    compiler_options = { compilerEnv = _G, correlate = false },
    debug = false,
}

--- Update `fennel.path` and `fennel.macro-path` with runtimepaths
local function update_fnl_rtp()
    if M.rtp_updated then
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

    M.rtp_updated = true
end

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

local function print_stdout(message)
    message = vim.fn.split(message, "\n")
    vim.fn.writefile(message, "/dev/stdout")
end

local function compile_file(filepath)
    local stream = read_stream(filepath)
    local out =
        require("bulb.fennel").compileStream(stream, cfg.compiler_options)
    return out
end

--- Configure bulb
---@param user_config table
function M.setup(user_config)
    user_config = user_config or {}
    cfg = vim.tbl_deep_extend("keep", user_config, cfg)

    local fennel = require "bulb.fennel"

    -- add fennel tracebacks if debug is enabled
    if cfg.debug and debug.traceback ~= fennel.traceback then
        debug.traceback = fennel.traceback
    end

    -- add vim rtp to fennel searchers
    update_fnl_rtp()

    local _fnl_macro_searcher = fennel.macroSearchers[1]

    -- tap into searcher
    fennel.macroSearchers[1] = function(module_name)
        -- cache macros here!
        local result, filename = _fnl_macro_searcher(module_name)
        print("Found macro: ", filename)
        vim.pretty_print(string.dump(result))
        print "-----------------------------"
        return result, filename
    end

    command("FnlCompile", function(t)
        local in_path, out_path = unpack(t.fargs)
        assert(in_path, "missing input path")

        local out = compile_file(in_path)

        if out_path ~= nil then
            local file = assert(io.open(out_path, "w"))
            file:write(out)
            file:close()
        else
            print_stdout(out)
        end
    end, { nargs = "+" })

    command("FnlRun", function(t)
        local in_path = t.args
        assert(in_path, "missing input path")

        local out = fennel.dofile(in_path, cfg.compiler_options)
        print "\n"
        print_stdout(fennel.view(out))
    end, { nargs = 1 })
end

return M
