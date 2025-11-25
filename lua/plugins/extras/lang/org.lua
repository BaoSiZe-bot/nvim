return {
	"nvim-orgmode/orgmode",
	dependencies = { "danilshvalov/org-modern.nvim", "akinsho/org-bullets.nvim" },
	ft = { "org" },
	keys = { "<leader>va", "<leader>vn" },
	config = function()
		local Menu = require("org-modern.menu")
		-- Setup orgmode
		require("orgmode").setup({
			ui = {
				menu = {
					handler = function(data)
						Menu:new({
							window = {
								margin = { 1, 0, 1, 0 },
								padding = { 0, 1, 0, 1 },
								title_pos = "center",
								border = "rounded",
								zindex = 1000,
							},
							icons = {
								separator = "➜",
							},
						}):open(data)
					end,
				},
			},

			org_agenda_files = "~/org/**/*",
			org_default_notes_file = "~/org/refile.org",
			mappings = {
				prefix = "<leader>v",
			},
		})
		require("org-bullets").setup()
		require("blink.cmp").setup({
			sources = {
				per_filetype = {
					org = { "orgmode" },
				},
				providers = {
					orgmode = {
						name = "Orgmode",
						module = "orgmode.org.autocompletion.blink",
						fallbacks = { "buffer" },
					},
				},
			},
		})

		-- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
		-- add ~org~ to ignore_install
		-- require('nvim-treesitter.configs').setup({
		--   ensure_installed = 'all',
		--   ignore_install = { 'org' },
		-- })
	end,
}
