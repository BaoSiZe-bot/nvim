return {
	{
		"xeluxee/competitest.nvim",
		event = "User FilePost",
		opts = {},
		config = function(_, opts)
			require("competitest").setup(opts)
			require("which-key").add({
				{ "<leader>t", group = "Test", icon = "" },
				{ "<leader>tr", group = "Receive", icon = "󱃚" },
				{ "<leader>tt", "<cmd>Comp run<CR>", desc = "Run test", icon = "" },
				{ "<leader>tn", "<cmd>Comp add_testcase<CR>", desc = "New testcase", icon = "" },
				{ "<leader>te", "<cmd>Comp edit_testcase<CR>", desc = "Edit testcase", icon = "󰷈" },
				{ "<leader>td", "<cmd>Comp delete_testcase<CR>", desc = "Delete testcase", icon = "󰆴" },
				{ "<leader>trp", "<cmd>Comp receive problem<CR>", desc = "Problem", icon = "" },
				{ "<leader>trt", "<cmd>Comp receive testcases<CR>", desc = "Testcase", icon = "✔" },
				{ "<leader>trc", "<cmd>Comp receive contest<CR>", desc = "Problems(Contest)", icon = " " },
			})
		end,
	},
	{
		"Bot-wxt1221/Luogu-On-Neovim",
		enabled = false,
		event = "VeryLazy",
		build = function()
			require("Luogu-On-Neovim").install()
		end,
		opts = {},
	},
}
