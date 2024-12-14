return {
  "mikavilpas/yazi.nvim",
  keys = {
    {
      "<leader>fy",
      function()
        require("yazi").yazi()
      end,
      desc = "Open the file manager",
    },
    {

      "<leader>fY",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-up>",
      function()
        require("yazi").toggle()
      end,
      desc = "Resume the last yazi session",
    },
  },
  opts = {
    open_for_directories = true,
  },
}
