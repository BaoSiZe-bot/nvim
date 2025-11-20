local utils = require("heirline.utils")

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

local TablineBufnr = {
	provider = function(self)
		return tostring(self.bufnr) .. ". "
	end,
	hl = "Comment",
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TablineFileName = {
	provider = function(self)
		-- self.filename will be defined later, just keep looking at the example!
		local filename = self.filename
		filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
		return filename
	end,
	hl = function(self)
		return { bold = self.is_active or self.is_visible, italic = true }
	end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
local TablineFileFlags = {
	{
		condition = function(self)
			return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
		end,
		provider = "[+]",
		hl = { fg = "green" },
	},
	{
		condition = function(self)
			return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
				or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
		end,
		provider = function(self)
			if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
				return "  "
			else
				return " "
			end
		end,
		hl = { fg = "orange" },
	},

	static = {
		error_icon = "  ",
		warn_icon = "  ",
		info_icon = "  ",
		hint_icon = "  ",
	},

	init = function(self)
		local bufnr = self.bufnr
		self.errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })
	end,

	update = { "DiagnosticChanged", "BufEnter" },

	{
		condition = function(self)
			return #vim.diagnostic.get(self.bufnr) > 0
		end,
		provider = function(self)
			-- 0 is just another output, we can decide to print it or not!
			return self.errors > 0 and (self.error_icon .. self.errors)
		end,
		hl = function(self)
			return self.is_active and { fg = "diag_error" } or { fg = "gray" }
		end,
	},
	{
		condition = function(self)
			return #vim.diagnostic.get(self.bufnr) > 0
		end,
		provider = function(self)
			return self.warnings > 0 and (self.warn_icon .. self.warnings)
		end,
		hl = function(self)
			return self.is_active and { fg = "diag_warn" } or { fg = "gray" }
		end,
		-- hl = { fg = "diag_warn" },
	},
	{
		condition = function(self)
			return #vim.diagnostic.get(self.bufnr) > 0
		end,
		provider = function(self)
			return self.info > 0 and (self.info_icon .. self.info)
		end,
		hl = function(self)
			return self.is_active and { fg = "diag_info" } or { fg = "gray" }
		end,
		-- hl = { fg = "diag_info" },
	},
	{
		condition = function(self)
			return #vim.diagnostic.get(self.bufnr) > 0
		end,
		provider = function(self)
			return self.hints > 0 and (self.hint_icon .. self.hints)
		end,
		hl = function(self)
			return self.is_active and { fg = "diag_hint" } or { fg = "gray" }
		end,
		-- hl = { fg = "diag_hint" },
	},
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
	end,
	update = { "BufFilePost", "BufEnter" },
	hl = function(self)
		if self.is_active then
			return "TabLineFill"
			-- why not?
		elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
			return { fg = "gray" }
		else
			return "TabLine"
		end
	end,
	on_click = {
		callback = function(_, minwid, _, button)
			if button == "m" then -- close on mouse middle click
				vim.schedule(function()
					vim.api.nvim_buf_delete(minwid, { force = false })
				end)
			else
				vim.api.nvim_win_set_buf(0, minwid)
			end
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_tabline_buffer_callback",
	},
	TablineBufnr,
	FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
	TablineFileName,
	TablineFileFlags,
}

local TablineSplitLine = {
	condition = function(self)
		return self.is_active
	end,
	{ provider = "▎" },
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
	condition = function(self)
		return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
	end,
	{ provider = " " },
	{
		provider = "",
		hl = { fg = "gray" },
		on_click = {
			callback = function(_, minwid)
				vim.schedule(function()
					vim.api.nvim_buf_delete(minwid, { force = false })
					vim.cmd.redrawtabline()
				end)
			end,
			minwid = function(self)
				return self.bufnr
			end,
			name = "heirline_tabline_close_buffer_callback",
		},
	},
	{ provider = " " },
}

