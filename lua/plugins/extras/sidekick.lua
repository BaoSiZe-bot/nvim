return {
    {
        "folke/sidekick.nvim",
        opts = {
            -- add any options here
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
            },
        },
        config = function(_, opts)
            require("sidekick").setup(opts)
            -- vim.lsp.inline_completion.enable()
        end,
        keys = {
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<leader>aa",
                function() require("sidekick.cli").toggle() end,
                mode = { "n", "v" },
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>af",
                function() require("sidekick.cli").select() end,
                -- Or to select only installed tools:
                -- require("sidekick.cli").select({ filter = { installed = true } })
                desc = "Sidekick Select CLI",
            },
            {
                "<leader>af",
                function() require("sidekick.cli").send({ selection = true }) end,
                mode = { "v" },
                desc = "Sidekick Send Visual Selection",
            },
            {
                "<leader>ap",
                function() require("sidekick.cli").prompt() end,
                mode = { "n", "v" },
                desc = "Sidekick Select Prompt",
            },
            {
                "<c-.>",
                function() require("sidekick.cli").focus() end,
                mode = { "n", "x", "i", "t" },
                desc = "Sidekick Switch Focus",
            },
            -- Example of a keybinding to open Claude directly
            -- {
            --     "<leader>ac",
            --     function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
            --     desc = "Sidekick Claude Toggle",
            --     mode = { "n", "v" },
            -- },
        },
    },
    {
        "saghen/blink.cmp",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                ["<Tab>"] = {
                    "snippet_forward",
                    function() -- sidekick next edit suggestion
                        return require("sidekick").nes_jump_or_apply()
                    end,
                    -- function() -- if you are using Neovim's native inline completions
                    --     return vim.lsp.inline_completion.get()
                    -- end,
                    "fallback",
                },
            },
        },
    }
}
