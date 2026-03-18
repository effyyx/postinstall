return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    -- nvim-notify setup
    require("notify").setup({
      background_colour = "#000000",
      fps              = 60,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO  = "",
        TRACE = "✎",
        WARN  = "",
      },
      level        = 2,
      minimum_width = 50,
      render       = "wrapped-compact",
      stages       = "fade_in_slide_out",
      timeout      = 3000,
      top_down     = true,
    })

    require("noice").setup({
      cmdline = {
        enabled  = true,
        view     = "cmdline_popup",
        opts     = {},
        format = {
          cmdline     = { pattern = "^:",     icon = "", lang = "vim" },
          search_down = { kind = "search",    icon = " ", lang = "regex" },
          search_up   = { kind = "search",    icon = " ", lang = "regex" },
          filter      = { pattern = "^:%s*!",  icon = "$", lang = "bash" },
          lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help        = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
        },
      },
      messages = {
        enabled      = true,
        view         = "notify",
        view_error   = "notify",
        view_warn    = "notify",
        view_history = "messages",
        view_search  = "virtualtext",
      },
      popupmenu = {
        enabled  = true,
        backend  = "nui",
        kind_icons = {},
      },
      redirect = {
        view   = "popup",
        filter = { event = "msg_show" },
      },
      commands = {
        history = {
          view    = "split",
          opts    = { enter = true, format = "details" },
          filter  = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "" } },
              { event = "lsp",      kind = "message" },
            },
          },
        },
        last = {
          view   = "popup",
          opts   = { enter = true, format = "details" },
          filter = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "" } },
              { event = "lsp",      kind = "message" },
            },
          },
          filter_opts = { count = 1 },
        },
        errors = {
          view   = "popup",
          opts   = { enter = true, format = "details" },
          filter = { error = true },
          filter_opts = { reverse = true },
        },
      },
      notify = {
        enabled = true,
        view    = "notify",
      },
      lsp = {
        progress = {
          enabled = true,
          format  = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle   = 1000 / 30,
          view       = "mini",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
        hover = {
          enabled = true,
          silent  = false,
          view    = nil,
          opts    = {},
        },
        signature = {
          enabled      = true,
          auto_open = {
            enabled   = true,
            trigger   = true,
            luasnip   = true,
            throttle  = 50,
          },
          view = nil,
          opts = {},
        },
        message  = { enabled = true, view = "notify", opts = {} },
        documentation = {
          view = "hover",
          opts = {
            lang         = "markdown",
            replace      = true,
            render       = "plain",
            format       = { "{message}" },
            win_options  = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      markdown = {
        hover = {
          ["|(%S-)|"] = vim.cmd.help,
          ["%[.-%]%((%S-)%)"] = require("noice.util").open,
        },
        highlights = {
          ["|%S-|"] = "@text.reference",
          ["@%S+"]  = "@parameter",
          ["^%s*(Parameters:)"] = "@text.title",
          ["^%s*(Return:)"]     = "@text.title",
          ["^%s*(See also:)"]   = "@text.title",
          ["{%S-}"]             = "@parameter",
        },
      },
      health = { checker = true },
      presets = {
        bottom_search       = false,
        command_palette     = true,
        long_message_to_split = true,
        inc_rename          = false,
        lsp_doc_border      = true,
      },
    })

    -- Keymaps
    local map = vim.keymap.set
    map("n", "<leader>sn",  function() require("noice").cmd("history") end,       { desc = "Noice history" })
    map("n", "<leader>sna", function() require("noice").cmd("all") end,            { desc = "Noice all" })
    map("n", "<leader>snd", function() require("noice").cmd("dismiss") end,        { desc = "Dismiss notifications" })
    map("n", "<leader>snl", function() require("noice").cmd("last") end,           { desc = "Noice last" })
    map({ "n", "i", "s" }, "<C-f>", function()
      if not require("noice.lsp").scroll(4) then return "<C-f>" end
    end, { silent = true, expr = true, desc = "Scroll forward (noice/lsp)" })
    map({ "n", "i", "s" }, "<C-b>", function()
      if not require("noice.lsp").scroll(-4) then return "<C-b>" end
    end, { silent = true, expr = true, desc = "Scroll backward (noice/lsp)" })
  end,
}
