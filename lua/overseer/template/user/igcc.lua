return {
    name = "open_igcc",
    builder = function()
        return {
            cmd = { "igcc" },
            components = { "default" },
            strategy = "toggleterm",
        }
    end,
}
