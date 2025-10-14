return {
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local mappings = {
				{ "gsa", desc = "Add Surrounding", mode = { "n", "v" } },
				{ "gsd", desc = "Delete Surrounding" },
				-- { "gsF", desc = "Find Right Surrounding" },
				-- { "gsf", desc = "Find Left Surrounding" },
				-- { "gsh", desc = "Highlight Surrounding" },
				{ "gsr", desc = "Replace Surrounding" },
				{ "gsn", desc = "Update `MiniSurround.config.n_lines`" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "gsa",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "gss",
				visual_line = "gsS",
				delete = "gsd",
				change = "gsr",
				change_line = "gsR",
			},
		},
	},
}
