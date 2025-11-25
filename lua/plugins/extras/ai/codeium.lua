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
		opts = {
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "codeium" },
				providers = {
					codeium = { name = "Codeium", module = "codeium.blink", async = true },
				},
			},
		},
	},
}
