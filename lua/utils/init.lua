local LazyUtil = require("lazy.core.util")

---@class abalone: LazyUtilCore
---@field lsp abalone.utils.lsp
---@field lazy abalone.utils.lazy
---@field root abalone.utils.root
---@field treesitter abalone.utils.treesitter

local M = {
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
            Namespace     = "󰌗",
            Text          = "󰉿",
            Method        = "󰆧",
            Function      = "󰆧",
            Constructor   = "",
            Field         = "󰜢",
            Variable      = "󰀫",
            Class         = "󰠱",
            Interface     = "",
            Module        = "",
            Property      = "󰜢",
            Unit          = "󰑭",
            Value         = "󰎠",
            Enum          = "",
            Keyword       = "󰌋",
            Snippet       = "",
            Color         = "󱓻",
            File          = "󰈚",
            Reference     = "󰈇",
            Folder        = "󰉋",
            EnumMember    = "",
            Constant      = "󰏿",
            Struct        = "󰙅",
            Event         = "",
            Operator      = "󰆕",
            TypeParameter = "󰊄",
            Table         = "",
            Object        = "󰅩",
            Tag           = "",
            Array         = "[]",
            Boolean       = "",
            Number        = "",
            Null          = "󰟢",
            Supermaven    = "",
            String        = "󰉿",
            Calendar      = "",
            Watch         = "󰥔",
            Package       = "",
            Copilot       = "",
            Codeium       = "",
            TabNine       = "",
            BladeNav      = "",
            Control       = "",
            Collapsed     = "",
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

setmetatable(M, {
	__index = function(t, k)
		if LazyUtil[k] then
			return LazyUtil[k]
		end
		t[k] = require("utils." .. k)
		return t[k]
	end,
})

function M.is_win()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

return M
