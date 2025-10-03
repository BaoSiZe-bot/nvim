local M = {}

M.setup = function(on_attach, capabilities)
    local clangd_flags = {
        keys = { {
            "<leader>ch",
            "<cmd>ClangdSwitchSourceHeader<cr>",
            desc = "Switch Source/Header (C/C++)",
            mode = "n"
        } },
        on_attach = on_attach,
        capabilities = capabilities,
        root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac", -- AutoTools
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja",
            ".git",
        },
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
        },
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
        },
    }
    require("clangd_extensions").setup(vim.tbl_deep_extend("force", Lazy.opts("clangd_extensions.nvim") or {},
        { server = clangd_flags }))
    vim.lsp.config("clangd", clangd_flags)
    vim.lsp.enable("clangd")
end

return M
