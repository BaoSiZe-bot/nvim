return {
	name = "build_and_run",
	builder = function()
		return {
			cmd = { "/tmp/" .. vim.fn.expand("%:t:e") .. "-" .. vim.fn.expand("%:t:r") },
			cwd = vim.fn.expand("%:p:h"),
			components = {
				{
					"dependencies",
					task_names = {
						"clang_build",
					},
				},
				{ "open_output", direction = "dock", focus = true },
				"default",
			},
		}
	end,
	condition = {
		filetype = { "c", "cpp" },
	},
}
