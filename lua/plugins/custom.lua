return {
  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },
  {
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
  },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    config = function(_, opts)
      require("fzf-lua").setup({ "telescope" })
    end,
  },
  {
    "xeluxee/competitest.nvim",
    cmd = "CompetiTest",
    opts = {},
  },
  {
    "stevearc/overseer.nvim",
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
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
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
  },
  { "mateuszwieloch/automkdir.nvim", event = "BufWrite" },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
    },
  },
  { "dstein64/nvim-scrollview", event = "LazyFile", opts = {} },
  {
    "Isrothy/neominimap.nvim",
    event = "LazyFile",
  },
  {
    "SCJangra/table-nvim",
    ft = "markdown",
    opts = {},
  },
  "nvzone/volt",
  { "nvzone/timerly", cmd = "TimerlyToggle" },
  { "nvzone/typr", cmd = { "Typr", "TyprStats" } },
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<leader>ww", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
    },
    opts = {
      normal_hl = "Normal",
      render = "float",
    },
  },
}
