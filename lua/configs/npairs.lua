local npairs = require('nvim-autopairs')
local basic = require("configs.npairs_basic")
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
    ignored_prev_char = [=[[%%\\]]=],
    enable_moveright = true,
    enable_afterquote = true,         -- add bracket pairs after quote
    enable_check_bracket_line = true, -- check bracket in same line
    enable_bracket_in_quote = false,  --
    enable_abbr = false,              -- trigger abbreviation
    break_undo = true,                -- switch for basic rule break undo sequence
    check_ts = true,
    map_cr = true,
    map_bs = true,   -- map the <BS> key
    map_c_h = false, -- Map the <C-h> key to delete a pair
    map_c_w = false, -- map <c-w> to delete a pair if possible
})

npairs.config.rules = basic.setup(npairs.config)

npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))

-- for _, i in ipairs(npairs.config.rules) do
--     i.key_map = nil
-- end

local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
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

local quotes = { "`", "\"", "'", }
for _, quote in pairs(quotes) do
    local tr = quote .. quote .. quote
    npairs.add_rule(
        Rule(tr, tr)
        :with_pair(function(opts)
            return opts.line:match("``")
        end)
        :with_move(cond.none())
        :with_del(cond.none())
        :replace_map_cr(function(_)
            return '<cr><cr>'
        end)
    )
end

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
