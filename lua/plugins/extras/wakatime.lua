return {
	"wakatime/vim-wakatime",
	lazy = false,
	build = function()
		vim.cmd("WakaTimeApiKey")
	end,
}
