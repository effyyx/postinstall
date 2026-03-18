return {
  "williamboman/mason.nvim",
  cmd  = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts = {
    ensure_installed = {
      -- LSP servers
      "lua-language-server",
      "typescript-language-server",
      "css-lsp",
      "html-lsp",
      "json-lsp",
      "yaml-language-server",
      "pyright",
      "rust-analyzer",
      "clangd",
      "taplo",          -- TOML
      "qmlls",          -- QML (requires Qt6)
      -- Formatters
      "stylua",
      "prettier",
      "black",
      "isort",
      "clang-format",
      -- Linters
      "eslint_d",
      "pylint",
      "selene",
    },
    ui = {
      border  = "rounded",
      icons = {
        package_installed   = "✓",
        package_pending     = "➜",
        package_uninstalled = "✗",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- Auto-install ensure_installed
    local mr = require("mason-registry")
    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
