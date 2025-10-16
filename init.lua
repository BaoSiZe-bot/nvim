vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	print("Bootstrapping lazy.nvim plugins manager...")
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
require("autocmds")
if not vim.g.vscode then
	lazy.setup({
		{ import = "plugins" },
		{ import = "plugins.extras.git" },
		{ import = "plugins.extras.sudo" },

		{ import = "plugins.extras.ai.sidekick" },
		{ import = "plugins.extras.ai.avante" },
		{ import = "plugins.extras.ai.copilot-native" },

		{ import = "plugins.extras.mini.ai" },
		{ import = "plugins.extras.mini.files" },
		{ import = "plugins.extras.mini.hipatterns" },
		{ import = "plugins.extras.mini.pairs" },
		-- { import = "plugins.extras.mini.surround" },

		{ import = "plugins.extras.dap.core" },

		-- { import = "plugins.extras.diagnostic.tiny" },
		{ import = "plugins.extras.diagnostic.sense" },

		{ import = "plugins.extras.editor.autopairs" },
		{ import = "plugins.extras.editor.dial" },
		{ import = "plugins.extras.editor.exchange" },
		{ import = "plugins.extras.editor.flash" },
		{ import = "plugins.extras.editor.grug-far" },
		{ import = "plugins.extras.editor.imas" },
		{ import = "plugins.extras.editor.mc" },
		{ import = "plugins.extras.editor.oil" },
		{ import = "plugins.extras.editor.overseer" },
		{ import = "plugins.extras.editor.refactoring" },
		{ import = "plugins.extras.editor.snacks" },
		{ import = "plugins.extras.editor.surround" },
		{ import = "plugins.extras.editor.splitjoin" },
		{ import = "plugins.extras.editor.trouble" },
		{ import = "plugins.extras.editor.ufo" },
		{ import = "plugins.extras.editor.undo" },
		{ import = "plugins.extras.editor.yanky" },
		-- { import = "plugins.extras.editor.yazi" },

		{ import = "plugins.extras.rime" },

		{ import = "plugins.extras.ui.bqf" },
		{ import = "plugins.extras.ui.edgy" },
		{ import = "plugins.extras.ui.firenvim" },
		{ import = "plugins.extras.ui.modicator" },
		{ import = "plugins.extras.ui.rainbow" },
		{ import = "plugins.extras.ui.statuscol" },
		{ import = "plugins.extras.ui.ts_context_vt" },

		{ import = "plugins.extras.trans" },
		{ import = "plugins.extras.win.picker" },
		{ import = "plugins.extras.win.shift" },

		{ import = "plugins.extras.linting.core" },

		{ import = "plugins.extras.lang.cpp" },
		{ import = "plugins.extras.lang.json" },
		{ import = "plugins.extras.lang.markdown" },
		{ import = "plugins.extras.lang.org" },
		{ import = "plugins.extras.lang.python" },

		-- { import = "plugins.extras.nyaovim" },
		-- { import = "plugins.extras.spacevim" },
	}, lazy_config)
	require("mappings")
	require("custom")
else
	require("mappings-vscode")
	lazy.setup({ {
		import = "plugins-vscode",
	} }, lazy_config)
end
