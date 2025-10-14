return {
    {
        "stevearc/oil.nvim",
        lazy = vim.fn.argc(-1) == 0, -- load oil early when opening a dir from the cmdline
        keys = {
            {
                "<leader>fo",
                function()
                    -- vim.cmd("vsplit")
                    vim.cmd("Oil --float " .. Abalone.root.get())
                end,
                desc = "Open oil (Root Dir)"
            },
            {
                "<leader>fO",
                function()
                    -- vim.cmd("vsplit")
                    vim.cmd("Oil --float " .. vim.fn.expand("%:h"))
                end,
                desc = "Open oil (Root Dir)"
            },
        },
        cmd = "Oil",
        opts = {
            default_file_explorer = true,
            columns = {
                -- "permissions",
                "size",
                -- "mtime",
                "icon",
            },
            lsp_file_methods = {
                -- Enable or disable LSP file operations
                enabled = true,
                -- Time to wait for LSP file operations to complete before skipping
                timeout_ms = 1000,
                -- Set to true to autosave buffers that are updated with LSP willRenameFiles
                -- Set to "unmodified" to only save unmodified buffers
                autosave_changes = true,
            },
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<CR>"] = "actions.select",
                ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = { "actions.close", mode = "n" },
                ["<C-l>"] = "actions.refresh",
                ["-"] = { "actions.parent", mode = "n" },
                ["_"] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["gx"] = "actions.open_external",
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
            },
            use_default_keymaps = true,
        }
    },
    {
        "benomahony/oil-git.nvim",
        enabled = false,
        dependencies = { "stevearc/oil.nvim" },
        cmd = "Oil",
    },
    {
        "JezerM/oil-lsp-diagnostics.nvim",
        dependencies = { "stevearc/oil.nvim" },
        cmd = "Oil",
        opts = {},
    },
    -- {
    --     "folke/edgy.nvim",
    --     optional = true,
    --     opts = function(_, opts)
    --         opts.right = opts.right or {}
    --         table.insert(opts.right, {
    --             title = "Oil",
    --             ft = "oil",
    --             size = { width = 0.3 },
    --         })
    --     end,
    -- }
}
