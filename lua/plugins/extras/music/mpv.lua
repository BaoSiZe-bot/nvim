return {
	"tamton-aquib/mpv.nvim",
	keys = {
		{
			"<leader>i",
			function()
				require("mpv").toggle_player()
			end,
			desc = "Open Music Player",
		},
	},
	opts = {
		border = "single",
	},
}
