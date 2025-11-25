return {
	"baosize-bot/symbol-overlay.nvim",
	opts = {},
    -- stylua: ignore
	keys = {
        { "<leader>ho", function() require("symbol-overlay").add() end, desc = "Overlay: add current word" },
        { "<leader>hd", function() require("symbol-overlay").remove() end, desc = "Overlay: delete current word" },
        { "<leader>hc", function() require("symbol-overlay").clear() end, desc = "Overlay: clear all word" },
        { "<leader>hn", function() require("symbol-overlay").next() end, desc = "Overlay: next" },
        { "<leader>hN", function() require("symbol-overlay").prev() end, desc = "Overlay: prev" },
        { "<leader>hr", function() require("symbol-overlay").rename() end, desc = "Overlay: rename" },
        { "<leader>ht", function() require("symbol-overlay").toggle() end, desc = "Overlay: toggle current word" },
        { "<leader>h]", function() require("symbol-overlay").switch_forward() end, desc = "Overlay: switch to next nearby highlight" },
        { "<leader>h[", function() require("symbol-overlay").switch_backward() end, desc = "Overlay: switch to prev nearby highlight" },
        -- add a hydra mode for symbol-overlay, which-key is needed
        { "<leader>h<space>", function() require("which-key").show({ keys = "<leader>h", loop = true }) end, desc = "Symbol Overlay Hydra Mode" }
	},
}
