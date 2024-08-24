return {
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
    lazy = false,
    dependencies = {
      {
        "ray-x/guihua.lua",
        lazy = false,
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
    event = "VeryLazy",
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
    event = "VeryLazy",
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
  -- { "Bekaboo/dropbar.nvim", opts = {}, lazy = false },
}
