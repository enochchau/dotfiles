M = {}
local api = vim.api
local netrw_open = false

local netrw_toggle = api.nvim_create_augroup("NetrwToggle", {})
api.nvim_create_autocmd({ "BufLeave" }, {
    group = netrw_toggle,
    callback = function()
        local ft = vim.opt.ft:get()
        if ft == "netrw" then
            netrw_open = false
        end
    end,
})

function M.toggle_netrw()
    if not netrw_open then
        vim.cmd('exe "normal mN"')
        vim.cmd("Explore")
        netrw_open = true
    else
        vim.cmd('exe "normal `N"')
        netrw_open = false
    end
end

return M
