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

local colors = {
    white = "#D9E0EE",
    darker_black = "#232634",
    black = "#303447", --  nvim bg
    black2 = "#292c3c",
    one_bg = "#2d2c3c", -- real bg of onedark
    one_bg2 = "#363545",
    one_bg3 = "#3e3d4d",
    grey = "#414559",
    grey_fg = "#51576d",
    grey_fg2 = "#626880",
    light_grey = "#737994",
    red = "#e78284",
    baby_pink = "#ffa5c3",
    pink = "#f4b8e4",
    line = "#414559", -- for lines like vertsplit
    green = "#ABE9B3",
    vibrant_green = "#b6f4be",
    nord_blue = "#8bc2f0",
    blue = "#89B4FA",
    yellow = "#FAE3B0",
    sun = "#ffe9b6",
    purple = "#d0a9e5",
    dark_purple = "#c7a0dc",
    teal = "#B5E8E0",
    orange = "#F8BD96",
    cyan = "#89DCEB",
    statusline_bg = "#232232",
    lightbg = "#2f2e3e",
    pmenu_bg = "#ca9ee6",
    folder_bg = "#89B4FA",
    lavender = "#c7d1ff",
}

local theme = {
    base00 = "#232634",
    base01 = "#292c3c",
    base02 = "#303447",
    base03 = "#414559",
    base04 = "#51576d",
    base05 = "#bfc6d4",
    base06 = "#ccd3e1",
    base07 = "#D9E0EE",
    base08 = "#e78284",
    base09 = "#ef9f76",
    base0A = "#e5c890",
    base0B = "#a6d189",
    base0C = "#99d1db",
    base0D = "#8caaee",
    base0E = "#ca9ee6",
    base0F = "#e78284",
}
local highlights = {
    BlinkCmpMenu = { bg = "#303447" },
    BlinkCmpMenuBorder = { fg = "#51576d" },
    BlinkCmpMenuSelection = { link = "PmenuSel", bold = true },
    BlinkCmpScrollBarThumb = { bg = "#414559" },
    BlinkCmpScrollBarGutter = { bg = "#292c3c" },
    BlinkCmpLabel = { fg = "#D9E0EE" },
    BlinkCmpLabelDeprecated = { fg = "#e78284", strikethrough = true },
    BlinkCmpLabelMatch = { fg = "#89B4FA", bold = true },
    BlinkCmpLabelDetail = { fg = "#737994" },
    BlinkCmpLabelDescription = { fg = "#737994" },
    BlinkCmpSource = { fg = "#51576d" },
    BlinkCmpGhostText = { fg = "#51576d" },
    BlinkCmpDoc = { bg = "#303447" },
    BlinkCmpDocBorder = { fg = "#51576d" },
    BlinkCmpDocSeparator = { fg = "#414559" },
    BlinkCmpDocCursorLine = { bg = "#2d2c3c" },
    BlinkCmpSignatureHelp = { bg = "#303447" },
    BlinkCmpSignatureHelpBorder = { fg = "#51576d" },
    BlinkCmpSignatureHelpActiveParameter = { fg = "#89B4FA", bold = true },
    Added = { fg = colors.green },
    Removed = { fg = colors.red },
    Changed = { fg = colors.yellow },
    MatchWord = { bg = colors.grey, fg = colors.white },
    PmenuSbar = { bg = colors.one_bg },
    PmenuSel = { bg = colors.pmenu_bg, fg = colors.black },
    PmenuThumb = { bg = colors.grey },
    MatchParen = { link = "MatchWord" },
    Comment = { fg = colors.light_grey },
    CursorLineNr = { fg = colors.white },
    LineNr = { fg = colors.grey },
    NvimInternalError = { fg = colors.red },
    WinSeparator = { fg = colors.line },
    DevIconDefault = { fg = colors.red },
    Debug = { fg = theme.base08 },
    Directory = { fg = theme.base0D },
    Error = { fg = theme.base00, bg = theme.base08 },
    ErrorMsg = { fg = theme.base08, bg = theme.base00 },
    Exception = { fg = theme.base08 },

    FoldColumn = { bg = "none" },
    Folded = { fg = colors.light_grey, bg = colors.black2 },
    IncSearch = { fg = theme.base01, bg = theme.base09 },
    Macro = { fg = theme.base08 },
    ModeMsg = { fg = theme.base0B },
    MoreMsg = { fg = theme.base0B },
    Question = { fg = theme.base0D },
    Search = { fg = theme.base01, bg = theme.base0A },
    Substitute = { fg = theme.base01, bg = theme.base0A },
    SpecialKey = { fg = theme.base03 },
    TooLong = { fg = theme.base08 },
    Visual = { bg = theme.base04 },
    VisualNOS = { fg = theme.base08 },
    WarningMsg = { fg = theme.base08 },
    WildMenu = { fg = theme.base08, bg = theme.base0A },
    Title = { fg = theme.base0D },
    Conceal = { bg = "NONE" },
    Cursor = { fg = theme.base00, bg = theme.base05 },
    SignColumn = { fg = theme.base03 },
    ColorColumn = { bg = colors.black2 },
    CursorColumn = { bg = theme.base01 },
    CursorLine = { bg = colors.black2 },
    QuickFixLine = { bg = theme.base01 },
    healthSuccess = { bg = colors.green, fg = colors.black },
    WinBar = { bg = "NONE" },
    WinBarNC = { bg = "NONE" },
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
        bg = mixcolors(fg, "#303447", 70),
    }
end

highlights = vim.tbl_deep_extend("force", highlights, {
    BlinkCmpMenu = { bg = "#292c3c" },
    BlinkCmpDoc = { bg = "#232634" },
    BlinkCmpDocBorder = { fg = "#232634", bg = "#232634" },
})

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
