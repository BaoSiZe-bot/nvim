return {
  {
    url = "https://mirror.ghproxy.com/github.com/stevearc/dressing.nvim",
    lazy = false,
    opts = {},
  },
  {
    url = "https://mirror.ghproxy.com/github.com/xeluxee/competitest.nvim",
    cmd = "CompetiTest",
    opts = {},
  },
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        require("null-ls.builtins.diagnostics.cppcheck").with({
          args = {
            "--enable=warning,performance,portability,unusedFunction",
            "--std=c++20",
            "--language=c++",
            "--check-level=exhaustive",
            "$FILENAME",
          },
        }),
      },
    },
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "user.cpp_build", "user.file_runner", "user.python" },
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
    version = "*",
    cmd = { "ToggleTerm" },
    opts = {},
  },
  {
    "folke/edgy.nvim",
    opts = function()
      local opts = {
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
          },
          {
            ft = "noice",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "lazyterm",
            title = "LazyTerm",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          "Trouble",
          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
          { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
        },
        left = {
          { title = "Neotest Summary", ft = "neotest-summary" },
          -- "neo-tree",
        },
        right = {
          { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
        },
        keys = {
          -- increase width
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<c-Down>"] = function(win)
            win:resize("height", -2)
          end,
        },
      }

      if LazyVim.has("neo-tree.nvim") then
        local pos = {
          filesystem = "left",
          buffers = "top",
          git_status = "right",
          document_symbols = "bottom",
          diagnostics = "bottom",
        }
        local sources = LazyVim.opts("neo-tree.nvim").sources or {}
        for i, v in ipairs(sources) do
          table.insert(opts.left, i, {
            title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == v
            end,
            pinned = true,
            open = function()
              vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root()))
            end,
          })
        end
      end

      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "trouble",
          filter = function(_buf, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.position == pos
              and vim.w[win].trouble.type == "split"
              and vim.w[win].trouble.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = { mason = false },
        marksman = { mason = false },
        lua_ls = { mason = false },
        ruff = { mason = false },
      },
    },
  },
  {
    "nvim-neorg/neorg",
    version = "*",
    ft = "norg",
    cmd = "Neorg",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "/mnt/d/baosize",
            },
          },
        },
        ["core.concealer"] = {},
      },
    },
  },
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
  },
  -- lazy.nvim spec
  {
    url = "https://gitee.com/sunn4room/codegeex.nvim",
    keys = {
      {
        "<F1>",
        function()
          if require("codegeex").visible() then
            require("codegeex").confirm()
          else
            require("codegeex").complete()
          end
        end,
        mode = "i",
      },
      {
        "<F2>",
        function()
          require("codegeex").cancel()
        end,
        mode = "i",
      },
    },
    opts = {
      timeout = 5000, -- request timeout
      highlight = "NonText", -- highlight group for suggestions
      ft2lang = { -- filetype to lang for codegeex request
        python = "Python",
        cpp = "Cpp",
      },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
}
