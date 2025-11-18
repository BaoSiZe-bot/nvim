return {
	{
		"rasulomaroff/reactive.nvim",
		event = "User FilePost",
		opts = {
			builtin = {
				-- cursorline = true,
				-- cursor = true,
				modemsg = true,
			},
			load = { "catppuccin-frappe-cursor", "catppuccin-frappe-cursorline" },
		},
	},
}
