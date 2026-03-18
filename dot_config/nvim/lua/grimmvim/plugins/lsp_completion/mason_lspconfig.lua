return {
  "williamboman/mason-lspconfig.nvim",
  event        = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },
  config = function()
    local lspconfig    = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Round borders everywhere
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly     = true,
    }

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", "ts_ls", "cssls", "html", "jsonls",
        "yamlls", "pyright", "rust_analyzer", "clangd", "taplo",
      },
      automatic_installation = { exclude = { "qmlls" } },
      handlers = {
        -- Default handler
        function(server_name)
          lspconfig[server_name].setup({ capabilities = capabilities })
        end,

        -- QML - disabled (causes noise with Quickshell custom types)
        qmlls = function() end,

        -- Lua
        lua_ls = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime     = { version = "LuaJIT" },
                workspace   = {
                  checkThirdParty = false,
                  library = { vim.env.VIMRUNTIME },
                },
                completion  = { callSnippet = "Replace" },
                diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
                doc         = { privateName = { "^_" } },
                hint = {
                  enable     = true,
                  setType    = false,
                  paramType  = true,
                  paramName  = "Disable",
                  semicolon  = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          })
        end,

        -- TypeScript / JavaScript
        ts_ls = function()
          lspconfig.ts_ls.setup({
            capabilities = capabilities,
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints          = "literal",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints  = true,
                  includeInlayVariableTypeHints           = false,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints        = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints          = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints  = true,
                  includeInlayVariableTypeHints           = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints        = true,
                },
              },
            },
          })
        end,

        -- Python
        pyright = function()
          lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  autoSearchPaths     = true,
                  diagnosticMode      = "workspace",
                  useLibraryCodeForTypes = true,
                  typeCheckingMode    = "basic",
                },
              },
            },
          })
        end,

        -- Rust
        rust_analyzer = function()
          lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            settings = {
              ["rust-analyzer"] = {
                cargo     = { allFeatures = true, loadOutDirsFromCheck = true },
                checkOnSave = { command = "clippy", extraArgs = { "--no-deps" } },
                procMacro = { enable = true },
                inlayHints = {
                  bindingModeHints         = { enable = false },
                  chainingHints            = { enable = true },
                  closingBraceHints        = { enable = true, minLines = 25 },
                  closureReturnTypeHints   = { enable = "never" },
                  lifetimeElisionHints     = { enable = "never", useParameterNames = false },
                  maxLength                = { enable = true, value = 25 },
                  parameterHints           = { enable = true },
                  reborrowHints            = { enable = "never" },
                  renderColons             = { enable = true },
                  typeHints                = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
                },
              },
            },
          })
        end,

        -- C / C++
        clangd = function()
          lspconfig.clangd.setup({
            capabilities = capabilities,
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
            },
            init_options = {
              usePlaceholders    = true,
              completeUnimported = true,
              clangdFileStatus   = true,
            },
          })
        end,

        -- JSON
        jsonls = function()
          lspconfig.jsonls.setup({
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,

        -- YAML
        yamlls = function()
          lspconfig.yamlls.setup({
            capabilities = capabilities,
            settings = {
              yaml = {
                schemaStore = { enable = false, url = "" },
                schemas     = require("schemastore").yaml.schemas(),
                keyOrdering = false,
                format      = { enable = true },
                validate    = true,
              },
            },
          })
        end,

        -- TOML
        taplo = function()
          lspconfig.taplo.setup({ capabilities = capabilities })
        end,

        -- CSS
        cssls = function()
          lspconfig.cssls.setup({
            capabilities = capabilities,
            settings = {
              css  = { validate = true, lint = { unknownAtRules = "ignore" } },
              scss = { validate = true, lint = { unknownAtRules = "ignore" } },
              less = { validate = true, lint = { unknownAtRules = "ignore" } },
            },
          })
        end,
      },
    })

    -- schemastore for jsonls/yamlls (install separately)
    -- add "b0o/schemastore.nvim" as dependency if needed
  end,
}
