return {
    -- override lspconfig's before_init which calls find_tailwind_global_css()
    -- that synchronously scans every CSS file from the git root (~1.6s in monorepos)
    before_init = function(_, config)
        config.settings = config.settings or {}
        config.settings.editor = config.settings.editor or {}
        config.settings.editor.tabSize = config.settings.editor.tabSize
            or vim.lsp.util.get_effective_tabstop()
    end,
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)

        -- v3: tailwind/postcss config files
        local config_root = vim.fs.root(fname, {
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "postcss.config.js",
            "postcss.config.cjs",
            "postcss.config.mjs",
            "postcss.config.ts",
        })
        if config_root then
            on_dir(config_root)
            return
        end

        -- v4: tailwindcss listed as a dependency in package.json
        local pkg = vim.fs.find("package.json", { path = fname, upward = true })[1]
        if pkg then
            local ok, content = pcall(vim.fn.readblob, pkg)
            if ok and content:find('"tailwindcss"', 1, true) then
                on_dir(vim.fs.dirname(pkg))
            end
        end
    end,
}
