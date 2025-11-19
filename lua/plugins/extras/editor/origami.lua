return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		useLspFoldsWithTreesitterFallback = true,
		pauseFoldsOnSearch = true,
		foldtext = {
			enabled = true,
			padding = 3,
			lineCount = {
				template = " 󰁂 %d ", -- `%d` is replaced with the number of folded lines
				hlgroup = "@comment.hint",
			},
			diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
			gitsignsCount = true, -- requires `gitsigns.nvim`
			disableOnFt = { "snacks_picker_input" }, ---@type string[]
		},
		autoFold = {
			enabled = true,
			kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
		},
		foldKeymaps = {
			setup = false, -- modifies `h`, `l`, and `$`
			hOnlyOpensOnFirstColumn = false,
		},
	}, -- needed even when using default config

	-- recommended: disable vim's auto-folding
	config = function(_, opts)
		vim.o.foldenable = true
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		if vim.fn.has("nvim-0.12") ~= 0 then
			vim.o.fillchars = "diff:╱,eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
		else
			vim.o.fillchars = "diff:╱,eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
		end
		require("origami").setup(opts)
		vim.o.foldenable = true
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		if vim.fn.has("nvim-0.12") ~= 0 then
			vim.o.fillchars = "diff:╱,eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
		else
			vim.o.fillchars = "diff:╱,eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
		end
	end,
}
