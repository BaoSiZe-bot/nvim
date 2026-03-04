return {
	{
		"kylechui/nvim-surround",
		dependencies = {
			-- "XXiaoA/ns-textobject.nvim",
		},
		-- version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		-- event = "VeryLazy",
		-- stylua: ignore
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local mappings = {
				{ "gsa", "<Plug>(nvim-surround-normal)", desc = "Add Surrounding" },
				{ "gsa", "<Plug>(nvim-surround-visual)", desc = "Add Surrounding", mode = "v" },
				{ "gsA", "<Plug>(nvim-surround-normal-cur)", desc = "Add Surrounding for this line" },
				{ "gsd", "<Plug>(nvim-surround-delete)", desc = "Delete Surrounding" },
				{ "gsl", "<Plug>(nvim-surround-normal-line)", desc = "Add Surrounding(indent and enter)" },
				-- { "gsF", desc = "Find Right Surrounding" },
				-- { "gsf", desc = "Find Left Surrounding" },
				-- { "gsh", desc = "Highlight Surrounding" },
				{ "gsr", "<Plug>(nvim-surround-change)", desc = "Replace Surrounding" },
				{ "gsR", "<Plug>(nvim-surround-change-line)", desc = "Replace Surrounding(indent and enter)" },
				{ "gs<cr>", "<Plug>(nvim-surround-normal-cur-line)", desc = "Add Surrounding for this line(indent and enter)" },
				{ "gs<cr>", "<Plug>(nvim-surround-visual-line)", desc = "Add Surrounding(indent and enter)", mode = "v" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {},
		config = function(_, opts)
			require("nvim-surround").setup(opts)
			vim.g.nvim_surround_no_mappings = true
		end,
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
