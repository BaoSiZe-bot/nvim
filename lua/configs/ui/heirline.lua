local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local function setup_colors()
	return {
		red = utils.get_highlight("DiagnosticError").fg,
		green = utils.get_highlight("String").fg,
		blue = utils.get_highlight("Function").fg,
		gray = utils.get_highlight("NonText").fg,
		orange = utils.get_highlight("Constant").fg,
		purple = utils.get_highlight("Statement").fg,
		cyan = utils.get_highlight("Special").fg,
		diag_warn = utils.get_highlight("DiagnosticWarn").fg,
		diag_error = utils.get_highlight("DiagnosticError").fg,
		diag_hint = utils.get_highlight("DiagnosticHint").fg,
		diag_info = utils.get_highlight("DiagnosticInfo").fg,
		git_del = utils.get_highlight("DiagnosticError").fg,
		git_add = utils.get_highlight("String").fg,
		git_change = utils.get_highlight("Function").fg,
	}
end
require("heirline").load_colors(setup_colors)
vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		utils.on_colorscheme(setup_colors)
	end,
	group = "Heirline",
})

local StatusLines = require("configs.ui.statusline")
local TabLine = require("configs.ui.tabline")
local WinBars = require("configs.ui.winbar")

-- Yep, with heirline we're driving manual!
vim.o.showtabline = 1
vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
return {
	statusline = StatusLines,
	winbar = WinBars,
	tabline = TabLine,
	opts = {
		-- if the callback returns true, the winbar will be disabled for that window
		-- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
		disable_winbar_cb = function(args)
			return conditions.buffer_matches({
				buftype = { "nofile", "prompt", "help", "quickfix" },
				filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
			}, args.buf)
		end,
	},
}
