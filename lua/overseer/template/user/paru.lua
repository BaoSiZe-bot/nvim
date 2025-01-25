return {
    name = "open_paru",
    builder = function()
        return {
            cmd = { "paru" },
            strategy = "toggleterm",
            components = { "default" },
        }
    end,
}
