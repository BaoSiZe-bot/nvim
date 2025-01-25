return {
    name = "open_python",
    builder = function()
        return {
            cmd = { "python" },
            components = { "default" },
            strategy = "toggleterm",
        }
    end,
}
