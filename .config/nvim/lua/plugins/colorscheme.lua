-- ColorSchemes --
return {
  { "ellisonleao/gruvbox.nvim" },

  { "ntk148v/habamax.nvim", dependencies = { "rktjmp/lush.nvim" } },
  { "rmehri01/onenord.nvim" },
  {
    "AlexvZyl/nordic.nvim",
    priority = 1000,
    opts = {
      -- swap_backgrounds = true,  -- use darker background
      cursorline = {
        theme = "light", -- cursor selection style
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nordic",
    },
  },
}
