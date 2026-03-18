return {
  -- Oxocarbon
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
    lazy     = false,
    config   = function()
      require("grimmvim.config.custom_functions").load_saved_theme()
    end,
  },

  -- Yugen
  {
    "bettervim/yugen.nvim",
    priority = 1000,
    lazy     = true,
  },

  -- Neomodern (5 variants: iceclimber, carburetor, forestfire, jasperbay, rosebones)
  {
    "casedami/neomodern.nvim",
    priority = 1000,
    lazy     = true,
  },

  -- Yorumi
  {
    "yorumicolors/yorumi.nvim",
    priority = 1000,
    lazy     = true,
  },
}
