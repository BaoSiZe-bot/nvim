-- [nfnl] Compiled from fnl/options.fnl by https://github.com/Olical/nfnl, do not edit.
local opt = vim.opt
local o = vim.o
local g = vim.g
o.laststatus = 3
o.showmode = false
o.relativenumber = true
o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4
o.smoothscroll = true
opt.fillchars = {foldopen = "\239\145\188", foldclose = "\239\145\160", fold = " ", foldsep = " ", diff = "\226\149\177", eob = " "}
opt.foldlevel = 99
opt.foldtext = ""
o.ignorecase = true
o.smartcase = true
o.mouse = "a"
o.number = true
o.numberwidth = 2
o.ruler = false
opt.shortmess:append("sI")
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.updatetime = 250
opt.whichwrap:append("<>[]hl")
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.root_spec = {"lsp", {".git", "lua"}, "cwd"}
return nil
