return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      fish = { "fish" },
      cpp = { "cppcheck" },
      markdown = { "markdownlint-cli2" },
    },
    linters = {},
  },
}
