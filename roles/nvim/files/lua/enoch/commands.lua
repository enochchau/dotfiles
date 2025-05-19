local command = vim.api.nvim_create_user_command
local fn = vim.fn
local open = require("enoch.open")
local colorscheme = require("enoch.colorscheme")
local myserver = require("enoch.server")

command("BufClear", "%bd|e#|bd#", {})

-- command("Format", function()
--     return (require "enoch.format").format(vim.bo.filetype)
-- end, {})

command("SwapNu", function()
    vim.opt.relativenumber = not vim.opt.relativenumber._value
    return nil
end, {})

command("Cdg", function()
    return vim.api.nvim_set_current_dir(
        vim.trim(fn.system("git rev-parse --show-toplevel"))
    )
end, {})

command("Cdp", function()
    local packageJSON =
        vim.fs.find("package.json", { stop = vim.env.HOME, upward = true })
    if #packageJSON == 1 then
        return vim.api.nvim_set_current_dir(vim.fs.dirname(packageJSON[1]))
    end
    print("package.json not found")
end, {})

command("PluginOpen", open.plugin_link, {})
command("SaveColor", colorscheme.save_color, {})

command("Redir", function(ctx)
    local result = vim.api.nvim_exec2(ctx.args, { output = true })
    local lines = vim.split(result.output, "\n", { plain = true })

    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
end, { nargs = "+", complete = "command" })

command("StartServer", function()
    myserver.start()
end, {})

command("StopServer", function()
    myserver.stop()
end, {})

command("TestReplaceAll", function()
    local replace_all = require("enoch.pretty-ts-errors.utils").replace_all
    -- equivalent function using JavaScript
    -- "hello world".replaceAll(/(lo)\s(wo)/g, (_, p1, p2) => p1+p2)
    local res = replace_all("hello world hello world 1lo1wo1", [[\(lo\).\(wo\)]], function(matches)
        local p1 = matches[2]
        local p2 = matches[3]
        return p1 .. p2
    end)
    vim.print(res)
end, {})
