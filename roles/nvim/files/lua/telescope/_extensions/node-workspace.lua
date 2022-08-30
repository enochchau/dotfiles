local json = require "JSON"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

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

local function list_workspaces(package_manager, workspace_root)
    local workspaces = {}
    local keys = {}

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

        for _i, v in ipairs(parsed) do
            workspaces[v.name] = v.location
            table.insert(keys, v.name)
        end
        return workspaces, keys
    elseif package_manager == "yarn" then
        local raw = vim.fn.system { "yarn", "workspaces", "info" }
        local lines = split_string(raw, "\n")
        local j = ""
        for i = 2, #lines - 1, 1 do
            j = j .. lines[i]
        end
        local parsed = json.decode(j)

        workspaces["root"] = "."
        table.insert(keys, "root")

        for k, v in pairs(parsed) do
            workspaces[k] = v.location
            table.insert(keys, k)
        end
    elseif package_manager == "pnpm" then
        local raw = vim.fn.system { "pnpm", "ls", "--json", "-r" }
        local parsed = json.decode(raw)

        for i, v in ipairs(parsed) do
            workspaces[v.name] = v.path
            table.insert(keys, v.name)
        end
    else -- npm
        local original_cwd = vim.fn.getcwd()

        vim.api.nvim_set_current_dir(workspace_root)
        local raw =
            vim.fn.system { "npm", "list", "-json", "-depth", "1", "-omit=dev" }
        vim.api.nvim_set_current_dir(original_cwd)

        local parsed = json.decode(raw)

        workspaces["root"] = "."
        table.insert(keys, "root")

        for k, v in pairs(parsed.dependencies) do
            if v.resolved ~= nil then
                workspaces[k] = string.sub(v.resolved, 7)
                table.insert(keys, k)
            end
        end
    end

    return workspaces, keys
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
    elseif file_exists(root_path .. "/pnpm-lock.yaml") then
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

    local workspace_root = vim.fs.dirname(package_json)
    local package_manager = detect_package_manager(workspace_root)

    if package_manager == "yarn" then
        -- check packagejson for packageManager to see if yarn berry
        if j.packageManager ~= nil and j.packageManager[6] ~= "1" then
            package_manager = "yarn-berry"
        end
    end

    local workspaces, workspace_keys =
        list_workspaces(package_manager, workspace_root)

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

                    -- don't need to normalize paths for pnpm
                    local path
                    if package_manager ~= "pnpm" then
                        path = vim.fs.normalize(workspace_root .. "/" .. dir)
                    else
                        path = dir
                    end
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
