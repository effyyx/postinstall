return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset  = "modern",
    delay   = 300,
    filter  = function(mapping)
      if not mapping.desc or mapping.desc == "" then return false end
      -- Hide single letter keys that clutter the top level
      local hide = { D=1, R=1, S=1, N=1, c=1 }
      if hide[mapping.lhs] then return false end
      return true
    end,
    spec = {
      { "<leader>b",  group = "󰓩  Buffers" },
      { "<leader>f",  group = "  Files & Find" },
      { "<leader>g",  group = "  Git" },
      { "<leader>gh", group = "  Hunks" },
      { "<leader>l",  group = "  LSP" },
      { "<leader>n",  group = "  Notifications" },
      { "<leader>q",  group = "  Quit" },
      { "<leader>r",  group = "  Replace" },
      { "<leader>s",  group = "  Sessions" },
      { "<leader>t",  group = "  Toggle" },
      { "<leader>x",  group = "  Lists" },
      { "g",          group = "  Goto" },
      { "z",          group = "  Fold/Spell" },
      { "]",          group = "  Next" },
      { "[",          group = "  Prev" },
    },
    icons = {
      breadcrumb  = "»",
      separator   = "➜",
      group       = "+",
      ellipsis    = "…",
      rules       = false,
      colors      = true,
      keys = {
        Up     = " ", Down  = " ", Left  = " ", Right = " ",
        C      = "󰘴 ", M     = "󰘵 ", D     = "󰘳 ", S    = "󰘶 ",
        CR     = "󰌑 ", Esc   = "󱊷 ", BS    = "⌫ ", Tab  = "󰌒 ",
        Space  = "󱁐 ",
      },
    },
    win = {
      border      = "rounded",
      padding     = { 1, 2 },
      wo          = { winblend = 5 },
    },
    layout = {
      width   = { min = 20 },
      spacing = 3,
    },
    show_help  = true,
    show_keys  = true,
    sort       = { "local", "order", "group", "alphanum", "mod" },
  },
}
