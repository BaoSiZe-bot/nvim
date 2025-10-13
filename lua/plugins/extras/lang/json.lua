return {
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false,
    },
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function(_, opts)
            opts.lsps = vim.list_extend(opts.lsps, { "json" })
            return opts
        end
    }
}
