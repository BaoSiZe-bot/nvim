return {
	"rebelot/heirline.nvim",
	event = "UIEnter",
    -- stylua: ignore
	keys = {
		{ "<Leader>bse", function() Abalone.tabs.sort("extension") end, desc = "By extension" },
		{ "<Leader>bsp", function() Abalone.tabs.sort("full_path") end, desc = "By full path" },
		{ "<Leader>bsi", function() Abalone.tabs.sort("bufnr") end, desc = "By buffer number" },
		{ "<Leader>bsm", function() Abalone.tabs.sort("modified") end, desc = "By modification" },
	},
	opts = function()
		return require("configs.ui.heirline")
	end,
}
