local fzf = require("fzf-lua")

---Get pnpm workspaces json
---@return table | nil
local function get_workspaces()
    local cmd = "pnpm ls -r --depth -1 --json"
    local output = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
        print("Error running pnpm: " .. output)
        return
    end

    local ok, data = pcall(vim.json.decode, output)
    if not ok or type(data) ~= "table" then
        print("Failed to parse pnpm JSON output")
        return
    end
    return data
end
local function pnpm_workspace_picker()
    local data = get_workspaces()
    if not data then
        return
    end

    local display_list = {}
    local path_map = {}

    for _, pkg in ipairs(data) do
        -- Some entries (like the root) might not have a name
        local display_item = (pkg.name or "root") .. "\t" .. pkg.path

        table.insert(display_list, display_item)
        path_map[display_item] = pkg.path
    end

    -- 5. Launch fzf-lua
    fzf.fzf_exec(display_list, {
        prompt = "PNPM Packages> ",
        winopts = { title = " Workspaces ", height = 0.33, width = 0.80 },
        fzf_opts = {
            ["--delimiter"] = "\t",
            ["--nth"] = "1", -- Only search the Name
        },
        actions = {
            ["default"] = function(selected)
                local selected_path = path_map[selected[1]]
                if not selected_path then
                    print("Failed to find selected path")
                    return
                end
                vim.api.nvim_set_current_dir(selected_path)
            end,
        },
    })
end

return {
    pnpm_workspace_picker = pnpm_workspace_picker,
}
