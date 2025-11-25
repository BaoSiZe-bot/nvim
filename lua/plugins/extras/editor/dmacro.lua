return {
	"tani/dmacro.nvim",
	event = "User FilePost",
	keys = {
		{
			"<c-t>",
			"<Plug>(dmacro-play-macro)",
			desc = "Play the macro",
			mode = { "i", "n" },
		},
	},
}
