return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "LazyFile",
	opts = function()
		return { mode = "cursor", max_lines = 3 }
	end,
}
