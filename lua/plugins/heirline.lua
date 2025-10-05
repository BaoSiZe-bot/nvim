return {
    "rebelot/heirline.nvim",
    event = "LazyFile",
    opts = function()
        return require("configs.ui.heirline")
    end,
}
