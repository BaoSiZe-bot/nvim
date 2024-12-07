return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
      vim.cmd([[command! Magit Neogit]])
      require("neogit").setup({})
    end,
    cmd = { "Neogit" },
  },
  {
    url = "https://gitee.com/BesterBigWei/rainbow-delimiters.nvim",
    event = "LazyFile",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
        },
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      return {
        indent = {
          char = "│",
          tab_char = "│",
          highlight = highlight,
        },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    dependencies = { "mason.nvim" },
    init = function()
      LazyVim.on_very_lazy(function()
        LazyVim.format.register({
          name = "none-ls.nvim",
          priority = 200,
          primary = true,
          format = function(buf)
            return LazyVim.lsp.format({
              bufnr = buf,
              filter = function(client)
                return client.name == "null-ls"
              end,
            })
          end,
          sources = function(buf)
            local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING") or {}
            return vim.tbl_map(function(source)
              return source.name
            end, ret)
          end,
        })
      end)
    end,
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls.builtins.diagnostics.cppcheck").with({
            args = {
              "--enable=warning,performance,portability,unusedFunction",
              "--check-level=exhaustive",
              "--template=gcc",
              "$FILENAME",
            },
          }),
          require("null-ls.builtins.formatting.clang_format"),
        },
      })
    end,
  },
  {
    "winston0410/range-highlight.nvim",
    dependencies = "winston0410/cmd-parser.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "yioneko/nvim-cmp",
    priority = 10000,
    branch = "perf",
    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local kind_icons = {
        Array = "",
        Boolean = "󰨙",
        Class = "",
        Codeium = "󰘦",
        Color = "",
        Control = "",
        Collapsed = "",
        Constant = "󰏿",
        Constructor = "",
        Copilot = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "",
        Function = "󰊕",
        Interface = "",
        Key = "",
        Method = "󰊕",
        Keyword = "",
        Module = "",
        Namespace = "󰦮",
        Null = "",
        Number = "󰎠",
        Object = "",
        Operator = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        Struct = "󰆼",
        TabNine = "󰏚",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "󰀫",
      }
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local formatting_style = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          item.kind = kind_icons[item.kind]
          return item
        end,
      }
      local WIDE_HEIGHT = 20
      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end
      local select_next_item = function(option)
        return function(fallback)
          if not require("cmp").select_next_item(option) then
            local release = require("cmp").core:suspend()
            fallback()
            vim.schedule(release)
          end
        end
      end
      local select_prev_item = function(option)
        return function(fallback)
          if not require("cmp").select_prev_item(option) then
            local release = require("cmp").core:suspend()
            fallback()
            vim.schedule(release)
          end
        end
      end
      local abort = function()
        return function(fallback)
          if not require("cmp").abort() then
            fallback()
          end
        end
      end
      local types = require("cmp.types")
      cmp.setup({
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = false,
          disallow_partial_fuzzy_matching = false,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
          disallow_symbol_nonprefix_matching = false,
        },
        performance = {
          debounce = 0,
          throttle = 0,
          fetching_timeout = 0,
          confirm_resolve_timeout = 0,
          async_budget = 1,
          max_view_entries = 500,
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<cr>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-f>"] = {
            i = select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
          },
          ["<C-b>"] = {
            i = select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
          },
          ["<C-e>"] = {
            i = abort(),
          },
        },
        auto_brackets = {},
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        preselect = cmp.PreselectMode.Item,
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        formatting = formatting_style,
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "snippets" },
          { name = "git" },
        }),
        window = {
          completion = {
            side_padding = 1,
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            winblend = vim.o.pumblend,
            scrolloff = 0,
            col_offset = 0,
            border = border("CmpBorder"),
            scrollbar = true,
          },
          documentation = {
            max_height = math.floor((WIDE_HEIGHT * 2) * (WIDE_HEIGHT / vim.o.lines)),
            max_width = math.floor(WIDE_HEIGHT * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 8))),
            border = border("CmpDocBorder"),
            winhighlight = "FloatBorder:NormalFloat",
            winblend = vim.o.pumblend,
          },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.sort_text,
            compare.offset,
            compare.exact,
            compare.scopes,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.length,
            compare.order,
          },
        },
      })
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
          { name = "buffer" },
        }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
      local function setup_rime()
        vim.g.rime_enabled = false
        local function rime_status()
          if vim.g.rime_enabled then
            return "ㄓ"
          else
            return ""
          end
        end
        require("lualine").setup({
          sections = {
            lualine_x = {
              rime_status,
              {
                function()
                  return require("noice").api.status.command.get()
                end,
                cond = function()
                  return package.loaded["noice"] and require("noice").api.status.command.has()
                end,
                color = function()
                  return LazyVim.ui.fg("Statement")
                end,
              },
              {
                function()
                  return require("noice").api.status.mode.get()
                end,
                cond = function()
                  return package.loaded["noice"] and require("noice").api.status.mode.has()
                end,
                color = function()
                  return LazyVim.ui.fg("Constant")
                end,
              },
              {
                function()
                  return "  " .. require("dap").status()
                end,
                cond = function()
                  return package.loaded["dap"] and require("dap").status() ~= ""
                end,
                color = function()
                  return LazyVim.ui.fg("Debug")
                end,
              },
              {
                require("lazy.status").updates,
                cond = require("lazy.status").has_updates,
                color = function()
                  return LazyVim.ui.fg("Special")
                end,
              },
              {
                "diff",
                source = function()
                  local gitsigns = vim.b.gitsigns_status_dict
                  if gitsigns then
                    return {
                      added = gitsigns.added,
                      modified = gitsigns.changed,
                      removed = gitsigns.removed,
                    }
                  end
                end,
              },
            },
          },
        })
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")
        if not configs.rime_ls then
          configs.rime_ls = {
            default_config = {
              name = "rime_ls",
              cmd = { "rime_ls" },
              filetypes = { "*" },
              single_file_support = true,
            },
            settings = {},
            docs = {
              description = [[
            https://www.github.com/wlh320/rime-ls
            A language server for librime
            ]],
            },
          }
        end
        local rime_on_attach = function(client, _)
          local toggle_rime = function()
            client.request("workspace/executeCommand", { command = "rime-ls.toggle-rime" }, function(_, result, ctx, _)
              if ctx.client_id == client.id then
                vim.g.rime_enabled = result
              end
            end)
          end
          vim.keymap.set("n", "<leader>ri", function()
            toggle_rime()
          end, { desc = "toggle rime" })
          vim.keymap.set("i", "<C-x>", function()
            toggle_rime()
          end, { desc = "toggle rime" })
          vim.keymap.set("n", "<leader>rs", function()
            vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
          end, { desc = "sync user data." })
        end
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        lspconfig.rime_ls.setup({
          init_options = {
            enabled = vim.g.rime_enabled,
            shared_data_dir = "/usr/share/rime-data",
            user_data_dir = "~/.local/share/rime-ls",
            log_dir = "~/.local/share/rime-ls",
            max_candidates = 9,
            trigger_characters = {},
            schema_trigger_character = "&",
          },
          on_attach = rime_on_attach,
          capabilities = capabilities,
        })
      end
      setup_rime()
    end,
  },
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
    "soulis-1256/eagle.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    config = function(_, opts)
      require("fzf-lua").setup({ "telescope" })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    url = "https://ghp.ci/github.com/xeluxee/competitest.nvim",
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
    version = "*",
    cmd = { "ToggleTerm" },
    opts = {},
  },
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
    url = "https://ghp.ci/github.com/mikavilpas/yazi.nvim",
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
    url = "https://ghp.ci/github.com/sontungexpt/url-open",
    branch = "mini",
    event = "VeryLazy",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({})
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "LazyFile",
    config = function()
      require("statuscol").setup({})
    end,
  },
  { "dstein64/nvim-scrollview", event = "LazyFile", opts = {} },
  { "MeanderingProgrammer/markdown.nvim", enabled = false },
  {
    "Isrothy/neominimap.nvim",
    version = "v3.*.*",
    lazy = false,
  },
  {
    "SCJangra/table-nvim",
    ft = "markdown",
    opts = {},
  },
  "nvzone/volt",
  "nvzone/menu",
  { "nvzone/minty", cmd = { "Shades", "Huefy" } },
  { "nvzone/timerly", cmd = "TimerlyToggle" },
  { "nvzone/showkeys", cmd = "ShowkeysToggle", opts = { timeout = 1, maxkeys = 5 } },
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
  {
    "declancm/cinnamon.nvim",
    version = "*", -- use latest release
    event = "VeryLazy",
    opts = {
      keymaps = {
        basic = true,
        extra = true,
      },
      delay = 1,
    },
  },
}
