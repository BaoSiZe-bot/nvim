return {
  url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  event = "LspAttach",
  ft = { "cpp", "python", "markdown", "lua", "c" },
  config = function()
    require("lsp_lines").setup()
    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}
