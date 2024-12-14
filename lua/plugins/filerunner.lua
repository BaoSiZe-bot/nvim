return {
  {
    "stevearc/overseer.nvim",
    optional = true,
    opts = {
      templates = {
        "builtin",
        "user.cpp_build",
        "user.file_runner",
        "user.python",
        "user.igcc",
        "user.trans_shell",
        "user.paru",
      },
      strategy = {
        "toggleterm",
        use_shell = false,
        direction = nil,
        highlights = nil,
        auto_scroll = nil,
        close_on_exit = false,
        quit_on_exit = "never",
        open_on_start = true,
        hidden = false,
        on_create = nil,
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    opts = {},
  },
  {
    "xeluxee/competitest.nvim",
    cmd = "CompetiTest",
    opts = {},
  },
}
