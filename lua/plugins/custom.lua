return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      vim.cmd([[command! Magit Neogit]])
      require("neogit").setup({})
    end,
    cmd = { "Neogit" },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
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
              "--std=c++2c",
              "--language=c++",
              "--check-level=exhaustive",
              "$FILENAME",
            },
          }),
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
      "hrsh7th/cmp-buffer",
      "nvimdev/lspsaga.nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      require("lspsaga").setup({})

      local kind_icons = {
        Array = "  ",
        Boolean = "󰨙  ",
        Class = "  ",
        Codeium = "󰘦  ",
        Color = "  ",
        Control = "  ",
        Collapsed = "  ",
        Constant = "󰏿  ",
        Constructor = "  ",
        Copilot = "  ",
        Enum = "  ",
        EnumMember = "  ",
        Event = "  ",
        Field = "  ",
        File = "  ",
        Folder = "  ",
        Function = "󰊕  ",
        Interface = "  ",
        Key = "  ",
        Method = "󰊕  ",
        Keyword = "  ",
        Module = "  ",
        Namespace = "󰦮  ",
        Null = "  ",
        Number = "󰎠  ",
        Object = "  ",
        Operator = "  ",
        Package = "  ",
        Property = "  ",
        Reference = "  ",
        Snippet = "  ",
        String = "  ",
        Struct = "󰆼  ",
        TabNine = "󰏚  ",
        Text = "  ",
        TypeParameter = "  ",
        Unit = "  ",
        Value = "  ",
        Variable = "󰀫  ",
      }
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")

      local formatting_style = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          local icons = kind_icons
          local icon = (true and icons[item.kind]) or ""
          item.menu = true and "(" .. item.kind .. ")" or ""
          item.kind = icon
          return item
        end,
      }
      local WIDE_HEIGHT = 50
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
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<cr>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-f>"] = {
            i = select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
          },
          ["<C-p>"] = {
            i = select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
          },
          ["<C-e>"] = {
            i = abort(),
          },
        },
        auto_brackets = {},
        completion = {
          completeopt = "menu,menuone,noinsert" .. (true and "" or ",noselect"),
        },
        preselect = true and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        formatting = formatting_style,
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "codeium" },
          { name = "lazydev" },
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
            max_height = math.floor(WIDE_HEIGHT * 2 * (WIDE_HEIGHT / vim.o.lines)),
            max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
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
                symbols = {
                  added = LazyVim.config.icons.git.added,
                  modified = LazyVim.config.icons.git.modified,
                  removed = LazyVim.config.icons.git.removed,
                },
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
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
      server = {
        on_attach = function(client, bufnr)
          require("navigator.lspclient.mapping").setup({ client = client, bufnr = bufnr })
          require("navigator.dochighlight").documentHighlight(bufnr)
          require("navigator.codeAction").code_action_prompt(bufnr)
        end,
      },
    },
  },
  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    opts = {},
    event = "LspAttach",
    config = function(_, opts)
      require("lsp_lines").setup(opts)
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
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
        hover = { enabled = false },
      },
    },
  },
  {
    "ray-x/navigator.lua",
    event = "LspAttach",
    dependencies = {
      {
        "ray-x/guihua.lua",
        event = "LspAttach",
        build = "cd lua/fzy && make",
        opts = {},
        config = function(_, opts)
          require("guihua.maps").setup()
        end,
      },
    },
    opts = {
      default_mapping = false,
      mason = false,
      icons = {
        diagnostic_err = "",
        diagnostic_warn = "",
        diagnostic_info = "",
        diagnostic_hint = "ﯦ",
        diagnostic_virtual_text = "",
      },
      lsp = {
        format_on_save = false,
        format_options = { async = true },
        disable_format_cap = { "sqlls", "lua_ls", "stylua" },
        disable_lsp = { "ccls" },
        diagnostic = {
          virtual_text = false,
          update_in_insert = true,
          float = {
            prefix = "󰃤",
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "-j=8",
            "--completion-style=detailed",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--enable-config",
            "--offset-encoding=utf-16",
            "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
          },
        },
        diagnostic_scrollbar_sign = false,
        diagnostic_virtual_text = false,
        diagnostic_update_in_insert = true,
        display_diagnostic_qf = false,
        servers = { "lua_ls", "clangd", "jsonls", "pyright" },
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    url = "https://mirror.ghproxy.com/github.com/xeluxee/competitest.nvim",
    cmd = "CompetiTest",
    opts = {},
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
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

            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
          { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
        },
        left = {
          { title = "Neotest Summary", ft = "neotest-summary" },
        },
        right = {
          { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
        },
        keys = {
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
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
            pinned = false,
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
        function()
          require("spider").motion("e")
        end,
        mode = { "n", "x" },
      },
      {
        "w",
        function()
          require("spider").motion("w")
        end,
        mode = { "n", "x" },
      },
      {
        "b",
        function()
          require("spider").motion("b")
        end,
        mode = { "n", "x" },
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
    ---@type YaziConfig
    opts = {
      open_for_directories = true,
    },
  },
  {
    url = "https://mirror.ghproxy.com/github.com/arnamak/stay-centered.nvim",
    keys = {
      {
        "<leader>uS",
        function()
          require("stay-centered").toggle()
        end,
        { desc = "Toggle stay-centered.nvim" },
      },
    },
  },
  { "mateuszwieloch/automkdir.nvim", event = "BufWrite" },

  {
    url = "https://mirror.ghproxy.com/github.com/sontungexpt/url-open",
    branch = "mini",
    cmd = "URLOpenUnderCursor",
    keys = {
      { "gx", "<cmd>URLOpenUnderCursor<cr>", { desc = "open url under cursor" } },
    },
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
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "norg", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    ft = { "markdown", "norg", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      LazyVim.toggle.map("<leader>um", {
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      })
    end,
  },
  {
    "Isrothy/neominimap.nvim",
    version = "v3.*.*",
    enabled = true,
    lazy = false,
    init = function()
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36
      ---@type Neominimap.UserConfig
      vim.g.neominimap = {
        auto_enable = true,
      }
    end,
    opts = { float = { minimap_width = 10 } },
  },
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
  },
  {
    "v1nh1shungry/cppman.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    opts = { position = "vsplit" },
  },
  {
    "mrjones2014/tldr.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      tldr_command = "tldr",
      tldr_args = "--color always",
    },
    config = function(_, opts)
      require("tldr").setup(opts)
      require("telescope").load_extension("tldr")
    end,
  },
  {
    "jvgrootveld/telescope-zoxide",
    keys = {
      {
        "<Space>Z",
        function()
          require("telescope").extensions.zoxide.list()
        end,
        mode = { "n" },
      },
    },
    config = function()
      local t = require("telescope")
      local z_utils = require("telescope._extensions.zoxide.utils")
      t.setup({
        extensions = {
          zoxide = {
            prompt_title = "[ Walking on the shoulders of TJ ]",
            mappings = {
              default = {
                after_action = function(selection)
                  print("Update to (" .. selection.z_score .. ") " .. selection.path)
                end,
              },
              ["<C-s>"] = {
                before_action = function(selection)
                  print("before C-s")
                end,
                action = function(selection)
                  vim.cmd.edit(selection.path)
                end,
              },
              ["<C-q>"] = { action = z_utils.create_basic_command("split") },
            },
          },
        },
      })
      t.load_extension("zoxide")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "ja-ford/delaytrain.nvim",
    opts = {
      delay_ms = 100000, -- How long repeated usage of a key should be prevented
      grace_period = 2, -- How many repeated keypresses are allowed
      keys = { -- Which keys (in which modes) should be delayed
        ["nv"] = { "h", "j", "k", "l" },
        ["nvi"] = { "<Left>", "<Down>", "<Up>", "<Right>" },
      },
      ignore_filetypes = {}, -- Example: set to {"help", "NvimTr*"} to
      -- disable the plugin for help and NvimTree
    },
    event = "VeryLazy",
  },
}
