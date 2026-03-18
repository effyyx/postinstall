return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    -- Custom components
    local function lsp_clients()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then return "" end
      local names = {}
      for _, c in ipairs(clients) do
        if c.name ~= "null-ls" and c.name ~= "copilot" then
          table.insert(names, c.name)
        end
      end
      return " " .. table.concat(names, ", ")
    end

    local function diff_source()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added    = gitsigns.added,
          modified = gitsigns.changed,
          removed  = gitsigns.removed,
        }
      end
    end

    local function show_macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then return "" end
      return "󰑋  @" .. reg
    end

    lualine.setup({
      options = {
        icons_enabled        = true,
        theme                = "auto",
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        disabled_filetypes   = {
          statusline = { "dashboard", "alpha", "starter" },
          winbar     = {},
        },
        ignore_focus   = {},
        always_divide_middle = true,
        globalstatus   = true,
        refresh = {
          statusline = 100,
          tabline    = 100,
          winbar     = 100,
        },
      },
      sections = {
        lualine_a = {
          { "mode", icon = "" },
        },
        lualine_b = {
          { "branch", icon = "" },
          {
            "diff",
            source  = diff_source,
            symbols = { added = " ", modified = " ", removed = " " },
          },
          {
            "diagnostics",
            sources  = { "nvim_diagnostic" },
            symbols  = { error = " ", warn = " ", hint = "󰠠 ", info = " " },
          },
        },
        lualine_c = {
          {
            "filename",
            path    = 1,
            symbols = { modified = "  ", readonly = "  ", unnamed = "  " },
          },
          { show_macro_recording },
        },
        lualine_x = {
          lsp_clients,
          "encoding",
          { "fileformat", symbols = { unix = "", dos = "", mac = "" } },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", icon = "" },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline    = {},
      winbar     = {},
      extensions = { "oil", "lazy", "quickfix", "mason" },
    })
  end,
}
