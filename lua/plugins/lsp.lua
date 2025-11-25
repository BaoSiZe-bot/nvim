return {
	{
		"mizlan/delimited.nvim",
		event = "LspAttach",
		keys = {
			{
				"[d",
				function()
					require("delimited").goto_prev()
				end,
				desc = "Diagnostic backward",
			},
			{
				"[e",
				function()
					require("delimited").goto_prev({
						severity = vim.diagnostic.severity.ERROR,
					})
				end,
				desc = "Error backward",
			},
			{
				"[w",
				function()
					require("delimited").goto_prev({
						severity = vim.diagnostic.severity.WARN,
					})
				end,
			},
			{
				"]d",
				function()
					require("delimited").goto_next()
				end,
				desc = "Diagnostic forward",
			},
			{
				"]e",
				function()
					require("delimited").goto_next({
						severity = vim.diagnostic.severity.ERROR,
					})
				end,
				desc = "Error forward",
			},
			{
				"]w",
				function()
					require("delimited").goto_next({
						severity = vim.diagnostic.severity.WARN,
					})
				end,
				desc = "Warning forward",
			},
		},
		opts = {
			pre = function()
				-- do something here
			end,
			post = function()
				-- do something here
			end,
		},
	},
	{
		"soulis-1256/eagle.nvim",
		event = "LspAttach",
		opts = {},
		config = function(_, opts)
			vim.o.mousemoveevent = true
			require("eagle").setup(opts)
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		opts = {
			lsps = { "lua" },
		},
		config = vim.schedule_wrap(function(_, opts)
			for _, lsp_name in ipairs(opts.lsps) do
				require("configs.lsp.servers." .. lsp_name).setup()
			end
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end),
	},

	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true },
			float = {
				enabled = false,
				text = " ",
				lens_text = " ",
			},
			status_text = {
				enabled = true,
				text = " ",
				lens_text = " ",
			},
			sign = {
				enabled = true,
				text = " ",
				lens_text = " ",
			},
			number = {
				enabled = true,
			},
			code_lenses = true,
		},
	},

	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
	},
}
