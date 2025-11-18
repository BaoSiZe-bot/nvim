return {
	{
		"francescarpi/buffon.nvim",
		branch = "main",
		event = "VeryLazy",
		---@type BuffonConfig
		opts = {
			cyclic_navigation = true,
			leader_key = ";",
			mapping_chars = "qweryuiop",
			num_pages = 3,
			open = {
				default_position = "bottom_right",
			},
			keybindings = {
				goto_next_buffer = "<buffonleader>]",
				goto_previous_buffer = "<buffonleader>[",
				move_buffer_up = "<buffonleader>k",
				move_buffer_down = "<buffonleader>j",
				move_buffer_top = "<buffonleader>h",
				move_buffer_bottom = "<buffonleader>l",
				toggle_buffon_window = "<buffonleader>n",
				--- Toggle window position allows moving the main window position
				--- between top-right and bottom-right positions
				toggle_buffon_window_position = "<buffonleader>t",
				switch_previous_used_buffer = "<buffonleader><buffonleader>",
				close_buffer = "<buffonleader>d",
				close_buffers_above = "<buffonleader>v",
				close_buffers_below = "<buffonleader>b",
				close_all_buffers = "<buffonleader>cc",
				close_others = "<buffonleader>cd",
				reopen_recent_closed_buffer = "<buffonleader>t",
				show_help = "<buffonleader>?",
				previous_page = "<buffonleader>z",
				next_page = "<buffonleader>x",
				move_to_previous_page = "<buffonleader>a",
				move_to_next_page = "<buffonleader>s",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"catppuccin/nvim",
		optional = true,
		opts = {
			integration = {
				buffon = true,
			},
		},
	},
}
