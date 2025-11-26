return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "Abalone" } },
			},
		},
	},
	{
		"saghen/blink.cmp",
		optional = true,
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			opts.sources.per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
			}
			opts.sources.providers = opts.sources.providers or {}
			opts.sources.providers.lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100, -- show at a higher priority than lsp
			}
			return opts
		end,
	},
}
