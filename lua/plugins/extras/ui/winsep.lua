return {
	{
		"nvim-zh/colorful-winsep.nvim",
		opts = {},
		event = { "WinLeave" },
	},
	{
		"catppuccin/nvim",
		optional = true,
		opts = {
			integration = {
				colorful_winsep = true,
			},
		},
	},
}
