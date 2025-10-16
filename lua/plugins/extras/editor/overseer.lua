return {
	{
		"stevearc/overseer.nvim",
		dependencies = {
			{
				"akinsho/toggleterm.nvim",
				cmd = { "ToggleTerm" },
				opts = {},
			},
		},
		cmd = {
			"OverseerOpen",
			"OverseerClose",
			"OverseerToggle",
			"OverseerSaveBundle",
			"OverseerLoadBundle",
			"OverseerDeleteBundle",
			"OverseerRunCmd",
			"OverseerRun",
			"OverseerInfo",
			"OverseerBuild",
			"OverseerQuickAction",
			"OverseerTaskAction",
			"OverseerClearCache",
		},
		keys = {
			{ "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
			{ "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
			{ "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
			{ "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
			{ "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Task builder" },
			{ "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
			{ "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
		},
		opts = {
			-- dap = false,
			form = {
				win_opts = {
					winblend = 0,
				},
			},
			confirm = {
				win_opts = {
					winblend = 0,
				},
			},
			task_win = {
				win_opts = {
					winblend = 0,
				},
			},
			task_list = {
				bindings = {
					["<C-h>"] = false,
					["<C-j>"] = false,
					["<C-k>"] = false,
					["<C-l>"] = false,
				},
			},
			templates = {
				"builtin",
				"user.cpp_build",
				"user.file_runner",
				"user.python",
				"user.igcc",
				"user.trans_shell",
				"user.paru",
			},
		},
	},
	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			opts.right = opts.right or {}
			table.insert(opts.right, {
				title = "Overseer",
				ft = "OverseerList",
				open = function()
					require("overseer").open()
				end,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>o", group = "tasks", icon = " " },
			},
		},
	},
	{
		"catppuccin",
		optional = true,
		opts = {
			integrations = { overseer = true },
		},
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			require("overseer").enable_dap()
		end,
	},
}
