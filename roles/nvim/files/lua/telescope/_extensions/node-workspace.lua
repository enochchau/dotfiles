local json = require "JSON"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function table_keys(t)
    local keys = {}

    for k, _v in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

local function split_string(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function list_workspaces(package_manager)
    if package_manager == "yarn-berry" then
        local raw = vim.fn.system { "yarn", "workspaces", "list", "--json" }
        local lines = split_string(raw, "\n")
        local j = "["
        for i, v in ipairs(lines) do
            j = j .. v
            if i ~= #lines then
                j = j .. ","
            end
        end
        j = j .. "]"
        local parsed = json.decode(j)

        local workspaces = {}
        for _i, v in ipairs(parsed) do
            workspaces[v.name] = v.location
        end
        return workspaces
    end
    -- TODO:
    -- elseif package_manager == "yarn" then
    --     local ws_json = vim.fn.system { "yarn", "workspaces", "info" }
    --     print(ws_json)
    -- end
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function detect_package_manager(root_path)
    local res = "npm"
    if file_exists(root_path .. "/yarn.lock") then
        res = "yarn"
    elseif file_exists(root_path .. "pnpm-lock.yaml") then
        res = "pnpm"
    end

    return res
end

local function find_workspace_package_json(cwd)
    local package_jsons = vim.fs.find(
        "package.json",
        { upward = true, limit = math.huge, path = cwd }
    )

    local workspace_root = package_jsons[#package_jsons]

    return workspace_root
end

local function read_json(path)
    local f = io.open(path, "r")
    local j = f:read "*all"
    f:close()

    return json.decode(j)
end

local function workspace(opts)
    opts = opts or {}

    local package_json = find_workspace_package_json()
    local j = read_json(package_json)

    if j.workspaces == nil then
        print "package.json is missing the workspace field!"
        return
    end

    local workspace_root = vim.fs.dirname(package_json)
    local package_manager = detect_package_manager(workspace_root)

    if package_manager == "yarn" then
        -- check packagejson for packageManager to see if yarn berry
        if j.packageManager ~= nil and j.packageManager[6] ~= "1" then
            package_manager = "yarn-berry"
        end
    end

    local workspaces = list_workspaces(package_manager)
    local workspace_keys = table_keys(workspaces)

    pickers
        .new(opts, {
            prompt_title = "Node Workspaces - " .. package_manager,
            finder = finders.new_table {
                results = workspace_keys,
            },
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    local key = selection[1]
                    local dir = workspaces[key]

                    local path = vim.fs.normalize(workspace_root .. "/" .. dir)
                    vim.api.nvim_set_current_dir(path)
                end)
                return true
            end,
        })
        :find()
end

return require("telescope").register_extension {
    exports = {
        ["node-workspace"] = workspace,
    },
}
