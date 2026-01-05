------@brief
---
--- https://github.com/fengkx/beancount-lsp/tree/master/packages/lsp-server
---
--- See https://github.com/fengkx/beancount-lsp/tree/master/packages/lsp-server for configuration options

---@type vim.lsp.Config
return {
    cmd = { 'beancount-lsp-server', '--stdio' },
    filetypes = { 'beancount', 'bean' },
    root_markers = { '.git' },
    settings = {
        beanLsp = {
            mainBeanFile = "ledger/ledger.beancount",
            python3Path = "python3",
            maxNumberOfProblems = 100,
            hover = {
                includeSubaccountBalance = false,
            },
            formatter = {
                enabled = true,
                alignCurrency = false,
            },
        }
    }
}