-- The final touch!
local TablineBufferBlock = utils.surround({ "", "" }, function(self)
	if self.is_active then
		return utils.get_highlight("TabLineFill").bg
	else
		return utils.get_highlight("TabLine").bg
	end
end, { TablineSplitLine, TablineFileNameBlock, TablineCloseButton })

-- initialize the buflist cache

local buflist = Abalone.tabs.buflist_cache

-- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
-- vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufFilePost" }, {
-- 	callback = function()
-- 		vim.schedule(function()
-- 			local buffers = get_bufs()
-- 			for i, v in ipairs(buffers) do
-- 				buflist[i] = v
-- 			end
-- 			for i = #buffers + 1, #buflist do
-- 				buflist[i] = nil
-- 			end
--
-- 			-- check how many buffers we have and set showtabline accordingly
-- 			if #buflist > 1 then
-- 				vim.o.showtabline = 2 -- always
-- 			elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
-- 				vim.o.showtabline = 1 -- only when #tabpages > 1
-- 			end
-- 		end)
-- 	end,
-- })

local function update_showtabline()
	if #buflist > 1 then
		vim.o.showtabline = 2 -- always
	elseif vim.o.showtabline ~= 1 then
		vim.o.showtabline = 1
	end
end
-- [+] 跟踪*新*缓冲区，并将其添加到*末尾*
vim.api.nvim_create_autocmd({ "BufAdd" }, {
	callback = function(args)
		vim.schedule(function()
			local bufnr = args.buf
			-- 确保它是 buflisted 并且*不在*我们的列表中
			if vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
				if not vim.tbl_contains(buflist, bufnr) then
					table.insert(buflist, bufnr)
					update_showtabline()
					vim.cmd.redrawtabline()
				end
			end
		end)
	end,
})

-- [+] 跟踪*已删除*的缓冲区，并将其从列表中*移除*
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	callback = function(args)
		vim.schedule(function()
			local bufnr = args.buf
			local found_index = nil
			-- 查找并移除
			for i, v in ipairs(buflist) do
				if v == bufnr then
					found_index = i
					break
				end
			end

			if found_index then
				table.remove(buflist, found_index)
				update_showtabline()
				vim.cmd.redrawtabline()
			end
		end)
	end,
})

local BufferLine = utils.make_buflist(
	TablineBufferBlock,
	{ provider = " ", hl = { fg = "gray" } },
	{ provider = " ", hl = { fg = "gray" } },
	-- out buf_func simply returns the buflist_cache
	function()
		return buflist
	end,
	-- no cache, as we're handling everything ourselves
	false
)
vim.keymap.set("n", "gbp", function()
	local tabline = require("heirline").tabline
	local buflist = tabline._buflist[1]
	buflist._picker_labels = {}
	buflist._show_picker = true
	vim.cmd.redrawtabline()
	local char = vim.fn.getcharstr()
	local bufnr = buflist._picker_labels[char]
	if bufnr then
		vim.api.nvim_win_set_buf(0, bufnr)
	end
	buflist._show_picker = false
	vim.cmd.redrawtabline()
end)
local Tabpage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
	end,
	hl = function(self)
		if not self.is_active then
			return "TabLine"
		else
			return "TabLineFill"
		end
	end,
}

local TabpageClose = {
	provider = "%999X  %X",
	hl = "TabLine",
}

local TabPages = {
	-- only show this component if there's 2 or more tabpages
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{ provider = "%=" },
	utils.make_tablist(Tabpage),
	TabpageClose,
}
local TabLineOffset = {
	condition = function(self)
		local win = vim.api.nvim_tabpage_list_wins(0)[1]
		self.winid = win
	end,

	provider = function(self)
		local title = self.title
		local width = vim.api.nvim_win_get_width(self.winid)
		local pad = math.ceil((width - #title) / 2)
		return string.rep(" ", pad) .. title .. string.rep(" ", pad)
	end,

	hl = function(self)
		if vim.api.nvim_get_current_win() == self.winid then
			return "TablineFill"
		else
			return "Tabline"
		end
	end,
}
return { TabLineOffset, BufferLine, TabPages }
