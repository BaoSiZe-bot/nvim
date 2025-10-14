return {
	"s1n7ax/nvim-window-picker",
	keys = {
		{
			"<Space>ww",
			function()
				local id = require("window-picker").pick_window()
				if id ~= nil then
					vim.api.nvim_set_current_win(id)
				end
			end,
			mode = { "n" },
			desc = "jump to window",
		},
	},
	opts = {
		hint = "floating-big-letter",
	},
}
