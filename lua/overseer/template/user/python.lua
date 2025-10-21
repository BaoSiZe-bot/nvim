return {
	name = "open_python",
	builder = function()
		return {
			cmd = { "ipython" },
			components = {
				{ "open_output", direction = "dock", focus = true },
				"default",
			},
		}
	end,
}
