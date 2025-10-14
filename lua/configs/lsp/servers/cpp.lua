local M = {}

M.setup = function()
    local clangd_flags = {
        keys = { {
            "<leader>ch",
            "<cmd>ClangdSwitchSourceHeader<cr>",
            desc = "Switch Source/Header (C/C++)",
            mode = "n"
        } },
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
        on_attach = Abalone.lsp._on_attach,
        capabilities = Abalone.lsp._capabilities,
    }
    vim.lsp.config("clangd", clangd_flags)
    clangd_flags = vim.lsp.config["clangd"]
    require("clangd_extensions").setup(Abalone.lazy.opts("clangd_extensions") or {})
    vim.lsp.enable("clangd")
end

return M
