-- return {
--     "liubianshi/cmp-lsp-rimels",
--     keys = { { "<localleader>f", mode = "i" } },
--     branch = "blink.cmp",
--     opts = {
--         keys = { start = "<localleader>f", stop = "<localleader>;", esc = "<localleader>j" },
--         cmd = vim.lsp.rpc.connect("127.0.0.1", 9257),
--         -- schema_trigger_character = "&",
--         -- cmp_keymaps = {
--         --     disable = {
--         --         space = false,
--         --         numbers = false,
--         --         enter = false,
--         --         brackets = false,
--         --         backspace = false,
--         --     },
--         -- },
--     },
--     config = function(_, opts)
--         vim.system({
--             "rime_ls",
--             "--listen",
--             "127.0.0.1:9257",
--         }, { detach = true })
--         require("rimels").setup(opts)
--         vim.opt.iskeyword = "_,49-57,A-Z,a-z"
--     end,
-- }
return {
	"liubianshi/cmp-lsp-rimels",
	keys = { { "<localleader>f", mode = "i" } },
	branch = "blink.cmp",
	config = function()
		vim.system({ "rime_ls", "--listen", "127.0.0.1:9257" }, { detach = true })
		require("rimels").setup({
			keys = {
				start = "<localleader>f",
				stop = "<localleader>;",
				esc = "<localleader>j",
				undo = "<localleader>u",
			},
			schema_trigger_character = "&", -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
			cmd = vim.lsp.rpc.connect("127.0.0.1", 9257),
		})
		vim.opt.iskeyword = "_,49-57,A-Z,a-z"
	end,
}
