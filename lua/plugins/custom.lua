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
        ["core.ui"] = {},
      },
    },
  },
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },
  {
    url = "https://mirror.ghproxy.com/github.com/folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {},
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  {
    url = "https://mirror.ghproxy.com/github.com/folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {},
    keys = { { "<leader>T", "<cmd>Twilight<cr>", desc = "Twilight Toggle" } },
  },
  {
    url = "https://mirror.ghproxy.com/github.com/mikavilpas/yazi.nvim",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>fy",
        function()
          require("yazi").yazi()
        end,
        desc = "Open the file manager",
      },
      {
        -- Open in the current working directory
        "<leader>fY",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<c-up>",
        function()
          -- NOTE: requires a version of yazi that includes
          -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
          require("yazi").toggle()
        end,
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true, -- enable these if you are using the latest version of yazi
      -- use_ya_for_events_reading = true,
      -- use_yazi_client_id_flag = true,
    },
  },
  {
    url = "https://mirror.ghproxy.com/github.com/arnamak/stay-centered.nvim",
    keys = {
      {
        "<leader>uS",
        "<cmd>lua require('stay-centered').toggle()<cr>",
        { desc = "Toggle stay-centered.nvim" },
      },
    },
  },
  { "mateuszwieloch/automkdir.nvim", event = "BufWrite" },
  {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    version = "*", -- use latest release
    config = function()
      require("cinnamon").setup({ -- Enable all provided keymaps
        keymaps = {
          basic = true,
          extra = true,
        },
        -- Only scroll the window
        options = { mode = "window" },
      })
    end,
  },
  -- { url = "https://mirror.ghproxy.com/github.com/notomo/gesture.nvim" },
  {
    url = "https://mirror.ghproxy.com/github.com/sontungexpt/url-open",
    branch = "mini",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({})
    end,
  },
}
