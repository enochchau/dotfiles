local command = vim.api.nvim_create_user_command
local fn = vim.fn
local open = require("enoch.open")
local colorscheme = require("enoch.colorscheme")
local myserver = require("enoch.server")

command("BufClear", "%bd|e#|bd#", {})

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

-- Add to init.lua
command("GitCheck", function()
    -- Set the errorformat to match: "filename:line: message"
    vim.opt.errorformat = "%f:%l: %m"

    -- Run git diff --check and read it into the quickfix list
    local output = vim.fn.systemlist("git diff --check")
    vim.fn.setqflist({}, "r", { title = "Git Check", lines = output })

    -- Open the quickfix window if there are errors
    if not vim.tbl_isempty(output) then
        vim.cmd("copen")
    else
        print("No whitespace errors found!")
    end
end, {})

command("PnpmWorkspace", require("enoch.pnpm-workspace-picker").pnpm_workspace_picker, {})
