return {
  -- 1. Configure Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- Ensure it loads first
    config = true,
    opts = {
      transparent_mode = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
    },
  },

  -- 2. Tell LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- 3. Other themes (kept installed but inactive)
  { "lunacookies/vim-colors-xcode" },
  { "ntk148v/habamax.nvim", dependencies = { "rktjmp/lush.nvim" } },
  { "rmehri01/onenord.nvim" },
  { "AlexvZyl/nordic.nvim" },
  { "V4N1LLA-1CE/xcodedark.nvim" },
}
