local fennel = require "bulb.fennel"
local command = vim.api.nvim_create_user_command

local function open_stream(filename)
    local f = assert(io.open(filename, "rb"))

    return function()
        local c = f:read(1)
        if c ~= nil then
            return c:byte()
        end

        f:close()
        return nil
    end
end

local function fnl_compile(stream)
    return fennel.compileStream(
        stream,
        { ["compiler-env"] = _G, correlate = false }
    )
end

local function print_stdout(message)
    message = vim.fn.split(message, "\n")
    vim.fn.writefile(message, "/dev/stdout")
end

command("FnlCompile", function(t)
    if debug.traceback ~= fennel.traceback then
        debug.traceback = fennel.traceback
    end

    local in_path, out_path = unpack(vim.fn.split(t.args, " "))
    assert(in_path, "missing input path")

    local stream = open_stream(in_path)
    local out = fnl_compile(stream)

    if out_path ~= nil then
        local file = assert(io.open(out_path, "w"))
        file:write(out)
        file:close()
    else
        print_stdout(out)
    end
end, { nargs = 1 })

command("FnlRun", function(t)
    local in_path = unpack(vim.fn.split(t.args, " "))
    assert(in_path, "missing input path")

    local out = fennel.dofile(in_path)
    print("\n")
    print_stdout(vim.inspect(out))
end, { nargs = 1 })
