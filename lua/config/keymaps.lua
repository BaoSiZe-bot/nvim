-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("which-key").add({
  { "<leader>a", group = "Full text", icon = "󰒆" },
  { "<leader>ac", "<cmd>%d-<CR>i", desc = "Edit", icon = "" },
  { "<leader>ak", "<cmd>%d<CR>", desc = "Cut", icon = "" },
  { "<leader>ad", "<cmd>%d-<CR>", desc = "Delete", icon = "" },
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
vim.keymap.set({ "i", "s" }, "<C-S-h>", "<Left>", { desc = "Left" })
vim.keymap.set({ "i", "s" }, "<C-S-j>", "<Down>", { desc = "Down" })
vim.keymap.set({ "i", "s" }, "<C-S-k>", "<Up>", { desc = "Up" })
vim.keymap.set({ "i", "s" }, "<C-S-l>", "<Right>", { desc = "Right" })
vim.keymap.set({ "n" }, "gR", "<cmd>URLOpenUnderCursor<cr>", { desc = "open url under cursor" })
function FlashWords()
  local Flash = require("flash")

  ---@param opts Flash.Format
  local function format(opts)
    -- always show first and second label
    return {
      { opts.match.label1, "FlashMatch" },
      { opts.match.label2, "FlashLabel" },
    }
  end

  Flash.jump({
    search = { mode = "search" },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      Flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { format = format },
        matcher = function(win)
          -- limit matches to the current label
          return vim.tbl_filter(function(m)
            return m.label == match.label and m.win == win
          end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2 -- use the second label
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end
function FlashLines()
  require("flash").jump({
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = "^",
  })
end
vim.keymap.set({ "o", "x", "n" }, "<leader>i", FlashWords, { desc = "Flash Words" })
vim.keymap.set({ "o", "x", "n" }, "<leader>j", FlashLines, { desc = "Flash Lines" })
