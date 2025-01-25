return {
    name = "open_transshell",
    builder = function()
        return {
            cmd = { "trans -e bing -I" },
            components = { "default" },
            strategy = "toggleterm",
        }
    end,
}
