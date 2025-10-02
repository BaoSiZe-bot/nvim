local M = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = function()
    require("tokyonight").load()
  end,
  -- load the default settings
  defaults = {
    autocmds = true, -- lazyvim.config.autocmds
    keymaps = true, -- lazyvim.config.keymaps
    -- lazyvim.config.options can't be configured here since that's loaded before lazyvim setup
    -- if you want to disable loading options, add `package.loaded["lazyvim.config.options"] = true` to the top of your init.lua
  },
  news = {
    -- When enabled, NEWS.md will be shown when changed.
    -- This only contains big new features and breaking changes.
    lazyvim = true,
    -- Same but for Neovim's news.txt
    neovim = false,
  },
  -- icons used by other plugins
  -- stylua: ignore
  icons = {
    misc = {
      dots = "󰇘",
    },
    ft = {
      octo = "",
    },
    dap = {
      Stopped             = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = "",
      BreakpointCondition = "",
      BreakpointRejected  = { "", "DiagnosticError" },
      LogPoint            = ".>",
    },
    diagnostics = {
      Error = "",
      Warn  = "",
      Hint  = "",
      Info  = "",
    },
    git = {
      added    = "",
      modified = "",
      removed  = "",
    },
    kinds = {
      Array         = "",
      Boolean       = "󰨙",
      Class         = "",
      Codeium       = "󰘦",
      Color         = "",
      Control       = "",
      Collapsed     = "",
      Constant      = "󰏿",
      Constructor   = "",
      Copilot       = "",
      Enum          = "",
      EnumMember    = "",
      Event         = "",
      Field         = "",
      File          = "",
      Folder        = "",
      Function      = "󰊕",
      Interface     = "",
      Key           = "",
      Keyword       = "",
      Method        = "󰊕",
      Module        = "",
      Namespace     = "󰦮",
      Null          = "",
      Number        = "󰎠",
      Object        = "",
      Operator      = "",
      Package       = "",
      Property      = "",
      Reference     = "",
      Snippet       = "󱄽",
      String        = "",
      Struct        = "󰆼",
      Supermaven    = "",
      TabNine       = "󰏚",
      Text          = "",
      TypeParameter = "",
      Unit          = "",
      Value         = "",
      Variable      = "󰀫",
    },
  },
  ---@type table<string, string[]|boolean>?
  kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  },
}
return M
