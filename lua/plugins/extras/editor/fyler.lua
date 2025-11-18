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
						sidescrolloff = 0,
					},
					kinds = {
						split_right = {
							width = "20%",
						},
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>fp",
			function()
				require("fyler").toggle({
					dir = Abalone.root.get(), -- (Optional) Start in specific directory
					kind = "split_right", -- (Optional) Use custom window layout
				})
				vim.defer_fn(function()
					vim.cmd("normal! 0")
				end, 500)
			end,
			desc = "Toggle Fyler (Root dir)",
		},
		{
			"<leader>fP",
			function()
				require("fyler").toggle({
					dir = vim.uv.cwd(),
					kind = "split_right",
				})
				vim.defer_fn(function()
					vim.cmd("normal! 0")
				end, 500)
			end,
			desc = "Toggle Fyler (cwd)",
		},
		{ "<leader>e", "<leader>fp", desc = "Toggle Fyler (root dir)", remap = true },
		{ "<leader>E", "<leader>fP", desc = "Toggle Fyler (cwd)", remap = true },
	},
}
