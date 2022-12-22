local fn = vim.fn

local color_save_filename = "colo.txt"
local colorschemes = vim.fn.getcompletion("", "color")
local color_idx = -1
local delay = 5

local function find_color_idx()
    -- wait for vim.g.colors_name to populate
    local curr = vim.g.colors_name
    if curr == nil then
        vim.defer_fn(find_color_idx, delay)
    else
        for i, v in pairs(colorschemes) do
            if v == curr then
                color_idx = i
                break
            end
        end
    end
end

find_color_idx()

local function change_colors()
    local c = colorschemes[color_idx]
    vim.cmd.colorscheme(c)
    print(c, color_idx)
end

local function cycle_colors_next()
    color_idx = color_idx + 1
    if color_idx > #colorschemes then
        color_idx = 1
    end
    change_colors()
end

local function cycle_colors_prev()
    color_idx = color_idx - 1
    if color_idx < 1 then
        color_idx = #colorschemes
    end
    change_colors()
end

local function save_color()
    local full_path = vim.fn.stdpath "config" .. "/" .. color_save_filename
    local colors_name = vim.g.colors_name
    local already_saved =
        vim.trim(fn.system(string.format("grep %s %s", colors_name, full_path)))

    if already_saved ~= colors_name then
        fn.system(string.format("echo %s >> %s", colors_name, full_path))
    else
        print(colors_name, "is already saved")
    end
end

return {
    save_color = save_color,
    cycle_colors_next = cycle_colors_next,
    cycle_colors_prev = cycle_colors_prev,
}
