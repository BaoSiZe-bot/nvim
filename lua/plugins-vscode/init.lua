return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = {"LazyFile", "VeryLazy"},
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treesitter** module to be loaded in time.
            -- Luckily, the only things that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        cmd = {"TSUpdateSync", "TSUpdate", "TSInstall"},
        keys = {{
            "<c-space>",
            desc = "Increment Selection"
        }, {
                "<bs>",
                desc = "Decrement Selection",
                mode = "x"
            }},
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>"
                }
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner"
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]A"] = "@parameter.inner"
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner"
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner"
                    }
                }
            }
        },
        config = function(_, opts)
            -- if type(opts.ensure_installed) == "table" then
            --     opts.ensure_installed = require("configs.funcs").dedup(opts.ensure_installed)
            -- end
            require("nvim-treesitter.configs").setup(opts)
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        enabled = true,
        config = function()
            -- If treesitter is already loaded, we need to run config again for textobjects
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    move = {
                        enable = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.inner"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.inner"
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.inner"
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.inner"
                        }
                    }
                }
            })
            -- When in diff mode, we want to use the default
            -- vim text objects c & C instead of the treesitter ones.
            local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
            local configs = require("nvim-treesitter.configs")
            for name, fn in pairs(move) do
                if name:find("goto") == 1 then
                    move[name] = function(q, ...)
                        if vim.wo.diff then
                            local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                            for key, query in pairs(config or {}) do
                                if q == query and key:find("[%]%[][cC]") then
                                    vim.cmd("normal! " .. key)
                                    return
                                end
                            end
                        end
                        return fn(q, ...)
                    end
                end
            end
        end 
    }, 
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "nvim-mini/mini.bracketed",
        event = "LazyFile",
    },
    {
        "nvim-mini/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local mappings = {{
                "gsa",
                desc = "Add Surrounding",
                mode = {"n", "v"}
            }, {
                    "gsd",
                    desc = "Delete Surrounding"
                }, {
                    "gsF",
                    desc = "Find Right Surrounding"
                }, {
                    "gsf",
                    desc = "Find Left Surrounding"
                }, {
                    "gsh",
                    desc = "Highlight Surrounding"
                }, {
                    "gsr",
                    desc = "Replace Surrounding"
                }, {
                    "gsn",
                    desc = "Update `MiniSurround.config.n_lines`"
                }}
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn" -- Update `n_lines`
            }
        }
    },
    {
        "nvim-mini/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({ -- code block
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
                    d = { "%f[%d]%d+" },                                                          -- digits
                    e = {                                                                         -- Word with case
                        {
                            "%u[%l%d]+%f[^%l%d]",
                            "%f[%S][%l%d]+%f[^%l%d]",
                            "%f[%P][%l%d]+%f[^%l%d]",
                            "^[%l%d]+%f[^%l%d]",
                        },
                        "^().*()$",
                    },
                    g = function(ai_type)
                        local start_line, end_line = 1, vim.fn.line("$")
                        if ai_type == "i" then
                            -- Skip first and last blank lines for `i` textobject
                            local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line),
                                vim.fn.prevnonblank(end_line)
                            -- Do nothing for buffer with all blanks
                            if first_nonblank == 0 or last_nonblank == 0 then
                                return { from = { line = start_line, col = 1 } }
                            end
                            start_line, end_line = first_nonblank, last_nonblank
                        end
                        local to_col = math.max(vim.fn.getline(end_line):len(), 1)
                        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
                    end,                                                       -- buffer
                    u = ai.gen_spec.function_call(),                           -- u for "Usage"
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
        end,
    },
    {
        "nvim-mini/mini.pairs",
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = true, terminal = false },
            -- skip autopair when next character is one of these
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            -- skip autopair when the cursor is inside these treesitter nodes
            skip_ts = { "string" },
            -- skip autopair when next character is closing pair
            -- and there are more closing pairs than opening pairs
            skip_unbalanced = true,
            -- better deal with markdown code blocks
            markdown = true,
        },
        config = function(_, opts)
            ---@param opts {skip_next: string, skip_ts: string[], skip_unbalanced: boolean, markdown: boolean}
            local function mypairs(opts)
                local pairs = require("mini.pairs")
                pairs.setup(opts)
                local open = pairs.open
                pairs.open = function(pair, neigh_pattern)
                    if vim.fn.getcmdline() ~= "" then
                        return open(pair, neigh_pattern)
                    end
                    local o, c = pair:sub(1, 1), pair:sub(2, 2)
                    local line = vim.api.nvim_get_current_line()
                    local cursor = vim.api.nvim_win_get_cursor(0)
                    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
                    local before = line:sub(1, cursor[2])
                    if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
                        return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
                    end
                    if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
                        return o
                    end
                    if opts.skip_ts and #opts.skip_ts > 0 then
                        local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1,
                            math.max(cursor[2] - 1, 0))
                        for _, capture in ipairs(ok and captures or {}) do
                            if vim.tbl_contains(opts.skip_ts, capture.capture) then
                                return o
                            end
                        end
                    end
                    if opts.skip_unbalanced and next == c and c ~= o then
                        local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
                        local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
                        if count_close > count_open then
                            return o
                        end
                    end
                    return open(pair, neigh_pattern)
                end
            end
            mypairs(opts)
        end,
    },
    {
        "lambdalisue/vim-suda",
        cmd = {"SudaRead", "SudaWrite"}
    }, {
        "folke/flash.nvim",
        event = "VeryLazy",
        vscode = true,
        config = function()
            require("flash").setup({})
            function FlashWords()
                local Flash = require("flash")
                local function format(opts)
                    -- always show first and second label
                    return {{opts.match.label1, "FlashMatch"}, {opts.match.label2, "FlashLabel"}}
                end
                Flash.jump({
                    search = {
                        mode = "search"
                    },
                    label = {
                        after = false,
                        before = {0, 0},
                        uppercase = false,
                        format = format
                    },
                    pattern = [[\<]],
                    action = function(match, state)
                        state:hide()
                        Flash.jump({
                            search = {
                                max_length = 0
                            },
                            highlight = {
                                matches = false
                            },
                            label = {
                                format = format
                            },
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
                            end
                        })
                    end,
                    labeler = function(matches, state)
                        local labels = state:labels()
                        for m, match in ipairs(matches) do
                            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                            match.label2 = labels[(m - 1) % #labels + 1]
                            match.label = match.label1
                        end
                    end
                })
            end
            function FlashLines()
                require("flash").jump({
                    search = {
                        mode = "search",
                        max_length = 0
                    },
                    label = {
                        after = {0, 0}
                    },
                    pattern = "^"
                })
            end
            vim.keymap.set({"o", "x", "n"}, "gw", FlashWords, {
                desc = "Flash Words"
            })
            vim.keymap.set({"o", "x", "n"}, "gj", FlashLines, {
                desc = "Flash Lines"
            })
        end,
        keys = {{
            "s",
            mode = {"n", "x", "o"},
            function()
                require("flash").jump()
            end,
            desc = "Flash"
        }, {
                "S",
                mode = {"n", "o", "x"},
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter"
            }, {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash"
            }, {
                "R",
                mode = {"o", "x"},
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search"
            }, {
                "<c-s>",
                mode = {"c"},
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search"
            }}
    }, {
        "SCJangra/table-nvim",
        ft = "markdown",
        opts = {}
    }, {
        "cpea2506/relative-toggle.nvim",
        event = "LazyFile",
        opts = {}
    }, {
        "gbprod/yanky.nvim",
        event = "LazyFile",
        opts = {
            highlight = {
                timer = 150
            }
        },
        keys = { -- {
            --     "<leader>p",
            --     function()
            --         vim.cmd([[YankyRingHistory]])
            --     end,
            --     mode = { "n", "x" },
            --     desc = "Open Yank History",
            -- },
            {
                "y",
                "<Plug>(YankyYank)",
                mode = {"n", "x"},
                desc = "Yank Text"
            }, {
                "p",
                "<Plug>(YankyPutAfter)",
                mode = {"n", "x"},
                desc = "Put Text After Cursor"
            }, {
                "P",
                "<Plug>(YankyPutBefore)",
                mode = {"n", "x"},
                desc = "Put Text Before Cursor"
            }, {
                "gp",
                "<Plug>(YankyGPutAfter)",
                mode = {"n", "x"},
                desc = "Put Text After Selection"
            }, {
                "gP",
                "<Plug>(YankyGPutBefore)",
                mode = {"n", "x"},
                desc = "Put Text Before Selection"
            }, {
                "[y",
                "<Plug>(YankyCycleForward)",
                desc = "Cycle Forward Through Yank History"
            }, {
                "]y",
                "<Plug>(YankyCycleBackward)",
                desc = "Cycle Backward Through Yank History"
            }, {
                "]p",
                "<Plug>(YankyPutIndentAfterLinewise)",
                desc = "Put Indented After Cursor (Linewise)"
            }, {
                "[p",
                "<Plug>(YankyPutIndentBeforeLinewise)",
                desc = "Put Indented Before Cursor (Linewise)"
            }, {
                "]P",
                "<Plug>(YankyPutIndentAfterLinewise)",
                desc = "Put Indented After Cursor (Linewise)"
            }, {
                "[P",
                "<Plug>(YankyPutIndentBeforeLinewise)",
                desc = "Put Indented Before Cursor (Linewise)"
            }, {
                ">p",
                "<Plug>(YankyPutIndentAfterShiftRight)",
                desc = "Put and Indent Right"
            }, {
                "<p",
                "<Plug>(YankyPutIndentAfterShiftLeft)",
                desc = "Put and Indent Left"
            }, {
                ">P",
                "<Plug>(YankyPutIndentBeforeShiftRight)",
                desc = "Put Before and Indent Right"
            }, {
                "<P",
                "<Plug>(YankyPutIndentBeforeShiftLeft)",
                desc = "Put Before and Indent Left"
            }, {
                "=p",
                "<Plug>(YankyPutAfterFilter)",
                desc = "Put After Applying a Filter"
            }, {
                "=P",
                "<Plug>(YankyPutBeforeFilter)",
                desc = "Put Before Applying a Filter"
            }}
    }}
