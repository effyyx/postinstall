return {
  "L3MON4D3/LuaSnip",
  build = (function()
    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
    return "make install_jsregexp"
  end)(),
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require("luasnip")
    local types   = require("luasnip.util.types")

    luasnip.config.set_config({
      history                    = true,
      updateevents               = "TextChanged,TextChangedI",
      enable_autosnippets        = true,
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { " «", "NonText" } },
          },
        },
      },
    })

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/lua/grimmvim/plugins/lsp_completion/snippets" },
    })

    -- Load custom lua snippets
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/lua/grimmvim/plugins/lsp_completion/snippets" },
    })

    -- Keymaps
    local map = vim.keymap.set
    map({ "i", "s" }, "<C-l>", function()
      if luasnip.choice_active() then luasnip.change_choice(1) end
    end, { desc = "Next snippet choice" })
    map({ "i", "s" }, "<C-h>", function()
      if luasnip.choice_active() then luasnip.change_choice(-1) end
    end, { desc = "Prev snippet choice" })
    map("n", "<leader>sl", function()
      require("luasnip.loaders.from_lua").load({
        paths = { vim.fn.stdpath("config") .. "/lua/grimmvim/plugins/lsp_completion/snippets" },
      })
      vim.notify("Snippets reloaded", vim.log.levels.INFO)
    end, { desc = "Reload snippets" })
  end,
}
