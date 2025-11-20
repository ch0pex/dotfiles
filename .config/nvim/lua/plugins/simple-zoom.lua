-- lua/plugins/simple_zoom.lua
-- return {
--   "fasterius/simple-zoom.nvim",
--   opts = {
--     hide_tabline = true, -- oculta la tabline mientras se hace zoom
--   },
--   keys = {
--     -- Mapeo para toggle zoom con <leader>w z
--     { "<leader>wz", ":SimpleZoomToggle<CR>", desc = "Toggle Simple Zoom" },
--     -- Alternativa usando la función de lua directamente:
--     -- { "<leader>wz", function() require("simple-zoom").toggle_zoom() end, desc = "Toggle Simple Zoom" },
--   },
-- }
--
return {
  {
    "folke/zen-mode.nvim",
    keys = {
      {
        "<leader>wz",
        function()
          require("zen-mode").toggle()
        end,
        desc = "Toggle Zen Mode",
      },
    },
    config = function()
      require("zen-mode").setup({
        window = {
          width = 0.85, -- ancho del editor en porcentaje

          height = 0.9, -- alto opcional
          options = {
            number = true, -- mostrar número de línea
            relativenumber = true,
            signcolumn = "no",
          },
        },
        plugins = {
          gitsigns = { enabled = true },
          tmux = { enabled = false },
          twilight = { enabled = true }, -- oscurece lo que no es foco
        },
      })
    end,
  },
}
