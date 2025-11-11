return {
	{ "kevinhwang91/nvim-bqf", ft = "qf", opts = {} },
	{
		"yorickpeterse/nvim-pqf",
		ft = "qf",
		opts = {
			signs = {
				error = { text = "󰅙 ", hl = "DiagnosticSignError" },
				warning = { text = " ", hl = "DiagnosticSignWarn" },
				info = { text = "󰋼 ", hl = "DiagnosticSignInfo" },
				hint = { text = "󰋼 ", hl = "DiagnosticSignHint" },
			},
		},
		config = function(_, opts)
			require("pqf").setup(opts)
		end,
	},
}
