local function set_highlights()
  local highlights = {
    -- Make floating windows slightly transparent
    NormalFloat   = { bg = "NONE" },
    FloatBorder   = { fg = "#7aa2f7", bg = "NONE" },

    -- Cleaner diff highlights
    DiffAdd       = { bg = "#1e3a2f" },
    DiffChange    = { bg = "#1f2a3d" },
    DiffDelete    = { bg = "#3a1e1e" },
    DiffText      = { bg = "#2a3f5f" },

    -- Subtle cursorline
    CursorLine    = { bg = "#1e2030" },

    -- Make indent guides subtle
    IblIndent     = { fg = "#2a2d40" },
    IblScope      = { fg = "#565f89" },

    -- Transparent signcolumn
    SignColumn    = { bg = "NONE" },

    -- Better visual selection
    Visual        = { bg = "#2d3f76" },
    VisualNOS     = { bg = "#2d3f76" },

    -- LSP semantic tokens
    ["@lsp.type.parameter"]    = { italic = true },
    ["@lsp.type.variable"]     = { fg = "NONE" },
    ["@variable.builtin"]      = { italic = true, bold = true },
    ["@keyword.return"]        = { italic = true },
    ["@comment"]               = { italic = true, fg = "#5c6370" },
    ["@string.documentation"]  = { italic = true },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Re-apply on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("grimmvim_highlights", { clear = true }),
  callback = set_highlights,
})

-- Apply immediately
set_highlights()
