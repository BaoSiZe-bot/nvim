return {
	{
		"Isrothy/neominimap.nvim",
		version = "v3.x.x",
		enabled = false,
		cond = vim.g.started_by_firenvim ~= true,
		event = "LazyFile",
		priority = 1919810,
		init = function()
			vim.opt.wrap = false
			vim.opt.sidescrolloff = 36
			vim.g.neominimap = {
				auto_enable = true,
				float = {
					window_border = "none",
				},
			}
		end,
	},
	{
		"dstein64/nvim-scrollview",
		event = "UIEnter",
		cond = vim.g.started_by_firenvim ~= true,
	},
	{
		"sphamba/smear-cursor.nvim",
		event = "CursorMoved",
		cond = vim.g.neovide == nil and vim.g.started_by_firenvim ~= true,
		opts = {
			hide_target_hack = true,
			cursor_color = "none",
		},
		specs = {
			-- disable mini.animate cursor
			{
				"nvim-mini/mini.animate",
				optional = true,
				opts = {
					cursor = { enable = false },
				},
			},
		},
	},
	{
		"LuxVim/nvim-luxmotion",
		cond = vim.g.started_by_firenvim ~= true,
		enabled = false, -- kill it because it cause matchit don't work, it cause I can't insert 'web' in select mode.
		event = "CursorMoved",
		config = function()
			require("luxmotion").setup({
				cursor = {
					duration = 250,
					easing = "ease-out",
					enabled = true,
				},
				scroll = {
					duration = 400,
					easing = "ease-out",
					enabled = true,
				},
				performance = { enabled = true },
				keymaps = {
					cursor = true,
					scroll = true,
				},
			})
		end,
	},
	-- {
	-- 	"rainbowhxch/beacon.nvim",
	-- 	cond = vim.g.started_by_firenvim ~= true and not vim.g.neovide,
	-- 	event = "CursorMoved",
	-- },
	-- {
	-- 	"levouh/tint.nvim",
	-- 	event = "UIEnter",
	-- 	opts = {},
	-- },
}
