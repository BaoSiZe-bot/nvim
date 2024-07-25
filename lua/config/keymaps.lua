-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("which-key").add({
  { "<leader>a", group = "Full text", icon = "󰒆" },
  { "<leader>ac", "<cmd>%d<CR>i", desc = "Edit", icon = "" },
  { "<leader>ad", "<cmd>%d<CR>", desc = "Cut", icon = "" },
  { "<leader>as", "ggVG<C-g>", desc = "Select(Select mode)", icon = "󱟁" },
  { "<leader>av", "ggVG", desc = "Select(Visual mode)", icon = "󰒅" },
  { "<leader>ay", "<cmd>%y<CR>", desc = "Copy", icon = "" },
  { "<leader>C", group = "Test", icon = "󰙨" },
  { "<leader>Cd", "<cmd>Comp delete_testcase<CR>", desc = "Delete testcase", icon = "󰆴" },
  { "<leader>Ce", "<cmd>Comp edit_testcase<CR>", desc = "Edit testcase", icon = "" },
  { "<leader>Cn", "<cmd>Comp add_testcase<CR>", desc = "New testcase", icon = "" },
  { "<leader>Cr", group = "Receive", icon = "󱃚" },
  { "<leader>Crc", "<cmd>Comp receive contest<CR>", desc = "Problems(Contest)", icon = " " },
  { "<leader>Crp", "<cmd>Comp receive problem<CR>", desc = "Problem", icon = "" },
  { "<leader>Crt", "<cmd>Comp receive testcases<CR>", desc = "Testcase", icon = "✔" },
  { "<leader>Ct", "<cmd>Comp run<CR>", desc = "Run test", icon = "󰙨" },
  { "<leader>n", group = "Neorg", icon = "" },
  { "<leader>nj", group = "journal", icon = "" },
  { "<leader>njd", "<cmd>Neorg journal today<cr>", desc = "today", icon = "󰃶" },
  { "<leader>njy", "<cmd>Neorg journal yesterday<cr>", desc = "yesterday", icon = "󰘁" },
  { "<leader>njt", "<cmd>Neorg journal tomorrow<cr>", desc = "tomorrow", icon = "󰒭" },
  { "<leader>nm", "<cmd>Neorg index<cr>", desc = "Notes", icon = "" },
})
vim.keymap.set("n", "<C-c>", "<cmd>%y<cr>", { desc = "Copy file" })
