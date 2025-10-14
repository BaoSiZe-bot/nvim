return {
	{
		"sindrets/winshift.nvim",
		keys = {
			{
				"<space>wm",
				function()
					require("winshift").cmd_winshift()
				end,
				desc = "Shift window",
			},
			{
				"<space>wX",
				function()
					require("winshift").cmd_winshift("swap")
				end,
				desc = "Shift window",
			},
		},
		opts = {},
	},
}
