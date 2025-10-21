return {
	name = "open_igcc",
	builder = function()
		return {
			cmd = { "igcc" },
			components = {
				{ "open_output", direction = "dock", focus = true },
				"default",
			},
		}
	end,
}
