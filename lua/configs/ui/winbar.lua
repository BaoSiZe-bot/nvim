local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local Align = { provider = "%=" }
local Space = { provider = " " }

local dropbar = {
	provider = function()
		local bar = _G.dropbar
		if bar == nil then
			return ""
		else
			return bar()
		end
	end,
	hl = { fg = "gray" },
	update = "CursorMoved",
}

local FileType = {
	provider = function()
		return string.upper(vim.bo.filetype)
	end,
	hl = { fg = utils.get_highlight("Type").fg, bold = true },
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

local Sidekick = {
	provider = "󰚩  ",
	on_click = {
		callback = function()
			require("sidekick.cli").toggle()
		end,
		name = "heirline_open_sidekick",
	},
	hl = { fg = "blue" },
}

local RunCode = {
	provider = "󰑮  ",
	on_click = {
		callback = function()
			vim.cmd("OverseerRun build_and_run")
		end,
		name = "heirline_runcode",
	},
	hl = { fg = "blue" },
}

local Split = {
	provider = " ",
	on_click = {
		callback = function()
			vim.cmd("vsplit")
		end,
		name = "heirline_split_window",
	},
	hl = { fg = "blue" },
}

local function rpad(child)
	return {
		condition = child.condition,
		child,
		Space,
	}
end

local function OverseerTasksForStatus(status)
	return {
		condition = function(self)
			return self.tasks[status]
		end,
		provider = function(self)
			return string.format("%s%d", self.symbols[status], #self.tasks[status])
		end,
		hl = function(_)
			return {
				fg = utils.get_highlight(string.format("Overseer%s", status)).fg,
			}
		end,
	}
end

local Overseer = {
	condition = function()
		return package.loaded.overseer
	end,
	init = function(self)
		local tasks = require("overseer.task_list").list_tasks({ unique = true })
		local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
		self.tasks = tasks_by_status
	end,
	static = {
		symbols = {
			["CANCELED"] = " ",
			["FAILURE"] = "󰅚 ",
			["SUCCESS"] = "󰄴 ",
			["RUNNING"] = "󰑮 ",
		},
	},

	rpad(OverseerTasksForStatus("CANCELED")),
	rpad(OverseerTasksForStatus("RUNNING")),
	rpad(OverseerTasksForStatus("SUCCESS")),
	rpad(OverseerTasksForStatus("FAILURE")),
}
local FileNameBlock = {
	-- let's first set up some attributes needed by this component and its children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}
-- We can now define some children separately and add them later

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

local FileFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = "[+]",
		hl = { fg = "green" },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "",
		hl = { fg = "orange" },
	},
}
local FileNameModifer = {
	hl = function()
		if vim.bo.modified then
			-- use `force` because we need to override the child's hl foreground
			return { fg = "cyan", bold = true, force = true }
		end
	end,
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

-- let's add the children to our FileNameBlock component
local MyFileNameBlock = utils.insert(
	FileNameBlock,
	FileIcon,
	utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
	FileFlags,
	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

local DropBar = { flexible = 3, dropbar, MyFileNameBlock }

local WinBars = {
	fallthrough = false,
	{ -- A special winbar for terminals
		condition = function()
			return conditions.buffer_matches({ buftype = { "terminal", "snacks_terminal" } })
		end,

		FileType,
		Space,
		TerminalName,
		Space,
		Overseer,
	},
	{ -- An inactive winbar for regular files
		condition = function()
			return not conditions.is_active()
				and not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
				and vim.bo.buftype ~= "nofile"
		end,
		{
			hl = { fg = "gray", force = true },
			condition = function()
				return _G.dropbar == nil
			end,
			MyFileNameBlock,
			Space,
		},
		{
			condition = function()
				return not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
			end,
			DropBar,
		},
	},
	{
		condition = function()
			return not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
				and vim.bo.buftype ~= "nofile"
		end,
		-- A winbar for regular files
		{
			condition = function()
				return _G.dropbar == nil
			end,
			MyFileNameBlock,
			Space,
		},
		DropBar,
		Align,
		RunCode,
		Sidekick,
		Split,
	},
}

return WinBars
