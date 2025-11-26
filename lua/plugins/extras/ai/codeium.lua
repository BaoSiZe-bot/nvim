return {
	{
		"Exafunction/windsurf.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		config = function()
			require("codeium").setup({})
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"Exafunction/windsurf.nvim",
		},
		opts = function(_, opts)
			opts.sources.default = opts.sources.default or {}
			table.insert(opts.sources.default, "codeium")

			opts.sources.providers = opts.sources.providers or {}
			opts.sources.providers.codeium = {
				name = "Codeium",
				module = "codeium.blink",
				async = true,
			}
		end,
	},
}
