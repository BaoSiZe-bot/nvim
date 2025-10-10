return {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    opts = function()
        return require("configs.ui.heirline")
    end,
}
