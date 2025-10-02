-- [nfnl] Compiled from fnl/mappings.fnl by https://github.com/Olical/nfnl, do not edit.
local map = vim.keymap.set
local vscode = require('vscode')
vim.notify = vscode.notify
vim.keymap.set("n", "<leader>", function()
    vscode.call("vspacecode.space")
end, {
    desc = "VSpaceCode"
})
vim.keymap.set({"n", "x"}, ",", function()
    vscode.call("vspacecode.space")
    vscode.call("whichkey.triggerKey", {
        args = {"m"}
    })
end, {
    desc = "VSpaceCode Major",
    silent = false
})
-- map({"n", "v"}, "<space>ft", _1_, {desc = "Open Terminal"})
-- map({"n", "i", "v"}, "<C-s>", "<cmd> w <cr>", {desc = "Save Buffer"})
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", {desc = "Move Down"})
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", {desc = "Move Up"})
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", {desc = "Move Down"})
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", {desc = "Move Up"})
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", {desc = "Move Down"})
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", {desc = "Move Up"})
map("n", "<S-h>", "gT", {desc = "Prev Buffer", remap = true})
map("n", "<S-l>", "gt", {desc = "Next Buffer", remap = true})
-- map("n", "<space>bd", _2_)
-- map("n", "<space>bo", _4_)
-- map("n", "<leader>bD", "<cmd>:bd<cr>", {desc = "Delete Buffer and Window"})
local function _6_()
  vim.cmd("noh")
  return "<esc>"
end
map({"i", "n", "s"}, "<esc>", _6_, {expr = true, desc = "Escape and Clear hlsearch"})
map("n", "n", "'Nn'[v:searchforward].'zv'", {expr = true, desc = "Next Search Result"})
map("x", "n", "'Nn'[v:searchforward]", {expr = true, desc = "Next Search Result"})
map("o", "n", "'Nn'[v:searchforward]", {expr = true, desc = "Next Search Result"})
map("n", "N", "'nN'[v:searchforward].'zv'", {expr = true, desc = "Prev Search Result"})
map("x", "N", "'nN'[v:searchforward]", {expr = true, desc = "Prev Search Result"})
map("o", "N", "'nN'[v:searchforward]", {expr = true, desc = "Prev Search Result"})
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", {desc = "Add Comment Below"})
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", {desc = "Add Comment Above"})
-- local function _7_()
--   return vim.lsp.buf.format()
-- end
-- map({"n", "v"}, "<leader>cf", _7_, {desc = "Format"})
-- map("n", "<leader>cd", vim.diagnostic.open_float, {desc = "Line Diagnostics"})
-- map("n", "]d", vim.diagnostic.goto_next, {desc = "Next Diagnostic"})
-- map("n", "[d", vim.diagnostic.goto_prev, {desc = "Prev Diagnostic"})
-- local function _8_()
--   return vim.diagnostic.goto_next({severity = 1})
-- end
-- map("n", "]e", _8_, {desc = "Next Error"})
-- local function _9_()
--   return vim.diagnostic.goto_prev({severity = 1})
-- end
-- map("n", "[e", _9_, {desc = "Prev Error"})
-- local function _10_()
--   return vim.diagnostic.goto_next({severity = 2})
-- end
-- map("n", "]w", _10_, {desc = "Next Warning"})
-- local function _11_()
--   return vim.diagnostic.goto_prev({severity = 2})
-- end
-- map("n", "[w", _11_, {desc = "Prev Warning"})
-- map("n", "<leader>qq", "<cmd>qa<cr>", {desc = "Quit All"})
-- map("n", "<leader>ui", vim.show_pos, {desc = "Inspect Pos"})
-- map("n", "<leader>uI", "<cmd>InspectTree<cr>", {desc = "Inspect Tree"})
-- map("t", "<C-/>", "<cmd>close<cr>", {desc = "Hide Terminal"})
-- map("t", "<c-_>", "<cmd>close<cr>", {desc = "which_key_ignore"})
-- map("n", "<leader>-", "<C-W>s", {desc = "Split Window Below", remap = true})
-- map("n", "<leader>|", "<C-W>v", {desc = "Split Window Right", remap = true})
-- map("n", "<leader>wd", "<C-W>c", {desc = "Delete Window", remap = true})
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", {desc = "Last Tab"})
-- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", {desc = "Close Other Tabs"})
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", {desc = "First Tab"})
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", {desc = "New Tab"})
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", {desc = "Next Tab"})
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", {desc = "Close Tab"})
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", {desc = "Previous Tab"})
return nil
