local fennel = require "bulb.fennel"
local command = vim.api.nvim_create_user_command
if debug.traceback ~= fennel.traceback then
    debug.traceback = fennel.traceback
end

local compiler_options = { ["compiler-env"] = _G, correlate = false }

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

local function print_stdout(message)
    message = vim.fn.split(message, "\n")
    vim.fn.writefile(message, "/dev/stdout")
end

command("FnlCompile", function(t)
    local in_path, out_path = unpack(vim.fn.split(t.args, " "))
    assert(in_path, "missing input path")

    local stream = open_stream(in_path)
    local out = fennel.compileStream(stream, compiler_options)

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

    local out = fennel.dofile(in_path, compiler_options)
    print "\n"
    print_stdout(vim.inspect(out))
end, { nargs = 1 })
