vim.cmd.colorscheme("catppuccin-frappe")

local hex2rgb = function(hex)
	local hash = string.sub(hex, 1, 1) == "#"
	if string.len(hex) ~= (7 - (hash and 0 or 1)) then
		return nil
	end

	local r = tonumber(hex:sub(2 - (hash and 0 or 1), 3 - (hash and 0 or 1)), 16)
	local g = tonumber(hex:sub(4 - (hash and 0 or 1), 5 - (hash and 0 or 1)), 16)
	local b = tonumber(hex:sub(6 - (hash and 0 or 1), 7 - (hash and 0 or 1)), 16)
	return r, g, b
end
local rgb2hex = function(r, g, b)
	return string.format("#%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
end

local mix = function(first, second, strength)
	if strength == nil then
		strength = 0.5
	end

	local s = strength / 100
	local r1, g1, b1 = hex2rgb(first)
	local r2, g2, b2 = hex2rgb(second)

	if r1 == nil or r2 == nil then
		return first
	end

	if s == 0 then
		return first
	elseif s == 1 then
		return second
	end

	local r3 = r1 * (1 - s) + r2 * s
	local g3 = g1 * (1 - s) + g2 * s
	local b3 = b1 * (1 - s) + b2 * s

	return rgb2hex(r3, g3, b3)
end
local mixcolors = mix

local highlights = {
	BlinkCmpScrollBarThumb = { bg = "#414559" },
	BlinkCmpScrollBarGutter = { bg = "#292c3c" },
	BlinkCmpLabel = { fg = "#D9E0EE" },
	BlinkCmpLabelDeprecated = { fg = "#e78284", strikethrough = true },
	BlinkCmpLabelMatch = { fg = "#89B4FA", bold = true },
	BlinkCmpLabelDetail = { fg = "#737994" },
	BlinkCmpLabelDescription = { fg = "#737994" },
	BlinkCmpSource = { fg = "#51576d" },
	BlinkCmpGhostText = { fg = "#51576d" },
	BlinkCmpDoc = { bg = "#303446" },
	BlinkCmpDocBorder = { fg = "#51576d" },
	BlinkCmpDocSeparator = { fg = "#414559" },
	BlinkCmpDocCursorLine = { bg = "#2d2c3c" },
	BlinkCmpSignatureHelp = { bg = "#303446" },
	BlinkCmpSignatureHelpBorder = { fg = "#51576d" },
	BlinkCmpSignatureHelpActiveParameter = { fg = "#89B4FA", bold = true },
}

local kinds = {
	Constant = "#ef9f76",
	Function = "#8caaee",
	Identifier = "#e78284",
	Field = "#e78284",
	Variable = "#ca9ee6",
	Snippet = "#e78284",
	Text = "#a6d189",
	Structure = "#ca9ee6",
	Type = "#e5c890",
	Keyword = "#D9E0EE",
	Method = "#8caaee",
	Constructor = "#89B4FA",
	Folder = "#D9E0EE",
	Module = "#e5c890",
	Property = "#e78284",
	Enum = "#89B4FA",
	Unit = "#ca9ee6",
	Class = "#B5E8E0",
	File = "#D9E0EE",
	Interface = "#ABE9B3",
	Color = "#D9E0EE",
	Reference = "#bfc6d4",
	EnumMember = "#d0a9e5",
	Struct = "#ca9ee6",
	Value = "#89DCEB",
	Event = "#FAE3B0",
	Operator = "#bfc6d4",
	TypeParameter = "#e78284",
	Copilot = "#ABE9B3",
	Codeium = "#b6f4be",
	TabNine = "#ffa5c3",
	SuperMaven = "#FAE3B0",
}
for kind, color in pairs(kinds) do
	highlights["BlinkCmpKind" .. kind] = { fg = color }
end
for kind, _ in pairs(kinds) do
	local hl_name = "BlinkCmpKind" .. kind
	local fg = highlights[hl_name] and highlights[hl_name].fg or "#d9e0f9"
	highlights[hl_name] = {
		fg = fg,
		bg = mixcolors(fg, "#303446", 70),
	}
end

highlights = vim.tbl_deep_extend("force", highlights, {
	BlinkCmpDoc = { bg = "#232634" },
	BlinkCmpDocBorder = { fg = "#232634", bg = "#232634" },
})

for group, opts in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, opts)
end

C = require("catppuccin.palettes").get_palette(require("catppuccin").flavour)
local hl = require("catppuccin.groups.integrations.buffon").get()
hl["Comment"] = { fg = "#737994", italic = true }

for group, opt in pairs(hl) do
	vim.api.nvim_set_hl(0, group, opt)
end
