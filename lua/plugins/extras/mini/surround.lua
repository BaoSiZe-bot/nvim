return {
	"nvim-mini/mini.surround",
	recommended = true,
	keys = function(_, keys)
		-- Populate the keys based on the user's options
		local mappings = {
			{ "gsa", desc = "Add Surrounding", mode = { "n", "v" } },
			{ "gsd", desc = "Delete Surrounding" },
			{ "gsF", desc = "Find Right Surrounding" },
			{ "gsf", desc = "Find Left Surrounding" },
			{ "gsh", desc = "Highlight Surrounding" },
			{ "gsr", desc = "Replace Surrounding" },
			{ "gsn", desc = "Update `MiniSurround.config.n_lines`" },
		}
		mappings = vim.tbl_filter(function(m)
			return m[1] and #m[1] > 0
		end, mappings)
		return vim.list_extend(mappings, keys)
	end,
	opts = {
		mappings = {
			add = "gsa", -- Add surrounding in Normal and Visual modes
			delete = "gsd", -- Delete surrounding
			find = "gsf", -- Find surrounding (to the right)
			find_left = "gsF", -- Find surrounding (to the left)
			highlight = "gsh", -- Highlight surrounding
			replace = "gsr", -- Replace surrounding
			update_n_lines = "gsn", -- Update `n_lines`
		},
	},
}
