local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================
-- Highlight on yank
-- ============================================================
autocmd("TextYankPost", {
  group = augroup("grimmvim_yank_highlight", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ============================================================
-- Remove trailing whitespace on save
-- ============================================================
autocmd("BufWritePre", {
  group = augroup("grimmvim_trailing_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- ============================================================
-- Restore cursor position on file open
-- ============================================================
autocmd("BufReadPost", {
  group = augroup("grimmvim_restore_cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ============================================================
-- Auto-resize splits on window resize
-- ============================================================
autocmd("VimResized", {
  group = augroup("grimmvim_resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- ============================================================
-- Close certain windows with q
-- ============================================================
autocmd("FileType", {
  group = augroup("grimmvim_close_with_q", { clear = true }),
  pattern = {
    "help", "lspinfo", "man", "notify", "qf", "startuptime",
    "tsplayground", "PlenaryTestPopup", "checkhealth", "spectre_panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- ============================================================
-- Wrap & spell in markdown and gitcommit
-- ============================================================
autocmd("FileType", {
  group = augroup("grimmvim_wrap_spell", { clear = true }),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- ============================================================
-- Detect extra filetypes
-- ============================================================
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("grimmvim_filetypes", { clear = true }),
  pattern = {
    "*.qml",     -- QML
    "*.conf",    -- generic conf
    "*.env",     -- dotenv
    "hyprland.conf", "hyprpaper.conf", "hyprlock.conf", "hypridle.conf", "*.hypr.conf",
  },
  callback = function(ev)
    local ext  = vim.fn.fnamemodify(ev.file, ":e")
    local name = vim.fn.fnamemodify(ev.file, ":t")
    if ext == "qml" then vim.bo.filetype = "qml" end
    if name:match("^hypr") and ext == "conf" then vim.bo.filetype = "hyprlang" end
    if ext == "conf" and not name:match("^hypr") then vim.bo.filetype = "conf" end
    if ext == "env" or vim.fn.fnamemodify(ev.file, ":t"):match("^%.env") then
      vim.bo.filetype = "sh"
    end
  end,
})

-- ============================================================
-- Auto-create parent dirs on save
-- ============================================================
autocmd("BufWritePre", {
  group = augroup("grimmvim_auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ============================================================
-- Disable diagnostics in .env files
-- ============================================================
autocmd("BufRead", {
  group = augroup("grimmvim_no_diag_env", { clear = true }),
  pattern = ".env*",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})
