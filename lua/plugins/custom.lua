return {
  {
    "hiphish/rainbow-delimiters.nvim",
    lazy = false,
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
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
      -- 在 highlight 设置钩子中创建高亮组，以便每次颜色主题更改时重置它们
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
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
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    -- config = function()
    --   local highlight = {
    --     "RainbowRed",
    --     "RainbowYellow",
    --     "RainbowBlue",
    --     "RainbowOrange",
    --     "RainbowGreen",
    --     "RainbowViolet",
    --     "RainbowCyan",
    --   }
    --
    --   local hooks = require("ibl.hooks")
    --   -- 在 highlight 设置钩子中创建高亮组，以便每次颜色主题更改时重置它们
    --   hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    --   end)
    --
    --   require("ibl").setup() --{ indent = { highlight = highlight } }
    -- end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig", -- 提供LSP配置
      "hrsh7th/cmp-nvim-lsp", -- 提供LSP补全源
      "hrsh7th/cmp-buffer", -- 提供缓冲区补全源
      "hrsh7th/cmp-path", -- 提供路径补全源
      "hrsh7th/cmp-cmdline", -- 提供命令行补全源
      "nvimdev/lspsaga.nvim", -- 提供LSP UI增强
      "onsails/lspkind.nvim",
    },
    config = function()
      -- lspsaga 配置
      require("lspsaga").setup({})

      -- 补全项的图标
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

      -- 检查光标前是否有非空白字符
      local formatting_style = {
        -- default fields order i.e completion word + item.kind + item.kind icons
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          local icons = kind_icons
          local icon = (true and icons[item.kind]) or ""
          item.menu = true and "(" .. item.kind .. ")" or ""
          item.kind = icon
          return item
        end,
      }
      local WIDE_HEIGHT = 40
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
      cmp.setup({
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = true,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = true,
          disallow_prefix_unmatching = false,
          disallow_symbol_nonprefix_matching = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = LazyVim.cmp.confirm({ select = true }),
          ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),

        auto_brackets = {}, -- configure any filetype to auto add brackets
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
        }, {
          { name = "codeium" },
          -- { name = "cmdline" },
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
            max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
            max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
            border = border("CmpDocBorder"),
            winhighlight = "FloatBorder:NormalFloat",
            winblend = vim.o.pumblend,
          },
        },
        sorting = {
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

      -- 让 : 命令能使用 path cmdline 补全
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })

      -- 设置 Rime 输入法
      local function setup_rime()
        -- 全局状态
        vim.g.rime_enabled = false

        -- 更新 lualine 状态栏
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
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return LazyVim.ui.fg("Statement") end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return LazyVim.ui.fg("Constant") end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return LazyVim.ui.fg("Debug") end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return LazyVim.ui.fg("Special") end,
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

        -- 添加 rime-ls 作为自定义 LSP 服务器
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
          -- 设置切换 Rime 的快捷键
          vim.keymap.set("n", "<leader>ri", function()
            toggle_rime()
          end)
          vim.keymap.set("i", "<C-x>", function()
            toggle_rime()
          end)
          vim.keymap.set("n", "<leader>rs", function()
            vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
          end)
        end

        -- 广播 nvim-cmp 的额外补全能力给服务器
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
            schema_trigger_character = "&", -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
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
          require("navigator.lspclient.mapping").setup({ client = client, bufnr = bufnr }) -- setup navigator keymaps here,
          require("navigator.dochighlight").documentHighlight(bufnr)
          require("navigator.codeAction").code_action_prompt(bufnr)
          -- otherwise, you can define your own commands to call navigator functions
        end,
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      -- options
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
      debug = false, -- log output, set to true and log path: ~/.cache/nvim/gh.log
      default_mapping = false, -- set to false if you will remap every key
      -- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
      -- please check mapping.lua for all keymaps
      -- rule of overriding: if func and mode ('n' by default) is same
      -- the key will be overridden
      treesitter_analysis = true, -- treesitter variable context
      treesitter_navigation = true, -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
      --lang using TS navigation
      treesitter_analysis_max_num = 100, -- how many items to run treesitter analysis
      treesitter_analysis_condense = true, -- condense form for treesitter analysis
      -- this value prevent slow in large projects, e.g. found 100000 reference in a project
      transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it
      lsp_signature_help = true, -- if you would like to hook ray-x/lsp_signature plugin in navigator
      -- setup here. if it is nil, navigator will not init signature help
      signature_help_cfg = nil, -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
      mason = false, -- set to true if you would like use the lsp installed by williamboman/mason
      icons = {
        diagnostic_err = "",
        diagnostic_warn = "",
        diagnostic_info = "",
        diagnostic_hint = "ﯦ",
        diagnostic_virtual_text = "",
      },
      lsp = {
        enable = true, -- skip lsp setup, and only use treesitter in navigator.
        -- Use this if you are not using LSP servers, and only want to enable treesitter support.
        -- If you only want to prevent navigator from touching your LSP server configs,
        -- use `disable_lsp = "all"` instead.
        -- If disabled, make sure add require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client}) in your
        -- own on_attach
        code_action = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
        code_lens_action = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
        document_highlight = true, -- LSP reference highlight,
        -- it might already supported by you setup, e.g. LunarVim
        format_on_save = false, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
        -- table: {enable = {'lua', 'go'}, disable = {'javascript', 'typescript'}} to enable/disable specific language
        -- enable: a whitelist of language that will be formatted on save
        -- disable: a blacklist of language that will not be formatted on save
        -- function: function(bufnr) return true end to enable/disable lsp format on save
        format_options = { async = true }, -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
        disable_format_cap = { "sqlls", "lua_ls", "stylua" }, -- a list of lsp disable format capacity (e.g. if you using efm or vim-codeformat etc), empty {} by default
        -- If you using null-ls and want null-ls format your code
        -- you should disable all other lsp and allow only null-ls.
        disable_lsp = { "ccls" }, -- prevents navigator from setting up this list of servers.
        -- if you use your own LSP setup, and don't want navigator to setup
        -- any LSP server for you, use `disable_lsp = "all"`.
        -- you may need to add this to your own on_attach hook:
        -- require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client})
        -- for e.g. denols and tsserver you may want to enable one lsp server at a time.
        -- default value: {}
        diagnostic = {
          underline = true,
          virtual_text = false, -- show virtual for diagnostic message
          update_in_insert = true, -- update diagnostic message in insert mode
          float = { -- setup for floating windows style
            focusable = false,
            sytle = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "󰃤",
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "-j=4",
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
        diagnostic_scrollbar_sign = false, -- experimental:  diagnostic status in scroll bar area; set to false to disable the diagnostic sign,
        --                for other style, set to {'╍', 'ﮆ'} or {'-', '='}
        diagnostic_virtual_text = false, -- show virtual for diagnostic message
        diagnostic_update_in_insert = true, -- update diagnostic message in insert mode
        display_diagnostic_qf = false, -- always show quickfix if there are diagnostic errors, set to false if you want to ignore it
        -- set to 'trouble' to show diagnostcs in Trouble

        ctags = {
          cmd = "ctags",
          tagfile = "tags",
          options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number",
        },

        servers = { "lua_ls", "clangd", "jsonls" }, -- by default empty, and it should load all LSP clients available based on filetype
        -- but if you want navigator load  e.g. `cmake` and `ltex` for you , you
        -- can put them in the `servers` list and navigator will auto load them.
        -- you could still specify the custom config  like this
        -- cmake = {filetypes = {'cmake', 'makefile'}, single_file_support = false},
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    url = "https://mirror.ghproxy.com/github.com/xeluxee/competitest.nvim",
    cmd = "CompetiTest",
    opts = {},
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = true,
    event = "LspAttach",
    opts = {
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
    },
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
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPre",
    config = function()
      require("statuscol").setup({})
    end,
  },
  { "dstein64/nvim-scrollview", event = "BufReadPre", opts = {} },
  { "MeanderingProgrammer/markdown.nvim", enabled = false },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
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
    ft = { "markdown", "norg", "rmd", "org" },
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
    lazy = false, -- NOTE: NO NEED to Lazy load
    -- Optional
    init = function()
      -- The following options are recommended when layout == "float"
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value

      --- Put your configuration here
      ---@type Neominimap.UserConfig
      vim.g.neominimap = {
        auto_enable = true,
      }
    end,
    opts = { float = { minimap_width = 10 }, click = { enabled = true } },
  },
  {
    "roobert/activate.nvim", -- need telescope, but i'm not like telescope at all!(if it can using fzf-lua, then i will uncomment it.)
    keys = {
      {
        "<leader>P",
        "<CMD>lua require('activate').list_plugins()<CR>",
        desc = "Plugins",
      },
    },
  },
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
  },
  -- {
  --   "drop-stones/im-switch.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   event = "VeryLazy",
  --   opts = {
  --     -- your configurations
  --   },
  -- },
  {
    "numToStr/Navigator.nvim",
    opts = {},
  },
  {
    "v1nh1shungry/cppman.nvim",
    dependencies = "nvim-telescope/telescope.nvim", -- optional, if absent `vim.ui.select()` will be used
    opts = { position = "vsplit" },
  },
  {
    "mrjones2014/tldr.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      -- the shell command to use
      tldr_command = "tldr",
      -- a string of extra arguments to pass to `tldr`, e.g. tldr_args = '--color always'
      tldr_args = "--color always",
    },
    config = function(_, opts)
      require("tldr").setup(opts)
      require("telescope").load_extension("tldr")
    end,
  },
  { "nvimdev/lspsaga.nvim", event = "LspAttach", opts = {} },
  -- { "Bekaboo/dropbar.nvim", opts = {}, lazy = false },
}
