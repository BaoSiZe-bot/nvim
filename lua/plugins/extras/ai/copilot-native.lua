return {
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function(_, opts)
            opts.lsps = vim.list_extend(opts.lsps, { "copilot" })
            return opts
        end
    }
}
