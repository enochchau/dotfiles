local filereadable = vim.fn.filereadable
local if_nil = vim.F.if_nil

-- pretty much the same as old files but uses cwd filter on old files

local M = {}

---@param cwd string? optional
---@param items_number number? optional number of items to generate, default = 10
local function oldfiles_filter(cwd, items_number)
    items_number = if_nil(items_number, 10)
    local oldfiles = {}
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
            break
        end
        local cwd_cond
        if not cwd then
            cwd_cond = true
        else
            cwd_cond = vim.startswith(v, cwd)
        end
        if (filereadable(v) == 1) and cwd_cond then
            oldfiles[#oldfiles + 1] = v
        end
    end
    return oldfiles
end

function M.mru(opts)
    local make_entry = require "fzf-lua.make_entry"
    local config = require "fzf-lua.config"
    local core = require "fzf-lua.core"
    local utils = require "fzf-lua.utils"

    opts = config.normalize_opts(opts, config.globals.oldfiles)
    if not opts then
        return
    end

    local current_buffer = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_buffer)
    local sess_tbl = {}
    local sess_map = {}

    if opts.include_current_session then
        for _, buffer in ipairs(vim.split(vim.fn.execute ":buffers! t", "\n")) do
            local bufnr = tonumber(buffer:match "%s*(%d+)")
            if bufnr then
                local file = vim.api.nvim_buf_get_name(bufnr)
                local fs_stat = not opts.stat_file and true
                    or vim.uv.fs_stat(file)
                if #file > 0 and fs_stat and bufnr ~= current_buffer then
                    sess_map[file] = true
                    table.insert(sess_tbl, file)
                end
            end
        end
    end

    local contents = function(cb)
        local function add_entry(x, co)
            x = make_entry.file(x, opts)
            if not x then
                return
            end
            cb(x, function(err)
                coroutine.resume(co)
                if err then
                    -- close the pipe to fzf, this
                    -- removes the loading indicator in fzf
                    cb(nil)
                end
            end)
            coroutine.yield()
        end

        -- run in a coroutine for async progress indication
        coroutine.wrap(function()
            local co = coroutine.running()

            for _, file in ipairs(sess_tbl) do
                add_entry(file, co)
            end

            local filtered_oldfiles = oldfiles_filter(vim.fn.getcwd(), 100)

            for _, file in ipairs(filtered_oldfiles) do
                local fs_stat = not opts.stat_file and true
                    -- FIFO blocks `fs_open` indefinitely (#908)
                    or (
                        not utils.file_is_fifo(file)
                        and utils.file_is_readable(file)
                    )
                if fs_stat and file ~= current_file and not sess_map[file] then
                    add_entry(file, co)
                end
            end

            cb(nil)
        end)()
    end

    -- for 'file_ignore_patterns' to work on relative paths
    opts.cwd = opts.cwd or vim.uv.cwd()
    opts = core.set_header(opts, opts.headers or { "cwd" })
    return core.fzf_exec(contents, opts)
end

return M
