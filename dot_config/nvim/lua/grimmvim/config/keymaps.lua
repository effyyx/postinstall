local map = vim.keymap.set

-- ============================================================
-- General
-- ============================================================
map("n", "<Esc>", "<cmd>nohlsearch<CR>",   { desc = "Clear search highlight" })
map("n", "<leader>w",  "<cmd>w<CR>",        { desc = "Save file" })
map("n", "<leader>W",  "<cmd>wa<CR>",       { desc = "Save all files" })
map("n", "<leader>qq", "<cmd>qa<CR>",       { desc = "Quit all" })
map("n", "<leader>qQ", "<cmd>qa!<CR>",      { desc = "Force quit all" })
map("n", "<leader>?",  "<cmd>WhichKey<CR>", { desc = "Which Key" })
map("n", "<leader>.",  function() Snacks.scratch() end,   { desc = "Scratch buffer" })
map("n", "<leader>u",  "<cmd>UndotreeToggle<CR>",         { desc = "Undotree" })

-- ============================================================
-- Navigation
-- ============================================================
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map({ "n", "v" }, "H", "^", { desc = "Start of line" })
map({ "n", "v" }, "L", "$", { desc = "End of line" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resize
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase window height" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease window height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Horizontal split" })
map("n", "<leader>se", "<C-w>=",          { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<CR>",  { desc = "Close split" })

-- ============================================================
-- Buffers  <leader>b
-- ============================================================
map("n", "<leader>bd", "<cmd>bdelete<CR>",                       { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bdelete|edit#|bdelete#<CR>",       { desc = "Delete other buffers" })
map("n", "<leader>bn", "<cmd>bnext<CR>",                         { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>",                     { desc = "Prev buffer" })
map("n", "<S-l>",      "<cmd>bnext<CR>",                         { desc = "Next buffer" })
map("n", "<S-h>",      "<cmd>bprevious<CR>",                     { desc = "Prev buffer" })
map("n", "[b",         "<cmd>bprevious<CR>",                     { desc = "Prev buffer" })
map("n", "]b",         "<cmd>bnext<CR>",                         { desc = "Next buffer" })

-- ============================================================
-- Files  <leader>f
-- ============================================================
map("n", "<leader>ff", function() Snacks.picker.files() end,                          { desc = "Find files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end,                           { desc = "Live grep" })
map("n", "<leader>fr", function() Snacks.picker.recent() end,                         { desc = "Recent files" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end,                        { desc = "Buffers" })
map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end,                    { desc = "LSP symbols" })
map("n", "<leader>fh", function() Snacks.picker.help() end,                           { desc = "Help pages" })
map("n", "<leader>fk", function() Snacks.picker.keymaps() end,                        { desc = "Keymaps" })
map("n", "<leader>fm", function() Snacks.picker.marks() end,                          { desc = "Marks" })
map("n", "<leader>fj", function() Snacks.picker.jumps() end,                          { desc = "Jumps" })
map("n", "<leader>fw", function() Snacks.picker.grep_word() end,                      { desc = "Grep word", })
map("n", "<leader>f/", function() Snacks.picker.lines() end,                          { desc = "Search buffer" })
map("n", "<leader>f:", function() Snacks.picker.command_history() end,                { desc = "Command history" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Config files" })
map("n", "-",          "<cmd>Oil<CR>",                                                { desc = "Oil file explorer" })
map("n", "<leader>-",  "<cmd>Oil --float<CR>",                                        { desc = "Oil (float)" })
map("n", "<leader>fn", function() require("grimmvim.config.custom_functions").rename_file() end, { desc = "Rename file" })

-- ============================================================
-- Git  <leader>g
-- ============================================================
map("n", "<leader>gs", function() Snacks.picker.git_status() end,   { desc = "Git status" })
map("n", "<leader>gc", function() Snacks.picker.git_log() end,       { desc = "Git commits" })
map("n", "<leader>gC", function() Snacks.picker.git_log_file() end,  { desc = "Git commits (file)" })
map("n", "<leader>gb", function() Snacks.picker.git_branches() end,  { desc = "Git branches" })

-- Git hunks (via gitsigns, set in gitsigns.lua on_attach)
-- Navigation here as fallback
map("n", "]h", function() require("gitsigns").next_hunk() end, { desc = "Next hunk" })
map("n", "[h", function() require("gitsigns").prev_hunk() end, { desc = "Prev hunk" })
map("n", "<leader>ghs", function() require("gitsigns").stage_hunk() end,          { desc = "Stage hunk" })
map("n", "<leader>ghr", function() require("gitsigns").reset_hunk() end,          { desc = "Reset hunk" })
map("n", "<leader>ghS", function() require("gitsigns").stage_buffer() end,        { desc = "Stage buffer" })
map("n", "<leader>ghR", function() require("gitsigns").reset_buffer() end,        { desc = "Reset buffer" })
map("n", "<leader>ghp", function() require("gitsigns").preview_hunk() end,        { desc = "Preview hunk" })
map("n", "<leader>ghb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
map("n", "<leader>ghd", function() require("gitsigns").diffthis() end,            { desc = "Diff this" })

-- ============================================================
-- LSP  <leader>l
-- ============================================================
map("n", "gd", function() Snacks.picker.lsp_definitions() end,      { desc = "Go to definition" })
map("n", "gr", function() Snacks.picker.lsp_references() end,        { desc = "Go to references" })
map("n", "gi", function() Snacks.picker.lsp_implementations() end,   { desc = "Go to implementation" })
map("n", "gt", function() Snacks.picker.lsp_type_definitions() end,  { desc = "Go to type definition" })
map("n", "gD", vim.lsp.buf.declaration,                              { desc = "Go to declaration" })
map("n", "K",  vim.lsp.buf.hover,                                    { desc = "Hover docs" })

map("n", "<leader>la", vim.lsp.buf.code_action,                                   { desc = "Code action" })
map("n", "<leader>ln", vim.lsp.buf.rename,                                        { desc = "Rename symbol" })
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,       { desc = "Format file" })
map("v", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,       { desc = "Format selection" })
map("n", "<leader>lI", "<cmd>LspInfo<CR>",                                        { desc = "LSP info" })
map("n", "<leader>lR", "<cmd>LspRestart<CR>",                                     { desc = "LSP restart" })
map("n", "<leader>ls", function() Snacks.picker.lsp_symbols() end,                { desc = "LSP symbols" })
map("n", "<leader>le", vim.diagnostic.open_float,                                 { desc = "Show diagnostic" })

-- Diagnostics navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- ============================================================
-- Sessions  <leader>s
-- ============================================================
map("n", "<leader>ss", "<cmd>SessionSave<CR>",    { desc = "Save session" })
map("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session" })
map("n", "<leader>sd", "<cmd>SessionDelete<CR>",  { desc = "Delete session" })
map("n", "<leader>sf", "<cmd>SessionSearch<CR>",  { desc = "Find session" })

-- ============================================================
-- Toggles  <leader>t
-- ============================================================
map("n", "<leader>te", function() require("grimmvim.config.custom_functions").theme_picker() end, { desc = "Theme picker" })
map("n", "<leader>th", "<cmd>Hardtime toggle<CR>",       { desc = "Toggle Hardtime" })
map("n", "<leader>tz", function() Snacks.zen() end,       { desc = "Toggle Zen mode" })
map("n", "<leader>tZ", function() Snacks.zen.zoom() end,  { desc = "Toggle Zoom mode" })
map("n", "<leader>td", function() require("grimmvim.config.custom_functions").toggle_diagnostics() end, { desc = "Toggle diagnostics" })
map("n", "<leader>tr", function() require("grimmvim.config.custom_functions").toggle_relative_numbers() end, { desc = "Toggle relative numbers" })
map("n", "<leader>tn", function() Snacks.notifier.hide() end, { desc = "Dismiss notifications" })
map("n", "<leader>tw", "<cmd>set wrap!<CR>",             { desc = "Toggle word wrap" })
map("n", "<leader>ts", "<cmd>set spell!<CR>",            { desc = "Toggle spell check" })

-- ============================================================
-- Notifications  <leader>n
-- ============================================================
map("n", "<leader>nh", function() Snacks.notifier.show_history() end, { desc = "Notification history" })
map("n", "<leader>nl", "<cmd>Noice last<CR>",                         { desc = "Last notification" })
map("n", "<leader>nd", "<cmd>Noice dismiss<CR>",                      { desc = "Dismiss notifications" })

-- ============================================================
-- Lists  <leader>x
-- ============================================================
map("n", "<leader>xq", "<cmd>copen<CR>",                              { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>lopen<CR>",                              { desc = "Location list" })
map("n", "<leader>xd", function() Snacks.picker.diagnostics() end,    { desc = "Diagnostics list" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })

-- ============================================================
-- Editing
-- ============================================================
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv",  { desc = "Indent right" })

map("n", "<A-j>", "<cmd>m .+1<CR>==",        { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==",        { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv",        { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv",        { desc = "Move selection up" })

-- Only in visual mode to avoid accidents
map("v", "p",  '"_dP',  { desc = "Paste without yanking" })
map("v", "_d", '"_d',   { silent = true })

map("n", "Y", "y$",    { silent = true })
map("n", "J", "mzJ`z", { silent = true })
map("n", "n", "nzzzv", { silent = true })
map("n", "N", "Nzzzv", { silent = true })

-- Search & Replace (under leader r to avoid accidents)
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })
map("v", "<leader>rw", ":s/\\%V//gI<Left><Left><Left><Left>",                   { desc = "Replace in selection" })
