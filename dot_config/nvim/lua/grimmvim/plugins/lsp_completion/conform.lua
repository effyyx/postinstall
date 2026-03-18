return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd   = { "ConformInfo" },
  keys  = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format file/selection",
    },
  },
  opts = {
    formatters_by_ft = {
      lua              = { "stylua" },
      python           = { "isort", "black" },
      javascript       = { "prettier" },
      typescript       = { "prettier" },
      javascriptreact  = { "prettier" },
      typescriptreact  = { "prettier" },
      css              = { "prettier" },
      html             = { "prettier" },
      json             = { "prettier" },
      jsonc            = { "prettier" },
      yaml             = { "prettier" },
      markdown         = { "prettier" },
      toml             = { "taplo" },
      c                = { "clang_format" },
      cpp              = { "clang_format" },
      rust             = { "rustfmt" },
      sh               = { "shfmt" },
      bash             = { "shfmt" },
      ["_"]            = { "trim_whitespace" },
    },
    format_on_save = {
      timeout_ms   = 500,
      lsp_fallback = true,
    },
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      prettier = {
        prepend_args = { "--tab-width", "2", "--single-quote" },
      },
      black = {
        prepend_args = { "--line-length", "100" },
      },
      clang_format = {
        prepend_args = { "--style=LLVM" },
      },
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
    },
  },
}
