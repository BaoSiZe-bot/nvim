return {
	{
		"xeluxee/competitest.nvim",
		event = "User FilePost",
		opts = {
			testcases_use_single_file = true,
			start_receiving_persistently_on_setup = true,
			compile_command = {
				c = { exec = "clang", args = { "$(FNAME)", "-o", "/tmp/c-$(FNOEXT)", "-O2", "-std=c17", "-g" } },
				cpp = { exec = "clang++", args = { "$(FNAME)", "-o", "/tmp/cpp-$(FNOEXT)", "-O2", "-std=c++20", "-g" } },
			},
			run_command = {
				c = { exec = "/tmp/c-$(FNOEXT)" },
				cpp = { exec = "/tmp/cpp-$(FNOEXT)" },
			},
		},
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
