local M = {}

local function map(modes)
    return function(lhs, rhs, buffer)
        vim.keymap.set(
            modes,
            lhs,
            rhs,
            { noremap = true, silent = true, buffer = buffer }
        )
    end
end

M.nmap = map "n"
M.vmap = map "v"
M.xmap = map "x"
M.tmap = map "t"
M.map = function(modes, lhs, rhs, buffer)
    map(modes)(lhs, rhs, buffer)
end

return M
