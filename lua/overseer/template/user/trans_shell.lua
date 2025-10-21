return {
	name = "open_transshell",
	builder = function()
		return {
			cmd = { "trans -e bing -I" },
			components = {
				{ "open_output", direction = "dock", focus = true },
				"default",
			},
		}
	end,
}
