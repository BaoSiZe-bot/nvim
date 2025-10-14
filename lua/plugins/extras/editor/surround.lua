return {
	{
		"kylechui/nvim-surround",
		dependencies = {
			-- "XXiaoA/ns-textobject.nvim",
		},
		-- version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		-- event = "VeryLazy",
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local mappings = {
				{ "gsa", desc = "Add Surrounding", mode = { "n", "v" } },
				{ "gsA", desc = "Add Surrounding for this line", mode = { "n", "v" } },
				{ "gsd", desc = "Delete Surrounding" },
				{ "gsl", desc = "Add Surruonding(indent and enter)" },
				-- { "gsF", desc = "Find Right Surrounding" },
				-- { "gsf", desc = "Find Left Surrounding" },
				-- { "gsh", desc = "Highlight Surrounding" },
				{ "gsr", desc = "Replace Surrounding" },
				{ "gsR", desc = "Replace Surrounding(indent and enter)" },
				{ "gs<cr>", desc = "Add Surrounding for this line(indent and enter)" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			keymaps = {
				-- insert = "<C-g>s",
				-- insert_line = "<C-g>S",
				normal = "gsa",
				normal_cur = "gsA",
				normal_line = "gsl",
				normal_cur_line = "gs<cr>",
				visual = "gsa",
				visual_line = "gsA",
				delete = "gsd",
				change = "gsr",
				change_line = "gsR",
			},
		},
	},
	-- {
	-- 	"chrisgrieser/nvim-various-textobjs",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		keymaps = {
	-- 			useDefaults = true,
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"XXiaoA/ns-textobject.nvim",
	-- 	opts = {},
	-- },
}
