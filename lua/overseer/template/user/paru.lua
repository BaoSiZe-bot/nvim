return {
	name = "open_paru",
	builder = function()
		return {
			cmd = { "paru" },
			components = {
				{ "open_output", direction = "dock", focus = true },
				"default",
			},
		}
	end,
}
