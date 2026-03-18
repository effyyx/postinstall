local M = {}

-- ============================================================
-- Theme Switcher
-- ============================================================
M.themes = {
  { name = "Oxocarbon",            colorscheme = "oxocarbon" },
  { name = "Yugen",                colorscheme = "yugen" },
  { name = "Neomodern Iceclimber", colorscheme = "neomodern", variant = "iceclimber" },
  { name = "Neomodern Carburetor", colorscheme = "neomodern", variant = "carburetor" },
  { name = "Neomodern Forestfire", colorscheme = "neomodern", variant = "forestfire" },
  { name = "Neomodern Jasperbay",  colorscheme = "neomodern", variant = "jasperbay" },
  { name = "Neomodern Rosebones",  colorscheme = "neomodern", variant = "rosebones" },
  { name = "Yorumi",               colorscheme = "yorumi" },
}

-- Persist theme selection
local theme_file = vim.fn.stdpath("data") .. "/grimmvim_theme.txt"

function M.load_saved_theme()
  local f = io.open(theme_file, "r")
  if f then
    local saved = f:read("*l")
    f:close()
    if saved and saved ~= "" then
      if saved:match("^neomodern:") then
        local variant = saved:match("^neomodern:(.*)")
        pcall(require("neomodern").load, variant)
      else
        local ok, err = pcall(vim.cmd.colorscheme, saved)
        if not ok then
          vim.notify("GrimmVim: Could not load saved theme '" .. saved .. "': " .. err, vim.log.levels.WARN)
        end
      end
      return
    end
  end
  -- Default theme
  pcall(vim.cmd.colorscheme, "oxocarbon")
end

function M.save_theme(t)
  local f = io.open(theme_file, "w")
  if f then
    if type(t) == "table" and t.colorscheme == "neomodern" then
      f:write("neomodern:" .. t.variant)
    elseif type(t) == "table" then
      f:write(t.colorscheme)
    else
      f:write(t)
    end
    f:close()
  end
end

function M.theme_picker()
  vim.ui.select(M.themes, {
    prompt = "󰉢  Select Theme",
    format_item = function(t) return t.name end,
  }, function(choice)
    if choice then
      if choice.colorscheme == "neomodern" then
        require("neomodern").load(choice.variant)
      else
        pcall(vim.cmd.colorscheme, choice.colorscheme)
      end
      M.save_theme(choice)
      vim.notify("Theme set to: " .. choice.name, vim.log.levels.INFO)
    end
  end)
end

-- ============================================================
-- Toggle relative line numbers
-- ============================================================
function M.toggle_relative_numbers()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

-- ============================================================
-- Rename current file
-- ============================================================
function M.rename_file()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("Rename file: ", old_name, "file")
  if new_name ~= "" and new_name ~= old_name then
    vim.cmd("saveas " .. new_name)
    vim.fn.delete(old_name)
    vim.cmd("bdelete #")
    vim.notify("File renamed to " .. new_name, vim.log.levels.INFO)
  end
end

-- ============================================================
-- Toggle diagnostics
-- ============================================================
local diagnostics_enabled = true
function M.toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.enable(0)
    vim.notify("Diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.disable(0)
    vim.notify("Diagnostics disabled", vim.log.levels.WARN)
  end
end

return M
