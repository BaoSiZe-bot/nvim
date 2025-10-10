vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", repo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")
local lazyevent = require("lazy.core.handler.event")
lazyevent.mappings.LazyFile = {
	id = "LazyFile",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
}
local lazy = require("lazy")

require("options")
if not vim.g.vscode then
	lazy.setup({
		{
			import = "plugins",
		},
		{
			-- cond = vim.fn.has("nvim-0.12") == 1,
			import = "plugins.extras.ai.sidekick",
		},
		{
			import = "plugins.extras.editor.mini-hipatterns",
		},
		{
			import = "plugins.extras.editor.yazi",
		},
		{
			import = "plugins.extras.ui.rainbow",
		},
		{
			import = "plugins.extras.linting.linter",
		},
		{
			import = "plugins.extras.lang.org",
		},
		{
			import = "plugins.extras.editor.trouble",
		},
		{
			import = "plugins.extras.editor.yanky",
		},
		{
			import = "plugins.extras.editor.undo",
		},
		{
			import = "plugins.extras.editor.refactoring",
		},
		{
			import = "plugins.extras.ui.bqf",
		},
		{
			import = "plugins.extras.lang.clangd",
		},
		{
			import = "plugins.extras.lang.json",
		},
		{
			import = "plugins.extras.lang.markdown",
		},
		{
			import = "plugins.extras.dap.core",
		},
		{
			import = "plugins.extras.ui.edgy",
		},
		{
			import = "plugins.extras.git",
		},
		{
			import = "plugins.extras.editor.snacks"
		},
		{
			import = "plugins.extras.editor.oil",
		},
		-- {
		--    import = "plugins.extras.gemini"
		-- },
		-- {
		--    import = "plugins.extras.spacevim"
		--},
		{
			"Old-Farmer/im-autoswitch.nvim",
			event = "LazyFile",
			opts = {
				cmd = {
					-- default im
					default_im = "1",
					-- get current im
					get_im_cmd = "fcitx5-remote",
					-- cmd to switch im. the plugin will put an im name in "{}"
					-- or
					-- cmd to switch im between active/inactive
					switch_im_cmd = "fcitx5-remote -t",
				},
			},
		},
	}, lazy_config)
	require("mappings")
	require("autocmds")
	require("custom")
else
	require("mappings-vscode")
	lazy.setup({ {
		import = "plugins-vscode",
	} }, lazy_config)
end
