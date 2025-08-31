-- Keymaps are automatically loadem on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

-- ToggleTerm
keymap.set("n", "<leader>t", "ToggleTerm", { noremap = true, desc = "ToggleTerm" })
keymap.set("n", "<leader>tt", ":ToggleTerm<cr>", { noremap = true, desc = "Toggle Terminal (default)" })
keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<cr>", { noremap = true, desc = "Toggle Terminal (float)" })
keymap.set(
  "n",
  "<leader>th",
  ":ToggleTerm direction=horizontal size=20<cr>",
  { noremap = true, desc = "Toggle Terminal (horizontal)" }
)
keymap.set(
  "n",
  "<leader>tv",
  ":ToggleTerm direction=vertical size=100<cr>",
  { noremap = true, desc = "Toggle Terminal (vertical)" }
)
