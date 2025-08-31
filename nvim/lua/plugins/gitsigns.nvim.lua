return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    opts = {
      -- Copiado y adaptado de https://www.lazyvim.org/plugins/editor#gitsignsnvim
      signs = {

        add = { text = "" }, -- nf-fa-plus
        change = { text = "" }, -- nf-oct-dot
        delete = { text = "" }, -- nf-fa-minus
        topdelete = { text = "󰐊" }, -- nf-md-arrow_up_thick (requiere Nerd Font 2.3+)
        changedelete = { text = "" }, -- nf-oct-dot
        untracked = { text = "" }, -- nf-oct-file
      },

      signs_staged = {
        add = { text = "▎" },

        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },

      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Keymaps con descripción
        map("n", "<leader>hr", gitsigns.reset_hunk, "GitSigns: Reset hunk")

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "GitSigns: Reset selected hunk")
        map("n", "<leader>hd", gitsigns.preview_hunk_inline, "GitSigns: Preview hunk inline")
        map("n", "<leader>hn", function()
          gitsigns.nav_hunk("next")
        end, "GitSigns: Go to next hunk")
        map("n", "<leader>hp", function()
          gitsigns.nav_hunk("prev")
        end, "GitSigns: Go to previous hunk")
      end,
    },
  },
}
