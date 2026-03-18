return {
  -- Smart commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("ts_context_commentstring").setup({ enable_autocmd = false })
      require("Comment").setup({
        padding      = true,
        sticky       = true,
        ignore       = nil,
        toggler      = { line = "gcc", block = "gbc" },
        opleader     = { line = "gc",  block = "gb" },
        extra        = { above = "gcO", below = "gco", eol = "gcA" },
        mappings     = { basic = true, extra = true },
        pre_hook     = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        post_hook    = nil,
      })
    end,
  },

  -- Surround motions
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    config  = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Undo tree
  {
    "mbbill/undotree",
    cmd  = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
    config = function()
      vim.g.undotree_WindowLayout       = 2
      vim.g.undotree_SplitWidth         = 30
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_RelativeTimestamp  = 1
      vim.g.undotree_ShortIndicators    = 0
      vim.g.undotree_TreeNodeShape      = "●"
      vim.g.undotree_TreeVertShape      = "│"
      vim.g.undotree_TreeSplitShape     = "╱"
      vim.g.undotree_TreeReturnShape    = "╲"
    end,
  },

  -- Hardtime (enforce good habits)
  {
    "m4xshen/hardtime.nvim",
    event       = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>uh", "<cmd>Hardtime toggle<CR>", desc = "Toggle Hardtime" },
    },
    opts = {
      max_time           = 1000,
      max_count          = 4,
      disable_mouse      = false,
      hint               = true,
      notification       = true,
      allow_different_key = false,
      enabled            = false,  -- opt-in; toggle with <leader>uh
      resetting_keys = {
        ["c"] = { "n" }, ["C"] = { "n" },
        ["d"] = { "n" }, ["D"] = { "n" },
        ["x"] = { "n" }, ["X"] = { "n" },
        ["y"] = { "n" }, ["Y"] = { "n" },
        ["p"] = { "n" }, ["P"] = { "n" },
        ["r"] = { "n" }, ["s"] = { "n" }, ["S"] = { "n" },
      },
      restricted_keys = {
        ["h"]    = { "n", "x" },
        ["j"]    = { "n", "x" },
        ["k"]    = { "n", "x" },
        ["l"]    = { "n", "x" },
        ["-"]    = { "n", "x" },
        ["+"]    = { "n", "x" },
        ["gj"]   = { "n", "x" },
        ["gk"]   = { "n", "x" },
        ["<CR>"] = { "n", "x" },
        ["<C-M>"] = { "n", "x" },
        ["<C-N>"] = { "n", "x" },
        ["<C-P>"] = { "n", "x" },
      },
      disabled_keys = {
        ["<Up>"]    = { "n", "i", "v" },
        ["<Down>"]  = { "n", "i", "v" },
        ["<Left>"]  = { "n", "i", "v" },
        ["<Right>"] = { "n", "i", "v" },
      },
      disabled_filetypes = {
        "qf", "netrw", "NvimTree", "lazy", "mason", "oil",
        "TelescopePrompt", "snacks_dashboard",
      },
    },
  },

  -- Substitute (better s motion)
  {
    "gbprod/substitute.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      on_substitute          = nil,
      yank_substituted_text  = false,
      preserve_cursor_position = false,
      modifiers              = nil,
      highlight_substituted_text = {
        enabled  = true,
        timer    = 200,
      },
      range = {
        prefix     = "s",
        prompt_current_text = false,
        confirm    = false,
        complete_word = false,
        subject    = nil,
        range      = nil,
        suffix     = "",
        auto_apply = false,
        cursor_position = "end",
      },
      exchange = {
        motion       = false,
        use_esc_to_cancel = true,
        preserve_cursor_position = false,
      },
    },
    config = function(_, opts)
      require("substitute").setup(opts)
      local sub = require("substitute")
      local map = vim.keymap.set
      map("n", "sx",  sub.operator,    { desc = "Substitute operator" })
      map("n", "sxx", sub.line,        { desc = "Substitute line" })
      map("n", "sX",  sub.eol,         { desc = "Substitute to EOL" })
      map("x", "sx",  sub.visual,      { desc = "Substitute visual" })
      -- Exchange
      local exc = require("substitute.exchange")
      map("n", "se",  exc.operator,    { desc = "Exchange operator" })
      map("n", "see", exc.line,        { desc = "Exchange line" })
      map("x", "se",  exc.visual,      { desc = "Exchange visual" })
    end,
  },
}
