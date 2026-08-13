return {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
        modes = {
            char = {
                keys = { "f", "F", "t", "T" },
                char_actions = function(motion)
                    return {
                        -- clever-f style
                        -- [motion:lower()] = "next",
                        -- [motion:upper()] = "prev",
                        -- jump2d style: same case goes next, opposite case goes prev
                        [motion] = "next",
                        [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
                    }
                end,
            },
        },
    },
    config = function(_, opts)
        local function patch_flash_searchstate()
            local Hacks = require("flash.hacks") -- triggers flash's own ffi.cdef of the old symbols
            local ffi = require("ffi")

            -- Old standalone symbol still resolvable? then leave flash's own hacks alone.
            if pcall(function()
                    return ffi.C.search_match_lines
                end) then
                return
            end

            -- New: SearchState struct (src/nvim/search_defs.h), exported global `Search`.
            pcall(
                ffi.cdef,
                [[
      typedef struct {
        bool    hl_match;
        int32_t match_lines;
        int     match_endcol;
        int32_t first_line;
        int32_t last_line;
        bool    no_smartcase;
        int     cmdlen;
        bool    no_hlsearch;
      } SearchState;
      SearchState Search;
    ]]
            )
            -- Struct not resolvable? leave flash as-is (don't make it worse).
            if not pcall(function()
                    return ffi.C.Search.match_lines
                end) then
                return
            end

            local C = ffi.C
            local Pos = require("flash.search.pos")
            local incsearch_state = {}

            function Hacks.get_end_pos(from)
                local ret = Pos({
                    from[1] + C.Search.match_lines,
                    math.max(0, C.Search.match_endcol - 1),
                })
                local line = vim.api.nvim_buf_get_lines(0, ret[1] - 1, ret[1], false)[1]
                local char_idx = vim.fn.charidx(line, ret[2])
                ret[2] = vim.fn.byteidx(line, char_idx)
                return ret
            end

            function Hacks.save_incsearch_state()
                incsearch_state = {
                    match_endcol = C.Search.match_endcol,
                    match_lines = C.Search.match_lines,
                }
            end

            function Hacks.restore_incsearch_state()
                C.Search.match_endcol = incsearch_state.match_endcol
                C.Search.match_lines = incsearch_state.match_lines
            end
        end
        patch_flash_searchstate()
        require("flash").setup(opts)
        function FlashWords()
            local Flash = require("flash")

            local function format(opt)
                -- always show first and second label
                return {
                    { opt.match.label1, "FlashMatch" },
                    { opt.match.label2, "FlashLabel" },
                }
            end

            Flash.jump({
                search = { mode = "search" },
                label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
                pattern = [[\<]],
                action = function(match, state)
                    state:hide()
                    Flash.jump({
                        search = { max_length = 0 },
                        highlight = { matches = false },
                        label = { format = format },
                        matcher = function(win)
                            -- limit matches to the current label
                            return vim.tbl_filter(function(m)
                                return m.label == match.label and m.win == win
                            end, state.results)
                        end,
                        labeler = function(matches)
                            for _, m in ipairs(matches) do
                                m.label = m.label2 -- use the second label
                            end
                        end,
                    })
                end,
                labeler = function(matches, state)
                    local labels = state:labels()
                    for m, match in ipairs(matches) do
                        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                        match.label2 = labels[(m - 1) % #labels + 1]
                        match.label = match.label1
                    end
                end,
            })
        end

        function FlashLines()
            require("flash").jump({
                search = { mode = "search", max_length = 0 },
                label = { after = { 0, 0 } },
                pattern = "^",
            })
        end

        vim.keymap.set({ "o", "x", "n" }, "gw", FlashWords, { desc = "Flash Words" })
        vim.keymap.set({ "o", "x", "n" }, "gj", FlashLines, { desc = "Flash Lines" })
    end,
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash",
        },
        {
            "S",
            mode = { "n", "o", "x" },
            function()
                require("flash").treesitter()
            end,
            desc = "Flash Treesitter",
        },
        {
            "r",
            mode = "o",
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash",
        },
        {
            "R",
            mode = { "o", "x" },
            function()
                require("flash").treesitter_search()
            end,
            desc = "Treesitter Search",
        },
        {
            "<c-s>",
            mode = { "c" },
            function()
                require("flash").toggle()
            end,
            desc = "Toggle Flash Search",
        },
    },
}
