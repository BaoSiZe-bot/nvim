return {
  {
    "ibhagwan/fzf-lua",
    optional = true,
    config = function(_, opts)
      require("fzf-lua").setup({ "telescope" })
    end,
  },
}
