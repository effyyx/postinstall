vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = "󰠠 ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  underline         = true,
  update_in_insert  = false,
  severity_sort     = true,
  float = {
    focusable  = true,
    style      = "minimal",
    border     = "rounded",
    source     = "always",
    header     = "",
    prefix     = "",
  },
})

-- ============================================================
-- LSP Handlers (rounded borders everywhere)
-- ============================================================
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded", max_width = 80 }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded", max_width = 80 }
)
