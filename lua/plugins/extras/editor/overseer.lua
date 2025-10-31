return {
	{
		"stevearc/overseer.nvim",
		-- FIXME: ATTN: overseer.nvim will experience breaking changes soon. Pin to version v1.6.0 or earlier to avoid disruption. See: https://github.com/stevearc/overseer.nvim/pull/448
		-- version = "v1.6.0",
		branch = "stevearc-rewrite",
		cmd = {
			"OverseerOpen",
			"OverseerClose",
			"OverseerToggle",
			"OverseerRunCmd",
			"OverseerRun",
			"OverseerInfo",
			"OverseerBuild",
			"OverseerQuickAction",
			"OverseerTaskAction",
			"OverseerClearCache",
			"OverseerShell",
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
