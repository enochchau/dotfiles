local mpack = vim.mpack
local uv = vim.uv
local json = vim.json
local fs = vim.fs

local M = {}

---@class ExecOpts
---@field public lines boolean set this to true to output lines as a table
--
--- Execute a command
---@param cmd string
---@param _opt? ExecOpts
---@return table|string
local function exec(cmd, _opt)
    local f = assert(io.popen(cmd))
    local opt = _opt or {}
    if opt.lines then
        local lines = {}
        for line in f:lines() do
            table.insert(lines, line)
        end
        return lines
    end

    return f:read("*a")
end

--- List workspaces as path, name pairs
---@param root string
---@param package_manager string
---@return string table encoded as mpack
local function list_workspaces(root, package_manager)
    local workspaces
    if package_manager == "pnpm" then
        local raw = exec("pnpm ls -json -r")
        local j = json.decode(raw)

        workspaces = {}
        for _, v in ipairs(j) do
            workspaces[v.name] = v.path
        end
    elseif package_manager == "yarn" then
        local v2 = uv.fs_lstat(root .. "/.yarnrc.yml")

        if v2 ~= nil then
            ---@type table
            local lines = exec("yarn workspaces list --json", { lines = true })

            workspaces = {}
            for _, line in ipairs(lines) do
                local j = json.decode(line)
                if type(j) == "table" then
                    workspaces[j.name] = j.location
                end
            end
        else
            local lines = exec("yarn workspaces info", { lines = true })
            -- output comes in the form of JSON but we need to ignore the first and last lines
            local j = ""
            for i = 2, #lines - 1, 1 do
                j = j .. lines[i]
            end
            local parsed = json.decode(j)

            workspaces = { root = "." }

            for k, v in pairs(parsed) do
                workspaces[k] = v.location
            end
        end
    elseif package_manager == "npm" then
        local raw = exec(
            string.format("cd %s && npm list -json -depth 1 -omit=dev", root)
        )

        local j = json.decode(raw)

        workspaces = { root = "." }

        for k, v in pairs(j.dependencies) do
            if v.resolved ~= nil then
                workspaces[k] = string.sub(v.resolved, 7)
            end
        end
    end

    return mpack.encode(workspaces)
end

--- Find workspace root and package manager
---@param path string starting path
---@return string, string
local function find_root(path)
    local package_jsons = fs.find(
        "package.json",
        { upward = true, limit = math.huge, path = path, type = "file" }
    )
    for i = #package_jsons, 1, -1 do
        local curr = package_jsons[i]
        local dir = fs.dirname(curr)

        local ok = uv.fs_lstat(dir .. "/pnpm-lock.yaml")
        if ok ~= nil then
            return dir, "pnpm"
        end

        ok = uv.fs_lstat(dir .. "/yarn.lock")
        if ok ~= nil then
            return dir, "yarn"
        end

        ok = uv.fs_lstat(dir .. "/package-lock.json")
        if ok ~= nil then
            return dir, "npm"
        end
    end

    return "Node workspace not found", ""
end

function M.node_workspaces()
    local root, package_manager = find_root(uv.cwd())
    if package_manager == "" then
        print(root)
    else
        local ctx = uv.new_work(list_workspaces, function(encoded_workspaces)
            local fzf_lua = require("fzf-lua")
            local workspaces = vim.mpack.decode(encoded_workspaces)

            vim.schedule(function()
                fzf_lua.fzf_exec(vim.tbl_keys(workspaces), {
                    actions = {
                        default = function(selected)
                            local new_cwd = workspaces[selected[1]]
                            if package_manager ~= "pnpm" then
                                new_cwd = fs.normalize(root .. "/" .. new_cwd)
                            end
                            vim.api.nvim_set_current_dir(new_cwd)
                        end,
                    },
                })
            end)
        end)

        ctx:queue(root, package_manager)
    end
end

return M
