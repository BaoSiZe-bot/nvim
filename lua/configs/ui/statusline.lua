local Align = { provider = "%=" }
local Space = { provider = " " }
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local ViMode = {
	-- get vim current mode, this information will be required by the provider
	-- and the highlight functions, so we compute it only once per component
	-- evaluation and store it as a component attribute
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	-- Now we define some dictionaries to map the output of mode() to the
	-- corresponding string and color. We can put these into `static` to compute
	-- them at initialisation time.
	static = {
		mode_names = { -- change the strings if you like it vvvvverbose!
			n = "󰰓 ",
			no = "󰰔 ",
			nov = "󰰔 ",
			noV = "󰰔 ",
			["no\22"] = "󰰔 ",
			niI = "󰰅 ",
			niR = "󰰠 ",
			niV = "󰰪 ",
			nt = " ",
			v = "󰰫 ",
			vs = "󰰬 ",
			V = "󰬝 ",
			Vs = "󰰪 ",
			["\22"] = "󰬝 ",
			["\22s"] = "󰰪 ",
			s = "󰰣 ",
			S = "󰰡 ",
			["\19"] = "󰬚 ",
			i = "󰰄 ",
			ic = "Ic",
			ix = "Ix",
			R = "󰰟 ",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "󰯲 ",
			cv = "󰯱 ",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = " ",
		},
		mode_colors = {
			n = "blue",
			i = "green",
			v = "cyan",
			V = "cyan",
			["\22"] = "cyan",
			c = "orange",
			s = "purple",
			S = "purple",
			["\19"] = "purple",
			R = "orange",
			r = "orange",
			["!"] = "red",
			t = "red",
		},
	},
	-- We can now access the value of mode() that, by now, would have been
	-- computed by `init()` and use it to index our strings dictionary.
	-- note how `static` fields become just regular attributes once the
	-- component is instantiated.
	-- To be extra meticulous, we can also add some vim statusline syntax to
	-- control the padding and make sure our string is always at least 2
	-- characters long. Plus a nice Icon.
	provider = function(self)
		return self.mode_names[self.mode]
	end,
	-- Same goes for the highlight. Now the foreground will change according to the current mode.
	hl = function(self)
		local mode = self.mode:sub(1, 1) -- get only the first mode character
		return { fg = self.mode_colors[mode], bold = true }
	end,
}

local SearchCount = {
	condition = function()
		return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
	end,
	init = function(self)
		local ok, search = pcall(vim.fn.searchcount)
		if ok and search.total then
			self.search = search
		end
	end,
	provider = function(self)
		local search = self.search
		return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
	end,
	hl = { fg = "blue" },
}

local MacroRec = {
	condition = function()
		return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
	end,
	provider = " ",
	hl = { fg = "orange", bold = true },
	utils.surround({ "[", "]" }, nil, {
		provider = function()
			return vim.fn.reg_recording()
		end,
		hl = { fg = "green", bold = true },
	}),
	update = {
		"RecordingEnter",
		"RecordingLeave",
	},
}

