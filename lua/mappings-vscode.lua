-- [nfnl] Compiled from fnl/mappings.fnl by https://github.com/Olical/nfnl, do not edit.
local map = vim.keymap.set
local vscode = require("vscode")
vim.notify = vscode.notify
vim.keymap.set({ "n", "x" }, "<leader>", function()
	vscode.call("vspacecode.space")
end, {
	desc = "VSpaceCode",
})
vim.keymap.set({ "n", "x" }, ",", function()
	vscode.call("vspacecode.space")
	vscode.call("whichkey.triggerKey", {
		args = { "m" },
	})
end, {
	desc = "VSpaceCode Major",
	silent = false,
})
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("n", "<S-h>", "gT", { desc = "Prev Buffer", remap = true })
map("n", "<S-l>", "gt", { desc = "Next Buffer", remap = true })
local function _6_()
	vim.cmd("noh")
	return "<esc>"
end
map({ "i", "n", "s" }, "<esc>", _6_, { expr = true, desc = "Escape and Clear hlsearch" })
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
map({ "n", "x" }, "[d", function()
	vscode.call("editor.action.marker.prev")
end, { desc = "Prev Diagnostic" })
map({ "n", "x" }, "]d", function()
	vscode.call("editor.action.marker.next")
end, { desc = "Next Diagnostic" })
return nil
