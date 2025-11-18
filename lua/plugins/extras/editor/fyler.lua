return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	opts = {
		hooks = {
			on_rename = function(from, to)
				if Abalone.lazy.has("snacks.nvim") then
					Snacks.rename.on_rename_file(from, to)
				end
			end,
		},
		views = {
			finder = {
				delete_to_trash = true,
				close_on_select = false,
				confirm_simple = true,
				default_explorer = true,
				watcher = {
					enabled = true,
				},
				indentscope = {
					enabled = not Abalone.lazy.has("blink.indent"),
					group = "FylerIndentMarker",
					marker = "│",
				},
				win = {
					win_opts = {
						concealcursor = "nvic",
						conceallevel = 3,
						cursorline = true,
						cursorlineopt = "both",
						number = true,
						foldcolumn = "0",
						relativenumber = true,
						winhighlight = "Normal:FylerNormal,NormalNC:FylerNormalNC",
						wrap = false,
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>fp",
			function()
				require("fyler").open({
					dir = Abalone.root.get(), -- (Optional) Start in specific directory
					kind = "split_right_most", -- (Optional) Use custom window layout
				})
			end,
			desc = "Open Fyler (Root dir)",
		},
		{
			"<leader>fP",
			function()
				require("fyler").open({
					dir = vim.uv.cwd(),
					kind = "split_right_most",
				})
			end,
			desc = "Open Fyler (cwd)",
		},
		{ "<leader>e", "<leader>fp", desc = "Open Fyler (root dir)", remap = true },
		{ "<leader>E", "<leader>fP", desc = "Open Fyler (cwd)", remap = true },
	},
}
