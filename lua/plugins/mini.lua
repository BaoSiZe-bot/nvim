return {
    {
        "nvim-mini/mini.icons",
        lazy = true,
        opts = {
            file = {
                [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
                ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
                ["robots.txt"] = { glyph = "󰚩", name = "robots" },
            },
            filetype = {
                dotenv = { glyph = "", hl = "MiniIconsYellow" },
                default_icon = { glyph = "󰈚", name = "Default" },
                cpp = { glyph = "", name = "cpp" },
                js = { glyph = "󰌞", name = "js" },
                ts = { glyph = "󰛦", name = "ts" },
                lock = { glyph = "󰌾", name = "lock" },
            },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    {
        "nvim-mini/mini.ai",
        event = "BufReadPost",
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
            vim.schedule(function()
                local function ai_whichkey(opts)
                    local objects = {
                        { " ", desc = "whitespace" },
                        { '"', desc = '" string' },
                        { "'", desc = "' string" },
                        { "(", desc = "() block" },
                        { ")", desc = "() block with ws" },
                        { "<", desc = "<> block" },
                        { ">", desc = "<> block with ws" },
                        { "?", desc = "user prompt" },
                        { "U", desc = "use/call without dot" },
                        { "[", desc = "[] block" },
                        { "]", desc = "[] block with ws" },
                        { "_", desc = "underscore" },
                        { "`", desc = "` string" },
                        { "a", desc = "argument" },
                        { "b", desc = ")]} block" },
                        { "c", desc = "class" },
                        { "d", desc = "digit(s)" },
                        { "e", desc = "CamelCase / snake_case" },
                        { "f", desc = "function" },
                        { "g", desc = "entire file" },
                        { "i", desc = "indent" },
                        { "o", desc = "block, conditional, loop" },
                        { "q", desc = "quote `\"'" },
                        { "t", desc = "tag" },
                        { "u", desc = "use/call" },
                        { "{", desc = "{} block" },
                        { "}", desc = "{} with ws" },
                    }

                    local ret = { mode = { "o", "x" } }
                    ---@type table<string, string>
                    local mappings = vim.tbl_extend("force", {}, {
                        around = "a",
                        inside = "i",
                        around_next = "an",
                        inside_next = "in",
                        around_last = "al",
                        inside_last = "il",
                    }, opts.mappings or {})
                    mappings.goto_left = nil
                    mappings.goto_right = nil

                    for name, prefix in pairs(mappings) do
                        name = name:gsub("^around_", ""):gsub("^inside_", "")
                        ret[#ret + 1] = { prefix, group = name }
                        for _, obj in ipairs(objects) do
                            local desc = obj.desc
                            if prefix:sub(1, 1) == "i" then
                                desc = desc:gsub(" with ws", "")
                            end
                            ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
                        end
                    end
                    require("which-key").add(ret, { notify = false })
                end
                ai_whichkey(opts)
            end)
        end,
    },
    {
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
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
        "nvim-mini/mini.surround",
        recommended = true,
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local mappings = {
                { "gsa", desc = "Add Surrounding",                     mode = { "n", "v" } },
                { "gsd", desc = "Delete Surrounding" },
                { "gsF", desc = "Find Right Surrounding" },
                { "gsf", desc = "Find Left Surrounding" },
                { "gsh", desc = "Highlight Surrounding" },
                { "gsr", desc = "Replace Surrounding" },
                { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "gsa",            -- Add surrounding in Normal and Visual modes
                delete = "gsd",         -- Delete surrounding
                find = "gsf",           -- Find surrounding (to the right)
                find_left = "gsF",      -- Find surrounding (to the left)
                highlight = "gsh",      -- Highlight surrounding
                replace = "gsr",        -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
        },
    },
    { "nvim-mini/mini.trailspace", opts = {}, event = "LazyFile" },
    {
        "nvim-mini/mini.files",
        opts = {
            windows = {
                preview = true,
                width_focus = 30,
                width_preview = 30,
            },
            options = {
                -- Whether to use for editing directories
                -- Disabled by default in LazyVim because neo-tree is used for that
                use_as_default_explorer = false,
            },
        },
        keys = {
            {
                "<leader>fm",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
                end,
                desc = "Open mini.files (Directory of Current File)",
            },
            {
                "<leader>fM",
                function()
                    require("mini.files").open(vim.uv.cwd(), true)
                end,
                desc = "Open mini.files (cwd)",
            },
        },
        config = function(_, opts)
            require("mini.files").setup(opts)

            local show_dotfiles = true
            local filter_show = function(fs_entry)
                return true
            end
            local filter_hide = function(fs_entry)
                return not vim.startswith(fs_entry.name, ".")
            end

            local toggle_dotfiles = function()
                show_dotfiles = not show_dotfiles
                local new_filter = show_dotfiles and filter_show or filter_hide
                require("mini.files").refresh({ content = { filter = new_filter } })
            end

            local map_split = function(buf_id, lhs, direction, close_on_file)
                local rhs = function()
                    local new_target_window
                    local cur_target_window = require("mini.files").get_explorer_state().target_window
                    if cur_target_window ~= nil then
                        vim.api.nvim_win_call(cur_target_window, function()
                            vim.cmd("belowright " .. direction .. " split")
                            new_target_window = vim.api.nvim_get_current_win()
                        end)

                        require("mini.files").set_target_window(new_target_window)
                        require("mini.files").go_in({ close_on_file = close_on_file })
                    end
                end

                local desc = "Open in " .. direction .. " split"
                if close_on_file then
                    desc = desc .. " and close"
                end
                vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
            end

            local files_set_cwd = function()
                local cur_entry_path = MiniFiles.get_fs_entry().path
                local cur_directory = vim.fs.dirname(cur_entry_path)
                if cur_directory ~= nil then
                    vim.fn.chdir(cur_directory)
                end
            end

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    local buf_id = args.data.buf_id

                    vim.keymap.set(
                        "n",
                        opts.mappings and opts.mappings.toggle_hidden or "g.",
                        toggle_dotfiles,
                        { buffer = buf_id, desc = "Toggle hidden files" }
                    )

                    vim.keymap.set(
                        "n",
                        opts.mappings and opts.mappings.change_cwd or "gc",
                        files_set_cwd,
                        { buffer = args.data.buf_id, desc = "Set cwd" }
                    )

                    map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "<C-w>s", "horizontal", false)
                    map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "<C-w>v", "vertical", false)
                    map_split(
                        buf_id,
                        opts.mappings and opts.mappings.go_in_horizontal_plus or "<C-w>S",
                        "horizontal",
                        true
                    )
                    map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "<C-w>V", "vertical", true)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesActionRename",
                callback = function(event)
                    Snacks.rename.on_rename_file(event.data.from, event.data.to)
                end,
            })
        end,
    },
    {
        "nvim-mini/mini.bracketed",
        event = "LazyFile",
    }
}
