local lspconfig = require "lspconfig"
local M = {}

--- Find the fennel root directory
---@param dir string
local function fennel_root_dir(dir)
    -- if we're in the neovim path, go to ~/dotfiles/roles/nvim/files/
    if dir:match "/nvim/" ~= nil then
        local curr_dir = dir
        local base = vim.fs.basename(curr_dir)
        while base ~= "files" and base ~= "." and base ~= "/" do
            curr_dir = vim.fs.dirname(curr_dir)
            base = vim.fs.basename(curr_dir)
        end
        return curr_dir
    end

    -- else use nearest git root
    return lspconfig.util.find_git_ancestor(dir)
end

--- https://git.sr.ht/~xerool/fennel-ls
M["fennel-ls"] = function()
    require("lspconfig.configs")["fennel-ls"] = {
        default_config = {
            cmd = { vim.fn.expand "~/code/fennel-ls/fennel-ls" },
            filetypes = { "fennel" },
            root_dir = fennel_root_dir,
            settings = {},
        },
    }
end

--- https://github.com/rydesun/fennel-language-server
M["fennel-language-server"] = function()
    require("lspconfig.configs")["fennel-language-server"] = {
        default_config = {
            -- replace it with true path
            cmd = { vim.fn.expand "~/.cargo/bin/fennel-language-server" },
            filetypes = { "fennel" },
            single_file_support = true,
            -- source code resides in directory `fnl/`
            root_dir = fennel_root_dir,
            settings = {
                fennel = {
                    workspace = {
                        -- If you are using hotpot.nvim or aniseed,
                        -- make the server aware of neovim runtime files.
                        library = vim.api.nvim_list_runtime_paths(),
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        },
    }
end

return M
