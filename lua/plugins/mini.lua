return {
    {
        "nvim-mini/mini.icons",
        lazy = true,
        opts = {
            file = {
                [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
                ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
                ["robots.txt"] = { glyph = "󰚩", name = "robots" },
            },
            filetype = {
                dotenv = { glyph = "", hl = "MiniIconsYellow" },
                default_icon = { glyph = "󰈚", name = "Default" },
                cpp = { glyph = "", name = "cpp" },
                js = { glyph = "󰌞", name = "js" },
                ts = { glyph = "󰛦", name = "ts" },
                lock = { glyph = "󰌾", name = "lock" },
            },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    { "nvim-mini/mini.trailspace", opts = {}, event = "LazyFile" },
    {
        "nvim-mini/mini.bracketed",
        event = "LazyFile",
        opts = {}
    }
}
