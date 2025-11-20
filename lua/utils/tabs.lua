---@class abalone.utils.tabs

local M = {}

M.buflist_cache = {}

local buflist = M.buflist_cache

function M.get_buflist_and_index()
	local list = buflist
	local current = vim.api.nvim_get_current_buf()

	local idx = nil
	for i, b in ipairs(list) do
		if b == current then
			idx = i
			break
		end
	end
	return list, idx
end

function M.switch_buffer(dis)
	local list, idx = M.get_buflist_and_index()
	if not idx then
		return
	end

	local next = idx + dis
	if next > #list then
		next = 1
	end -- wrap
	if next < 1 then
		next = #list
	end -- wrap
	vim.api.nvim_win_set_buf(0, list[next])
end

function M.move_buffer(dis)
	-- 1. 获取当前缓冲区编号
	local bufnr = vim.api.nvim_get_current_buf()

	-- 2. [~] 在 buflist 中找到它的当前索引 (使用 vim.fn.index)
	--    vim.fn.index 返回 0-based 索引, -1 表示未找到
	local index_0based = vim.fn.index(buflist, bufnr)

	-- 2a. [~] 如果未找到 (返回 -1), 则什么也不做
	if index_0based == -1 then
		return
	end

	-- 2b. [~] 将 0-based 索引转换为 1-based 索引以操作 Lua table
	local index = index_0based + 1

	local new_index = index + dis

	if new_index < 1 or new_index > #buflist then
		-- 如果新索引超出边界，则什么也不做
		return
	end

	buflist[index], buflist[new_index] = buflist[new_index], buflist[index]

	vim.cmd.redrawtabline()
end

function M.sort(compare_func)
	if type(compare_func) == "string" then
		compare_func = require("utils.comparator")[compare_func]
	end
	if type(compare_func) == "function" then
		local bufs = buflist
		table.sort(bufs, compare_func)
		buflist = bufs
		vim.cmd.redrawtabline()
		return true
	end
	return false
end

return M
