return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy     = false,
  opts = {
    -- Big file handling
    bigfile   = { enabled = true },
    -- Dashboard
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys",   gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        header = "",
        keys = {
          { icon = " ", key = "f", desc = "Find File",       action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "g", desc = "Find Text",       action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recent Files",    action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "c", desc = "Config",          action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { icon = "󰒲 ", key = "l", desc = "Lazy",           action = ":Lazy" },
          { icon = " ", key = "t", desc = "Theme Picker",    action = ":lua require('grimmvim.config.custom_functions').theme_picker()" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "q", desc = "Quit",            action = ":qa" },
        },
      },
    },
    -- Indent guides
    indent = {
      enabled = true,
      indent = {
        char   = "│",
        hl     = "SnacksIndent",
      },
      scope = {
        enabled   = true,
        char      = "│",
        hl        = "SnacksIndentScope",
        underline = false,
      },
    },
    -- Input (better vim.input)
    input     = { enabled = true },
    -- Notifications
    notifier  = {
      enabled = true,
      timeout = 3000,
      style   = "compact",
    },
    -- Quick file picker
    picker = {
      enabled = true,
      sources = {},
    },
    -- Rename (LSP-aware)
    rename    = { enabled = true },
    -- Scrollbar
    scroll    = { enabled = false },
    -- Status column
    statuscolumn = {
      enabled = true,
      folds = {
        open   = false,
        git_hl = false,
      },
    },
    -- Words (highlight word under cursor)
    words = { enabled = true },
    -- Zen mode
    zen = {
      enabled = true,
      toggles = {
        dim        = true,
        git_signs  = false,
        mini_diff  = false,
        diagnostics = false,
        inlay_hints = false,
      },
      zoom = {
        toggles    = {},
        show = { statusline = false, tabline = false },
        win = { style = "zen" },
      },
    },
  },
  keys = {
    { "]]", function() Snacks.words.jump(vim.v.count1) end,  desc = "Next word reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev word reference", mode = { "n", "t" } },
    { "S",  false },
  },
}
