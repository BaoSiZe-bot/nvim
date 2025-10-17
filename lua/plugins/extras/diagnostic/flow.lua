return {
	"dgagn/diagflow.nvim",
	event = "LspAttach",
	opts = {
		text_align = "right", -- 'left', 'right'
		scope = "cursor", -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
		padding_top = 0,
		padding_right = 0,
		gap_size = 1,
		show_borders = false,
		inline_padding_left = 0, -- the padding left when the placement is inline
		show_sign = false, -- set to true if you want to render the diagnostic sign before the diagnostic message
	},
}
