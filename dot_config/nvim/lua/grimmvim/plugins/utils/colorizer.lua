-- colorizer.lua
return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    filetypes = { "*", "!lazy" },
    buftype   = { "*", "!prompt", "!nofile" },
    user_default_options = {
      RGB          = true,
      RRGGBB       = true,
      names        = false,
      RRGGBBAA     = true,
      AARRGGBB     = false,
      rgb_fn       = true,
      hsl_fn       = true,
      css          = true,
      css_fn       = true,
      mode         = "background",
      tailwind     = "both",
      sass         = { enable = true, parsers = { "css" } },
      virtualtext  = "■",
      always_update = false,
    },
    buftypes = {},
  },
}
