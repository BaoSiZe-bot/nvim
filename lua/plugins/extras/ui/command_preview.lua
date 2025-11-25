return {
	"smjonas/live-command.nvim",
	event = "CmdlineEnter",
	-- live-command supports semantic versioning via Git tags
	-- tag = "2.*",
	opts = {
		commands = {
			Norm = { cmd = "norm" },
		},
	},
	config = function(_, opts)
		require("live_command").setup(opts)
	end,
}
