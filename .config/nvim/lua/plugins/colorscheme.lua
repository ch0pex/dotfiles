-- ColorSchemes --
return {
  { "ellisonleao/gruvbox.nvim" },

  { "ntk148v/habamax.nvim", dependencies = { "rktjmp/lush.nvim" } },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "habamax",
    },
  },
}