local FileType = {
	provider = function()
		return string.upper(vim.bo.filetype)
	end,
	hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

local FileSize = {
	condition = function()
		return vim.fn.reg_recording() == "" or vim.o.cmdheight > 0
	end,
	provider = function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local buffer_content = table.concat(lines, "\n")
		return Abalone.shrink_format(vim.fn.strchars(buffer_content))
	end,
}

local Ruler = {
	provider = "%l:%c %P",
}
local LSPActive = {
	on_click = {
		callback = function()
			vim.defer_fn(function()
				vim.cmd("LspInfo")
			end, 100)
		end,
		name = "heirline_LSP",
	},
	condition = conditions.lsp_attached,
	update = { "LspAttach", "LspDetach", "BufEnter" },

	-- You can keep it simple,
	-- provider = " [LSP]",

	-- Or complicate things a bit and get the servers names
	provider = function()
		local names = {}
		for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
			local name = server.name
			local tmp = name
			-- tmp[1] = tmp[1] - 32
			if Abalone.icons.kinds[tmp] == nil then
				table.insert(names, name)
			else
				table.insert(names, Abalone.icons.kinds[tmp])
			end
		end
		return "  " .. table.concat(names, " ")
	end,
	hl = { fg = "green", bold = true },
}
-- Awesome plugin
-- local bit = require("bit")
-- Full nerd (with icon colors and clickable elements)!
-- works in multi window, but does not support flexible components (yet ...)
local Diagnostics = {
	on_click = {
		callback = function()
			if Abalone.lazy.has("trouble.nvim") then
				require("trouble").toggle({ mode = "diagnostics" })
			else
				vim.diagnostic.setqflist()
			end
			-- or
		end,
		name = "heirline_diagnostics",
	},
	condition = conditions.has_diagnostics,

	static = {
		error_icon = " ",
		warn_icon = " ",
		info_icon = " ",
		hint_icon = " ",
	},

	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,

	update = { "DiagnosticChanged", "BufEnter" },

	{
		provider = function(self)
			-- 0 is just another output, we can decide to print it or not!
			return self.errors > 0 and (self.error_icon .. self.errors .. " ")
		end,
		hl = { fg = "diag_error" },
	},
	{
		provider = function(self)
			return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
		end,
		hl = { fg = "diag_warn" },
	},
	{
		provider = function(self)
			return self.info > 0 and (self.info_icon .. self.info .. " ")
		end,
		hl = { fg = "diag_info" },
	},
	{
		provider = function(self)
			return self.hints > 0 and (self.hint_icon .. self.hints)
		end,
		hl = { fg = "diag_hint" },
	},
}
local Git = {
	on_click = {
		callback = function()
			-- If you want to use Fugitive:
			-- vim.cmd("G")
			require("neogit").open()
			-- If you prefer Lazygit
			-- use vim.defer_fn() if the callback requires
			-- opening of a floating window
			-- (this also applies to telescope)
			-- vim.defer_fn(function()
			--     vim.cmd("Lazygit")
			-- end, 100)
		end,
		name = "heirline_git",
	},
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	hl = { fg = "green" },

	{ -- git branch name
		provider = function(self)
			return " " .. self.status_dict.head
		end,
		hl = { bold = true },
	},
	-- You could handle delimiters, icons and counts similar to Diagnostics
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = "(",
	},
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and ("+" .. count)
		end,
		hl = { fg = "git_add" },
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and ("-" .. count)
		end,
		hl = { fg = "git_del" },
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and ("~" .. count)
		end,
		hl = { fg = "git_change" },
	},
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = ")",
	},
}
local CurrentFileIcon = {
	init = function(self)
		local filename = vim.fn.expand("%:t")
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and self.icon
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}
local WorkDir = {
	init = function(self)
		local cwd = vim.fn.expand("%:p:h")
		-- local cwd = Abalone.root.get()
		self.cwd = vim.fn.fnamemodify(cwd, ":~")
	end,
	hl = { bold = true },
	flexible = 1,
	-- {
	--     -- evaluates to the full-lenth path
	--     provider = function(self)
	--         local trail = self.cwd:sub(-1) == "/" and "" or "/"
	--         return self.icon .. self.cwd .. trail .. " "
	--     end,
	-- },
	{
		-- evaluates to the shortened path
		provider = function(self)
			local cwd = vim.fn.pathshorten(self.cwd)
			local trail = self.cwd:sub(-1) == "/" and "" or "/"
			return cwd .. trail .. vim.fn.expand("%:t")
		end,
	},
}
local TerminalName = {
	-- we could add a condition to check that buftype == 'terminal'
	-- or we could do that later (see #conditional-statuslines below)
	provider = function()
		local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
		return " " .. tname
	end,
	hl = { fg = "blue", bold = true },
}
local HelpFileName = {
	condition = function()
		return vim.bo.filetype == "help"
	end,
	provider = function()
		local filename = vim.api.nvim_buf_get_name(0)
		return vim.fn.fnamemodify(filename, ":t")
	end,
	hl = { fg = "blue" },
}

local FileName = {
	init = function(self)
		self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
		if self.lfilename == "" then
			self.lfilename = "[No Name]"
		end
	end,
	hl = { fg = utils.get_highlight("Directory").fg },

	flexible = 2,

	{
		provider = function(self)
			return self.lfilename
		end,
	},
	{
		provider = function(self)
			return vim.fn.pathshorten(self.lfilename)
		end,
	},
}

vim.opt.showcmdloc = "statusline"

local EdgyGroup = {
	provider = function()
		local stl = require("edgy-group.stl")
		local bottom_line = stl.get_statusline("bottom")
		return table.concat(bottom_line)
	end,
	-- update = { "BufEnter" },
}

local EdgyStatusLine = {
	condition = function()
		return Abalone.lazy.has("edgy-group.nvim")
			and (
				vim.bo.ft == "trouble"
				or vim.bo.ft == "snacks_terminal"
				or vim.bo.ft == "quickfix"
				or vim.bo.ft == "sidekick_terminal"
				or vim.bo.ft == "grug-far"
				or vim.bo.ft == "toggleterm"
				or vim.bo.ft == "noice"
				or vim.bo.ft == "help"
			)
	end,
	Align,
	EdgyGroup,
	Align,
}

local DefaultStatusline = {
	condition = function()
		return not (
			vim.bo.ft == "trouble"
			or vim.bo.ft == "edgy"
			or vim.bo.ft == "snacks_terminal"
			or vim.bo.ft == "yazi"
		)
	end,
	ViMode,
	Space,
	FileSize,
	MacroRec,
	Space,
	CurrentFileIcon,
	Space,
	WorkDir,
	Space,
	Ruler,
	Align,
	SearchCount,
	Align,
	LSPActive,
	Space,
	Space,
	FileType,
	Space,
	Space,
	Git,
	Space,
	Space,
	Diagnostics,
}
local InactiveStatusline = {
	condition = function()
		return not (
				vim.bo.ft == "trouble"
				or vim.bo.ft == "edgy"
				or vim.bo.ft == "snacks_terminal"
				or vim.bo.ft == "yazi"
			) and conditions.is_not_active()
	end,
	FileType,
	Space,
	FileName,
	Align,
}
local SpecialStatusline = {
	condition = function()
		return conditions.buffer_matches({
			buftype = { "nofile", "prompt", "help", "quickfix" },
			filetype = { "^git.*", "fugitive" },
		}) and not (vim.bo.ft == "trouble" or vim.bo.ft == "neotree" or vim.bo.ft == "yazi" or vim.bo.ft == "snacks_terminal" or vim.bo.ft == "edgy" or vim.bo.ft == "terminal")
	end,

	FileType,
	Space,
	HelpFileName,
	Align,
}
local TerminalStatusline = {
	condition = function()
		return conditions.buffer_matches({ buftype = { "terminal" } })
			and not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
	end,

	hl = function()
		if conditions.is_active() then
			return "StatusLine"
		else
			return "StatusLineNC"
		end
	end,

	-- Quickly add a condition to the ViMode to only show it when buffer is active!
	{ condition = conditions.is_active, ViMode, Space },
	FileType,
	Space,
	TerminalName,
	Align,
}

local StatusLines = {

	hl = function()
		if conditions.is_active() then
			return "StatusLine"
		else
			return "StatusLineNC"
		end
	end,

	-- the first statusline with no condition, or which condition returns true is used.
	-- think of it as a switch case with breaks to stop fallthrough.
	fallthrough = false,
	EdgyStatusLine,
	SpecialStatusline,
	TerminalStatusline,
	InactiveStatusline,
	DefaultStatusline,
	static = {
		mode_colors_map = {
			n = "blue",
			i = "green",
			v = "cyan",
			V = "cyan",
			["\22"] = "cyan",
			c = "orange",
			s = "purple",
			S = "purple",
			["\19"] = "purple",
			R = "orange",
			r = "orange",
			["!"] = "red",
			t = "green",
		},
		mode_color = function(self)
			local mode = conditions.is_active() and vim.fn.mode() or "n"
			return self.mode_colors_map[mode]
		end,
	},
}

return StatusLines
