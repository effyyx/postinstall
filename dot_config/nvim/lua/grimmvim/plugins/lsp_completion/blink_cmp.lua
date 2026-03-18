return {
  "saghen/blink.cmp",
  lazy = false,
  version = "*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  opts = {
    keymap = {
      preset = "default",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"]     = { "hide", "fallback" },
      ["<CR>"]      = { "accept", "fallback" },
      ["<Tab>"]     = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"]   = { "snippet_backward", "select_prev", "fallback" },
      ["<C-j>"]     = { "select_next", "fallback" },
      ["<C-k>"]     = { "select_prev", "fallback" },
      ["<C-d>"]     = { "scroll_documentation_down", "fallback" },
      ["<C-u>"]     = { "scroll_documentation_up", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant        = "mono",
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lazydev = {
          name   = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        lsp = {
          name   = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 10,
        },
        snippets = {
          name   = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = 5,
          opts = {
            friendly_snippets  = true,
            search_paths       = { vim.fn.stdpath("config") .. "/lua/grimmvim/plugins/lsp_completion/snippets" },
            global_snippets    = { "all" },
            extended_filetypes = {},
            ignored_filetypes  = {},
          },
        },
        buffer = {
          name   = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = -5,
        },
        path = {
          name   = "Path",
          module = "blink.cmp.sources.path",
        },
      },
    },

    snippets = {
      expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction) require("luasnip").jump(direction) end,
    },

    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        enabled      = true,
        min_width    = 15,
        max_height   = 10,
        border       = "rounded",
        winblend     = 0,
        scrollbar    = true,
        direction_priority = { "s", "n" },
        draw = {
          treesitter   = { "lsp" },
          columns      = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
          components = {
            kind_icon = {
              ellipsis = false,
              text     = function(ctx)
                local lspkind = require("lspkind")
                return lspkind.symbolic(ctx.kind, { mode = "symbol" })
              end,
              highlight = function(ctx)
                return ("BlinkCmpKind" .. ctx.kind)
              end,
            },
          },
        },
      },
      documentation = {
        auto_show         = true,
        auto_show_delay_ms = 200,
        update_delay_ms   = 50,
        treesitter_highlighting = true,
        window = {
          min_width  = 10,
          max_width  = 60,
          max_height = 20,
          border     = "rounded",
          winblend   = 0,
          scrollbar  = true,
        },
      },
      ghost_text = {
        enabled = true,
      },
      trigger = {
        prefetch_on_insert = false,
        show_in_snippet    = true,
        show_on_keyword    = true,
        show_on_trigger_character = true,
        show_on_blocked_trigger_characters = { " ", "\n", "\t" },
        show_on_accept_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
      },
      list = {
        max_items    = 200,
        selection    = { preselect = true, auto_insert = true },
        cycle        = { from_top = false },
      },
    },

    signature = {
      enabled = true,
      window  = {
        min_width         = 1,
        max_width         = 100,
        max_height        = 10,
        border            = "rounded",
        winblend          = 0,
        scrollbar         = false,
        direction_priority = { "n", "s" },
        treesitter_highlighting = true,
      },
    },

    fuzzy = {
      sorts = { "score", "sort_text" },
    },
  },
}
