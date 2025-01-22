-- require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

function DeleteCurrentBuffer(cbn)
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  local size = 0
  local idx = 0
  for n, e in ipairs(buffers) do
    size = size + 1
    if e.bufnr == cbn then
      idx = n
    end
  end
  if idx == 0 then return end
  if idx == size then
    vim.cmd("bprevious")
  else
    vim.cmd("bnext")
  end
  vim.cmd("bd! " .. cbn)
end

-- map("i", "jk", "<ESC>")
map({ "n", "i", "v" }, "<f9>", function()
    require("snacks.terminal").toggle()
end, { desc = "Open Terminal" })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
require("which-key").add({
    { "<leader>a", group = "Full text", icon = "󰒆" },
    { "<leader>ac", "<cmd>%d_<CR>i", desc = "Edit", icon = "" },
    { "<leader>ak", "<cmd>%d<CR>", desc = "Cut", icon = "" },
    { "<leader>ad", "<cmd>%d_<CR>", desc = "Delete", icon = "" },
    { "<leader>as", "ggVG<C-g>", desc = "Select(Select mode)", icon = "󱟁" },
    { "<leader>av", "ggVG", desc = "Select(Visual mode)", icon = "󰒅" },
    { "<leader>ay", "<cmd>%y<CR>", desc = "Copy", icon = "" },
    { "<leader>t", group = "Test", icon = "󰙨" },
    { "<leader>td", "<cmd>Comp delete_testcase<CR>", desc = "Delete testcase", icon = "󰆴" },
    { "<leader>te", "<cmd>Comp edit_testcase<CR>", desc = "Edit testcase", icon = "" },
    { "<leader>tn", "<cmd>Comp add_testcase<CR>", desc = "New testcase", icon = "" },
    { "<leader>tr", group = "Receive", icon = "󱃚" },
    { "<leader>trc", "<cmd>Comp receive contest<CR>", desc = "Problems(Contest)", icon = " " },
    { "<leader>trp", "<cmd>Comp receive problem<CR>", desc = "Problem", icon = "" },
    { "<leader>trt", "<cmd>Comp receive testcases<CR>", desc = "Testcase", icon = "✔" },
    { "<leader>tt", "<cmd>Comp run<CR>", desc = "Run test", icon = "󰙨" },
    { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>;", ":", desc = "goto command mode" },
    { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<leader>bd", function() DeleteCurrentBuffer() end, desc = "Delete Buffer"}
})
