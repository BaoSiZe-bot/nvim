return {
	"nvim-orgmode/orgmode",
	ft = { "org" },
	keys = { "<leader>va", "<leader>vn" },
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			org_agenda_files = "~/org/**/*",
			org_default_notes_file = "~/org/refile.org",
			mappings = {
				prefix = "<leader>v",
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
