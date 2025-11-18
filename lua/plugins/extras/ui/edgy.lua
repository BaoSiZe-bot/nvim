return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>uet",
				function()
					require("edgy").toggle()
				end,
				desc = "Edgy Toggle",
			},
			{
				"<leader>ues",
				function()
					require("edgy").select()
				end,
				desc = "Edgy Select Window",
			},
		},
		opts = function()
			local opts = {
				bottom = {
					{
						ft = "toggleterm",
						title = "Terminal",
						size = { height = 0.4 },
						filter = function(buf, win)
							return vim.api.nvim_win_get_config(win).relative == ""
						end,
					},
					{
						ft = "noice",
						title = "Noice",
						size = { height = 0.4 },
						filter = function(buf, win)
							return vim.api.nvim_win_get_config(win).relative == ""
						end,
					},
					{ ft = "qf", title = "QuickFix" },
					{
						ft = "help",
						title = "Help",
						size = { height = 20 },
						-- don't open help files in edgy that we're editing
						filter = function(buf)
							return vim.bo[buf].buftype == "help"
						end,
					},
					{ title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
					{ title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
				},
				left = {
					{ title = "Neotest Summary", ft = "neotest-summary" },
					{ title = "Sidekick", ft = "sidekick_terminal", size = { width = 0.38 } },
					-- { title = "Avante", ft = "Avante", size = { width = 0.38 } },
				},
				right = {
					{ title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
					{ title = "Project", ft = "fyler", size = { width = 0.25 } },
				},
				keys = {
					-- increase width
					["<c-Right>"] = function(win)
						win:resize("width", 2)
					end,
					-- decrease width
					["<c-Left>"] = function(win)
						win:resize("width", -2)
					end,
					-- increase height
					["<c-Up>"] = function(win)
						win:resize("height", 2)
					end,
					-- decrease height
					["<c-Down>"] = function(win)
						win:resize("height", -2)
					end,
				},
			}
			-- trouble
			for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
				for _, mode in ipairs({ "diagnostics", "symbols", "lsp", "loclist", "qflist" }) do
					opts[pos] = opts[pos] or {}
					local upper_firstletter = function(s)
						if type(s) ~= "string" or #s == 0 then
							return s
						end
						local rest = string.sub(s, 2)
						local upper_first = string.upper(string.sub(s, 1, 1))
						return upper_first .. rest
					end
					local title = (mode == "lsp" and "References" or upper_firstletter(mode))
					table.insert(opts[pos], {
						ft = "trouble",
						title = title,
						filter = function(_buf, win)
							return vim.w[win].trouble
								and vim.w[win].trouble.mode == mode
								and vim.w[win].trouble.position == pos
								and vim.w[win].trouble.type == "split"
								and vim.w[win].trouble.relative == "editor"
								and not vim.w[win].trouble_preview
						end,
					})
				end
			end

			-- snacks terminal
			for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
				opts[pos] = opts[pos] or {}
				table.insert(opts[pos], {
					ft = "snacks_terminal",
					size = { height = 0.4 },
					title = "Terminal",
					filter = function(_buf, win)
						return vim.w[win].snacks_win
							and vim.w[win].snacks_win.position == pos
							and vim.w[win].snacks_win.relative == "editor"
							and not vim.w[win].trouble_preview
					end,
				})
			end
			return opts
		end,
	},
	{
		"lucobellic/edgy-group.nvim",
		enabled = false,
		event = "VeryLazy",
		dependencies = { "folke/edgy.nvim" },
		keys = {
			{
				"<leader>ueh",
				function()
					require("edgy-group").open_group_offset("left", 1)
				end,
				desc = "Edgy Group Next Left",
			},
			{
				"<leader>ueH",
				function()
					require("edgy-group").open_group_offset("left", -1)
				end,
				desc = "Edgy Group Prev Left",
			},
			{
				"<leader>uel",
				function()
					require("edgy-group").open_group_offset("right", 1)
				end,
				desc = "Edgy Group Next Right",
			},
			{
				"<leader>ueL",
				function()
					require("edgy-group").open_group_offset("right", -1)
				end,
				desc = "Edgy Group Prev Right",
			},
			{
				"<leader>uek",
				function()
					require("edgy-group").open_group_offset("top", 1)
				end,
				desc = "Edgy Group Next Top",
			},
			{
				"<leader>ueK",
				function()
					require("edgy-group").open_group_offset("top", -1)
				end,
				desc = "Edgy Group Prev Top",
			},
			{
				"<leader>uej",
				function()
					require("edgy-group").open_group_offset("bottom", 1)
				end,
				desc = "Edgy Group Next Bottom",
			},
			{
				"<leader>ueJ",
				function()
					require("edgy-group").open_group_offset("bottom", -1)
				end,
				desc = "Edgy Group Prev Bottom",
			},
			{
				"<leader>ueg",
				function()
					require("edgy-group.stl").pick()
					vim.cmd("redrawstatus")
				end,
				desc = "Edgy Group Pick",
			},
		},
		opts = {
			groups = {
				right = {
					{ icon = "", titles = { "Outline", "Symbols", "References" } },
					{ icon = "󱎸", titles = { "Grug Far" } },
					-- { icon = "", titles = { "Terminal" } }
				},
				left = {
					{ icon = "󰚩", titles = { "Sidekick", "Avante" } },
					-- { icon = "", titles = { "Terminal" } }
				},
				bottom = {
					{ icon = "", titles = { "Terminal" } },
					{ icon = "󰍡", titles = { "Noice" } },
					{ icon = "󰋗", titles = { "Help" } },
					{ icon = "󱖫", titles = { "Diagnostics", "QuickFix", "Loclist", "Qflist", "Neotest Output" } },
				},
				top = {
					-- { icon = "", titles = { "Terminal" } }
				},
			},
			statusline = {
				separators = { " ", " " },
				clickable = true,
				colored = true,
				colors = {
					active = "PmenuSel",
					inactive = "Pmenu",
				},
			},
		},
	},
}
