return {
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        opts = function()
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            keys[#keys + 1] = {
                "<leader>cr",
                function()
                    local inc_rename = require("inc_rename")
                    return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
                end,
                expr = true,
                desc = "Rename (inc-rename.nvim)",
                has = "rename",
            }
        end,
    },
    {
        "folke/noice.nvim",
        optional = true,
        opts = {
            presets = { inc_rename = true },
        },
    },
}
