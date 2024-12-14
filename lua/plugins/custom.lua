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
    "winston0410/range-highlight.nvim",
    dependencies = "winston0410/cmd-parser.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- {
  --   "yioneko/nvim-cmp",
  --   priority = 10000,
  --   branch = "perf",
  --   event = "InsertEnter",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-cmdline",
  --   },
  --   config = function()
  --     local kind_icons = {
  --       Array = "",
  --       Boolean = "󰨙",
  --       Class = "",
  --       Codeium = "󰘦",
  --       Color = "",
  --       Control = "",
  --       Collapsed = "",
  --       Constant = "󰏿",
  --       Constructor = "",
  --       Copilot = "",
  --       Enum = "",
  --       EnumMember = "",
  --       Event = "",
  --       Field = "",
  --       File = "",
  --       Folder = "",
  --       Function = "󰊕",
  --       Interface = "",
  --       Key = "",
  --       Method = "󰊕",
  --       Keyword = "",
  --       Module = "",
  --       Namespace = "󰦮",
  --       Null = "",
  --       Number = "󰎠",
  --       Object = "",
  --       Operator = "",
  --       Package = "",
  --       Property = "",
  --       Reference = "",
  --       Snippet = "",
  --       String = "",
  --       Struct = "󰆼",
  --       TabNine = "󰏚",
  --       Text = "",
  --       TypeParameter = "",
  --       Unit = "",
  --       Value = "",
  --       Variable = "󰀫",
  --     }
  --     local cmp = require("cmp")
  --     local compare = require("cmp.config.compare")
  --     local formatting_style = {
  --       fields = { "kind", "abbr", "menu" },
  --       format = function(_, item)
  --         item.kind = kind_icons[item.kind]
  --         return item
  --       end,
  --     }
  --     local WIDE_HEIGHT = 20
  --     local function border(hl_name)
  --       return {
  --         { "╭", hl_name },
  --         { "─", hl_name },
  --         { "╮", hl_name },
  --         { "│", hl_name },
  --         { "╯", hl_name },
  --         { "─", hl_name },
  --         { "╰", hl_name },
  --         { "│", hl_name },
  --       }
  --     end
  --     local select_next_item = function(option)
  --       return function(fallback)
  --         if not require("cmp").select_next_item(option) then
  --           local release = require("cmp").core:suspend()
  --           fallback()
  --           vim.schedule(release)
  --         end
  --       end
  --     end
  --     local select_prev_item = function(option)
  --       return function(fallback)
  --         if not require("cmp").select_prev_item(option) then
  --           local release = require("cmp").core:suspend()
  --           fallback()
  --           vim.schedule(release)
  --         end
  --       end
  --     end
  --     local abort = function()
  --       return function(fallback)
  --         if not require("cmp").abort() then
  --           fallback()
  --         end
  --       end
  --     end
  --     local types = require("cmp.types")
  --     cmp.setup({
  --       matching = {
  --         disallow_fuzzy_matching = true,
  --         disallow_fullfuzzy_matching = false,
  --         disallow_partial_fuzzy_matching = false,
  --         disallow_partial_matching = false,
  --         disallow_prefix_unmatching = false,
  --         disallow_symbol_nonprefix_matching = false,
  --       },
  --       performance = {
  --         debounce = 0,
  --         throttle = 0,
  --         fetching_timeout = 0,
  --         confirm_resolve_timeout = 0,
  --         async_budget = 1,
  --         max_view_entries = 500,
  --       },
  --       mapping = {
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<cr>"] = LazyVim.cmp.confirm({ select = true }),
  --         ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
  --         ["<C-f>"] = {
  --           i = select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
  --         },
  --         ["<C-b>"] = {
  --           i = select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
  --         },
  --         ["<C-e>"] = {
  --           i = abort(),
  --         },
  --       },
  --       auto_brackets = {},
  --       completion = {
  --         completeopt = "menu,menuone,noinsert",
  --       },
  --       preselect = cmp.PreselectMode.Item,
  --       experimental = {
  --         ghost_text = {
  --           hl_group = "CmpGhostText",
  --         },
  --       },
  --       formatting = formatting_style,
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "path" },
  --         { name = "snippets" },
  --         { name = "git" },
  --       }),
  --       window = {
  --         completion = {
  --           side_padding = 1,
  --           winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
  --           winblend = vim.o.pumblend,
  --           scrolloff = 0,
  --           col_offset = 0,
  --           border = border("CmpBorder"),
  --           scrollbar = true,
  --         },
  --         documentation = {
  --           max_height = math.floor((WIDE_HEIGHT * 2) * (WIDE_HEIGHT / vim.o.lines)),
  --           max_width = math.floor(WIDE_HEIGHT * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 8))),
  --           border = border("CmpDocBorder"),
  --           winhighlight = "FloatBorder:NormalFloat",
  --           winblend = vim.o.pumblend,
  --         },
  --       },
  --       sorting = {
  --         priority_weight = 2,
  --         comparators = {
  --           compare.sort_text,
  --           compare.offset,
  --           compare.exact,
  --           compare.scopes,
  --           compare.score,
  --           compare.recently_used,
  --           compare.locality,
  --           compare.kind,
  --           compare.length,
  --           compare.order,
  --         },
  --       },
  --     })
  --     cmp.setup.filetype("gitcommit", {
  --       sources = cmp.config.sources({
  --         { name = "cmp_git" },
  --         { name = "buffer" },
  --       }),
  --     })
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer" },
  --       },
  --     })
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --         { name = "cmdline" },
  --       }),
  --     })
  --   end,
  -- },
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
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        fish = { "fish" },
        cpp = { "cppcheck" },
        markdown = { "markdownlint-cli2" },
      },
      ---@type table<string,table>
      linters = {},
    },
    config = function(_, opts)
      local M = {}
      local lint = require("lint")
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        names = vim.list_extend({}, names)
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
          end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)
        if #names > 0 then
          lint.try_lint(names)
        end
      end
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
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
