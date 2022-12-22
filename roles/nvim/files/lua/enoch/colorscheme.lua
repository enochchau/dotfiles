local M = {}

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

function M.cycle_colors_next()
    color_idx = color_idx + 1
    if color_idx > #colorschemes then
        color_idx = 1
    end
    change_colors()
end

function M.cycle_colors_prev()
    color_idx = color_idx - 1
    if color_idx < 1 then
        color_idx = #colorschemes
    end
    change_colors()
end

return M
