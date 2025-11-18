return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				sources = {
					explorer = {
						layout = {
							layout = {
								width = 0.2,
								height = 0.2,
								position = "right",
							},
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>fe",
				function()
					Snacks.explorer({ cwd = Abalone.root.get() })
				end,
				desc = "Explorer Snacks (root dir)",
			},
			{
				"<leader>fE",
				function()
					Snacks.explorer()
				end,
				desc = "Explorer Snacks (cwd)",
			},
			{ "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
		},
	},
	{
		"folke/snacks.nvim",
		opts = {
			explorer = {
				enabled = false,
			},
		},
	},
}
