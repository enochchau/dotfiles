local fennel = require "bulb.fennel"

local function open_stream(filename)
    local f = assert(io.open(filename, "rb"))

    return function()
        local c = f:read(1)
        if c ~= nil then
            return c:byte()
        end

        return nil
    end
end

vim.api.nvim_create_user_command("FnlCompile", function(t)
    local in_path, out_path = unpack(vim.fn.split(t.args, " "))
    assert(in_path, "missing input path")
    assert(out_path, "missing output path")

    local stream = open_stream(in_path)
    local out = fennel.compileStream(stream)

    local file = assert(io.open(out_path, "r"))
    file:write(out)
end, { nargs = 1 })
