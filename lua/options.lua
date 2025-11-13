-- [nfnl] Compiled from fnl/options.fnl by https://github.com/Olical/nfnl, do not edit.
local opt = vim.opt
local o = vim.o
local g = vim.g
_G.Abalone = require("utils")
if not g.vscode then
	opt.scrolloff = 4
	opt.iskeyword = "_,49-57,A-Z,a-z"
	opt.wrap = false
	opt.sidescrolloff = 36
	g.snacks_animate = true
	opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
	opt.guifont = "JetbrainsMono Nerd Font:h14"
	opt.laststatus = 3
	opt.showmode = false
	opt.number = true
	opt.relativenumber = true
	opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
	opt.cursorline = true
	opt.cursorlineopt = "number"
	opt.expandtab = true
	opt.shiftwidth = 4
	opt.smartindent = true
	opt.tabstop = 4
	opt.softtabstop = 4
	opt.smoothscroll = true
	opt.fillchars = {
		foldopen = "\239\145\188",
		foldclose = "\239\145\160",
		fold = " ",
		foldsep = " ",
		diff = "\226\149\177",
		eob = " ",
	}
	opt.foldlevel = 99
	opt.foldmethod = "indent"
	opt.foldtext = ""
	opt.ignorecase = true
	opt.smartcase = true
	opt.mouse = "a"
	opt.numberwidth = 2
	opt.ruler = false
	opt.shortmess:append("sI")
	opt.signcolumn = "yes"
	opt.splitbelow = true
	opt.splitright = true
	opt.timeoutlen = 400
	opt.undofile = true
	opt.updatetime = 250
	opt.whichwrap:append("<>[]hl")
	g.loaded_node_provider = 0
	g.loaded_python3_provider = 0
	g.loaded_perl_provider = 0
	g.loaded_ruby_provider = 0
	g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
else
	-- o.showmode = false
	o.clipboard = "unnamedplus"
	-- o.relativenumber = true
	-- o.number = true
	-- o.numberwidth = 2
	-- o.expandtab = true
	-- o.shiftwidth = 4
	-- o.tabstop = 4
	-- o.softtabstop = 4
	-- o.ignorecase = true
	-- o.smartcase = true
	-- o.signcolumn = "yes"
	-- o.splitbelow = true
	-- o.splitright = true
	-- o.timeoutlen = 400
	-- o.undofile = true
	-- o.updatetime = 250
end
if g.neovide then
	g.neovide_opacity = 0.8
	g.neovide_normal_opacity = 0.8
	g.neovide_cursor_vfx_mode = "ripple"
	g.neovide_input_ime = 0
end

require("configs.lsp.hover").setup()
