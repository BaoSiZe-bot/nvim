local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.setup({
    enabled = function(bufnr) return true end, -- control if auto-pairs should be enabled when attaching to a buffer
    disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
    disable_in_macro = true,                   -- disable when recording or executing a macro
    disable_in_visualblock = false,            -- disable when insert after visual block mode
    fast_wrap = {},
    disable_in_replace_mode = true,
    ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    enable_moveright = true,
    enable_afterquote = true,         -- add bracket pairs after quote
    enable_check_bracket_line = true, --- check bracket in same line
    enable_bracket_in_quote = true,   --
    enable_abbr = false,              -- trigger abbreviation
    break_undo = true,                -- switch for basic rule break undo sequence
    check_ts = true,
    map_cr = true,
    map_bs = true,   -- map the <BS> key
    map_c_h = false, -- Map the <C-h> key to delete a pair
    map_c_w = false, -- map <c-w> to delete a pair if possible
})
npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
-- for _, i in ipairs(npairs.config.rules) do
--     i.key_map = nil
-- end

-- require("ultimate-autopair").setup({})

local get_closing_for_line = function(line)
    local i = -1
    local clo = ''

    while true do
        i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
        if i == nil then break end
        local ch = string.sub(line, i, i)
        local st = string.sub(clo, 1, 1)

        if ch == '{' then
            clo = '}' .. clo
        elseif ch == '}' then
            if st ~= '}' then return '' end
            clo = string.sub(clo, 2)
        elseif ch == '(' then
            clo = ')' .. clo
        elseif ch == ')' then
            if st ~= ')' then return '' end
            clo = string.sub(clo, 2)
        elseif ch == '[' then
            clo = ']' .. clo
        elseif ch == ']' then
            if st ~= ']' then return '' end
            clo = string.sub(clo, 2)
        end
    end

    return clo
end

-- npairs.remove_rule('(')
-- npairs.remove_rule('{')
-- npairs.remove_rule('[')
-- npairs.remove_rule('\"')
-- npairs.remove_rule('`')
-- npairs.remove_rule('\'')

-- npairs.add_rules{
--   -- 示例：针对括号 () 在 Lua 中的规则
--   Rule("(", ")")
--     :with_pair(cond.not_before_regex("[\\\\%%]"))  -- 忽略前一个字符是 \（regex 中用 \\ 转义）
--     :with_del(cond.not_before_regex("[\\\\%%]")),  -- 同时忽略删除配对
--
--   -- 示例：针对引号 "" 在 Lua 中的规则
--   Rule("\"", "\"")
--     :with_pair(cond.not_before_regex("[\\\\%%]"))  -- 忽略前一个字符是 %
--     :with_del(cond.not_before_regex("[\\\\%%]")),
--
--   -- 组合规则：同时忽略 \ 和 %（针对多个符号）
--   Rule("[", "]")
--     :with_pair(cond.not_before_regex("[\\\\%%]")) -- regex 匹配 \ 或 %
--     :with_del(cond.not_before_regex("[\\\\%%]")),
--
--   -- 针对其他常见配对，如 {} 或 ''
--   Rule("{", "}")
--     :with_pair(cond.not_before_regex("[\\\\%%]"))
--     :with_del(cond.not_before_regex("[\\\\%%]")),
--
--   Rule("'", "'")
--     :with_pair(cond.not_before_regex("[\\\\%%]"))
--     :with_del(cond.not_before_regex("[\\\\%%]")),
--
--   Rule("`", "`")
--     :with_pair(cond.not_before_regex("[\\\\%%]"))
--     :with_del(cond.not_before_regex("[\\\\%%]")),
-- }


npairs.add_rule(Rule("[%(%{%[]", "")
    :use_regex(true)
    :replace_endpair(function(opts)
        return get_closing_for_line(opts.line)
    end)
    :end_wise(function(opts)
        -- Do not endwise if there is no closing
        return get_closing_for_line(opts.line) ~= ""
    end))

local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }

--          ╭─────────────────────────────────────────────────────────╮
--          │   For each pair of brackets we will add another rule    │
--          ╰─────────────────────────────────────────────────────────╯

for _, bracket in pairs(brackets) do
    npairs.add_rules {
        -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
        Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == bracket[2] end)
            :with_del(cond.none())
            :use_key(bracket[2])
        -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
    }
end
npairs.add_rule(
    Rule("```", "```")
    :with_pair(function(opts)
        return opts.line:match("``")
    end)
    :with_move(cond.none())
    :with_del(cond.none())
    :replace_map_cr(function(_)
        return '<cr><cr>'
    end)
)
npairs.add_rule(
    Rule("\"\"\"", "\"\"\"")
    :with_pair(function(opts)
        return opts.line:match("\\\"\\\"")
    end)
    :with_move(cond.none())
    :with_del(cond.none())
    :replace_map_cr(function(_)
        return '<cr><cr>'
    end)
)
npairs.add_rule(
    Rule("'''", "'''")
    :with_pair(function(opts)
        return opts.line:match("''")
    end)
    :with_move(cond.none())
    :with_del(cond.none())
    :replace_map_cr(function(_)
        return '<cr><cr>'
    end)
)

local function rule2(a1, ins, a2, lang)
    npairs.add_rule(
        Rule(ins, ins, lang)
        :with_pair(function(opts) return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1) end)
        :with_move(cond.none())
        :with_cr(cond.none())
        :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            return a1 .. ins .. ins .. a2 ==
                opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2) -- insert only works for #ins == 1 anyway
        end)
    )
end

rule2('(', '*', ')', 'ocaml')
rule2('(*', ' ', '*)', 'ocaml')
rule2('(', ' ', ')')

local ts_conds = require('nvim-autopairs.ts-conds')

npairs.add_rules({
    Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
    Rule("'", "',", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
    Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
})
--
-- npairs.remove_rule("[")
-- npairs.add_rule(
--     Rule("%[%=*%[", "", "lua")
--     :use_regex(true)
--     :with_pair(function(opts)
--         local current_line = opts.line
--         -- 尝试匹配用户输入的前面部分，以捕获等号的数量
--         -- 模式：开头的 '[' 后跟零个或多个 '='，再跟一个 '['
--         local num_equals = current_line:match(".*%[(=*)")
--
--         if num_equals then
--             -- 捕获到了等号，返回闭合字符串
--             return true
--         end
--         -- 如果没有匹配到长字符串模式，则不自动匹配
--         return false
--     end)
--     :replace_endpair(function(opts)
--         local current_line = opts.line
--         local num_equals = current_line:match(".*%[(=*)")
--         local close_tag = "]" .. num_equals .. "]"
--         return close_tag
--     end)
--     :with_move(cond.none())
--     :with_del(cond.none())
-- )
