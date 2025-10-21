return {
	name = "clang_build",
	builder = function()
		-- Full path to current file (see :help expand())
		local file = vim.fn.expand("%:p")
		local tmpnoext = "/tmp/" .. vim.fn.expand("%:t:e") .. "-" .. vim.fn.expand("%:t:r")
		return {
			cmd = { "clang++" },
			args = { file, "-o", tmpnoext, "-Wall", "-Wextra", "-Wno-register", "-std=c++2c", "-g3" },
			components = {
				{
					"on_output_quickfix",
					open_on_exit = "failure",
					focus_on_open = true,
				},
				"default",
			},
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}
