local map = vim.keymap.set
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save Buffer", remap = true })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height", silent = true })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height", silent = true })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width", silent = true })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width", silent = true })
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down", silent = true })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up", silent = true })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down", silent = true })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up", silent = true })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down", silent = true })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up", silent = true })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Switch to Next Buffer" })
map("n", "<leader>bp", "<cmd>bprev<cr>", { desc = "Switch to Prev Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
if Abalone.lazy.has("snacks.nvim") then
	map("n", "<space>bd", function()
		Snacks.bufdelete()
	end, { desc = "Delete Buffer" })
	map("n", "<space>bo", function()
		Snacks.bufdelete.other()
	end, { desc = "Delete Other Buffers" })
else
	map("n", "<space>bd", "<cmd>bd", { silent = true, desc = "Delete Buffer" })
end
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
-- location list
map("n", "<leader>xl", function()
	local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Location List" })
map("n", "<leader>xq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Quickfix List" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map({ "n", "v" }, "<leader>cf", function()
	return require("conform").format({ lsp_format = "prefer" })
end, { desc = "Format" })

local show_float_if_diagnostic = function()
	local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
	if #diags > 0 then
		vim.diagnostic.open_float(nil, { focus = false })
	end
end
local show_diagnostic = function(opts)
	vim.validate("opts", opts, "table")
	vim.diagnostic.jump(opts)
	vim.defer_fn(show_float_if_diagnostic, 50)
end
map("n", "]d", function()
	return show_diagnostic({ count = 1 })
end, { desc = "Next Diagnostic" })
map("n", "[d", function()
	return show_diagnostic({ count = -1 })
end, { desc = "Prev Diagnostic" })
map("n", "]e", function()
	return show_diagnostic({ count = 1, severity = 1 })
end, { desc = "Next Error" })
map("n", "[e", function()
	return show_diagnostic({ count = -1, severity = 1 })
end, { desc = "Prev Error" })
map("n", "]w", function()
	return show_diagnostic({ count = 1, severity = 2 })
end, { desc = "Next Warning" })
map("n", "[w", function()
	return show_diagnostic({ count = -1, severity = 2 })
end, { desc = "Prev Warning" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function()
	vim.treesitter.inspect_tree()
	vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
if vim.fn.has("nvim-0.11") == false then
	map({ "i", "s" }, "<Tab>", function()
		if vim.snippet.active({ direction = 1 }) then
			return "<cmd>lua vim.snippet.jump(1)<cr>"
		else
			return "<Tab>"
		end
	end, { expr = true, desc = "Jump Next" })
	map({ "i", "s" }, "<S-Tab>", function()
		if vim.snippet.active({ direction = -1 }) then
			return "<cmd>lua vim.snippet.jump(-1)<cr>"
		else
			return "<S-Tab>"
		end
	end, { expr = true, desc = "Jump Previous" })
end
