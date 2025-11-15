return {
	{
		"catppuccin/nvim",
		-- lazy = false,
		name = "catppuccin",
		opts = {
			transparent_background = false, -- disables setting the background color.
			float = {
				transparent = false, -- enable transparent floating windows
				solid = false, -- use solid styling for floating windows, see |winborder|
			},
			background = {
				light = "latte",
				dark = "frappe",
			},
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			integrations = {
				blink_cmp = { style = "bordered" },
				-- blink_indent = true,
				flash = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				markview = true,
				diffview = true,
				fidget = true,
				mini = {
					enabled = true,
					indentscope_color = "text",
				},
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				dropbar = {
					enabled = true,
					color_mode = true, -- enable color for kind's texts, not just kind's icons
				},
				neotest = true,
				neotree = true,
				noice = true,
				semantic_tokens = true,
				snacks = {
					enabled = true,
					indentscope_color = "text",
				},
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
				ufo = true,
				nvim_surround = true,
				dap = true,
				dap_ui = true,
				neogit = true,
				gitgraph = true,
				octo = true,
				overseer = true,
				window_picker = true,
				rainbow_delimiters = true,
			},
			default_integrations = false,
			auto_integrations = false,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
		end,
	},

	{
		"folke/tokyonight.nvim",
		opts = { style = "moon" },
	},

	"askfiy/visual_studio_code",
	{
		"NTBBloodbath/doom-one.nvim",
		config = function()
			-- Add color to cursor
			vim.g.doom_one_cursor_coloring = true
			-- Set :terminal colors
			vim.g.doom_one_terminal_colors = true
			-- Enable italic comments
			vim.g.doom_one_italic_comments = true
			-- Enable TS support
			vim.g.doom_one_enable_treesitter = true
			-- Color whole diagnostic text or only underline
			vim.g.doom_one_diagnostics_text_color = false
			-- Enable transparent background
			vim.g.doom_one_transparent_background = false

			-- Pumblend transparency
			vim.g.doom_one_pumblend_enable = false
			vim.g.doom_one_pumblend_transparency = 20

			-- Plugins integration
			vim.g.doom_one_plugin_neorg = true
			vim.g.doom_one_plugin_barbar = false
			vim.g.doom_one_plugin_telescope = false
			vim.g.doom_one_plugin_neogit = true
			vim.g.doom_one_plugin_nvim_tree = false
			vim.g.doom_one_plugin_dashboard = false
			vim.g.doom_one_plugin_startify = false
			vim.g.doom_one_plugin_whichkey = true
			vim.g.doom_one_plugin_indent_blankline = false
			vim.g.doom_one_plugin_vim_illuminate = false
			vim.g.doom_one_plugin_lspsaga = false
		end,
	},
	"GustavoPrietoP/doom-themes.nvim",
	"NTBBloodbath/sweetie.nvim",
}
