return {
	'gisketch/triforce.nvim',
	dependencies = { 'nvzone/volt' },
	keys = {
		{
			'<leader>P',
			function()
				require('triforce').show_profile()
			end,
		},
	},
	opts = {},
}
