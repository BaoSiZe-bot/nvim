return {
    "A7Lavinraj/fyler.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    opts = {
        auto_confirm_simple_mutation = true,
        bound_cursor = true,
        follow_current_file = true,
        kind = 'split_right',
        ui = {
            -- Whether to draw indent guides at each depth level.
            hidden_items = {
                -- Toggleable pre-defined switches (e.g. 'dotfiles' to hide files starting with a dot).
                switches = { 'dotfiles' },
                -- Toggleable patterns (Lua patterns matched against the full path).
                patterns = {},
                -- Always visible items matching these patterns, even if they would normally be hidden.
                always_visible = {},
                -- Always hide items matching these patterns, even if they would normally be visible.
                always_hidden = {},
            },
            indent_guides = true,
        },
        integrations = { icon = 'mini_icons' },
        hooks = {
            on_rename = function(from, to)
                if Abalone.lazy.has("snacks.nvim") then
                    Snacks.rename.on_rename_file(from, to)
                end
            end,
        },
    },
    keys = {
        {
            "<leader>fp",
            function()
                require("fyler").toggle({
                    dir = Abalone.root.get(), -- (Optional) Start in specific directory
                    kind = "split_right",     -- (Optional) Use custom window layout
                })
                vim.defer_fn(function()
                    vim.cmd("normal! 0")
                end, 500)
            end,
            desc = "Toggle Fyler (Root dir)",
        },
        {
            "<leader>fP",
            function()
                require("fyler").toggle({
                    dir = vim.uv.cwd(),
                    kind = "split_right",
                })
                vim.defer_fn(function()
                    vim.cmd("normal! 0")
                end, 500)
            end,
            desc = "Toggle Fyler (cwd)",
        },
        { "<leader>e", "<leader>fp", desc = "Toggle Fyler (root dir)", remap = true },
        { "<leader>E", "<leader>fP", desc = "Toggle Fyler (cwd)",      remap = true },
    },
}
