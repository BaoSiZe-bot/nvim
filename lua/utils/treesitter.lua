---@class abalone.utils.treesitter
local M = {}

M._installed = nil
M._queries = {}

function M.have_query(lang, query)
	local key = lang .. ":" .. query
	if M._queries[key] == nil then
		M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
	end
	return M._queries[key]
end

function M.have(what, query)
	what = what or vim.api.nvim_get_current_buf()
	what = type(what) == "number" and vim.bo[what].filetype or what --[[@as string]]
	local lang = vim.treesitter.language.get_lang(what)
	assert(what, "No name")
	assert(lang, "No language found for " .. what)
	if query and not M.have_query(lang, query) then
		return false
	end
	return true
end

return M
