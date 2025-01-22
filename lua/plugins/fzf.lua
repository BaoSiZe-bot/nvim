return {
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
        keys = {
            { "<leader>lx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>lX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>ls", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
            { "<leader>lS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
            { "<leader>lL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>lQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
    },
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        opts = function(_, opts)
            local fzf = require("fzf-lua")
            local config = fzf.config
            local actions = fzf.actions

            -- Quickfix
            config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
            config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
            config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
            config.defaults.keymap.fzf["ctrl-x"] = "jump"
            config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
            config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
            config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
            config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
            config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
            -- Toggle root dir / cwd
            config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
            -- config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

            local img_previewer ---@type string[]?
            for _, v in ipairs({
                { cmd = "ueberzug", args = {} },
                { cmd = "chafa", args = { "{file}", "--format=symbols" } },
                { cmd = "viu", args = { "-b" } },
            }) do
                if vim.fn.executable(v.cmd) == 1 then
                    img_previewer = vim.list_extend({ v.cmd }, v.args)
                    break
                end
            end

            return {
                "default-title",
                fzf_colors = true,
                fzf_opts = {
                    ["--no-scrollbar"] = true,
                },
                defaults = {
                    -- formatter = "path.filename_first",
                    formatter = "path.dirname_first",
                },
                previewers = {
                    builtin = {
                        extensions = {
                            ["png"] = img_previewer,
                            ["jpg"] = img_previewer,
                            ["jpeg"] = img_previewer,
                            ["gif"] = img_previewer,
                            ["webp"] = img_previewer,
                        },
                        ueberzug_scaler = "fit_contain",
                    },
                },
                -- Custom LazyVim option to configure vim.ui.select
                ui_select = function(fzf_opts, items)
                    return vim.tbl_deep_extend("force", fzf_opts, {
                        prompt = " ",
                        winopts = {
                            title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
                            title_pos = "center",
                        },
                    }, fzf_opts.kind == "codeaction" and {
                        winopts = {
                            layout = "vertical",
                            -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
                            height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
                            width = 0.5,
                            preview = {
                                layout = "vertical",
                                vertical = "down:15,border-top",
                            },
                        },
                    } or {
                        winopts = {
                            width = 0.5,
                            -- height is number of items, with a max of 80% screen height
                            height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
                        },
                    })
                end,
                winopts = {
                    width = 0.8,
                    height = 0.8,
                    row = 0.5,
                    col = 0.5,
                    preview = {
                        scrollchars = { "┃", "" },
                    },
                },
                files = {
                    cwd_prompt = false,
                    actions = {
                        ["alt-i"] = { actions.toggle_ignore },
                        ["alt-h"] = { actions.toggle_hidden },
                    },
                },
                grep = {
                    actions = {
                        ["alt-i"] = { actions.toggle_ignore },
                        ["alt-h"] = { actions.toggle_hidden },
                    },
                },
                lsp = {
                    symbols = {
                        symbol_hl = function(s)
                            return "TroubleIcon" .. s
                        end,
                        symbol_fmt = function(s)
                            return s:lower() .. "\t"
                        end,
                        child_prefix = false,
                    },
                    code_actions = {
                        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
                    },
                },
            }
        end,
        config = function(_, opts)
            if opts[1] == "default-title" then
                -- use the same prompt for all pickers for profile `default-title` and
                -- profiles that use `default-title` as base profile
                local function fix(t)
                    t.prompt = t.prompt ~= nil and " " or nil
                    for _, v in pairs(t) do
                        if type(v) == "table" then
                            fix(v)
                        end
                    end
                    return t
                end
                opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
                opts[1] = nil
            end
            require("fzf-lua").setup(opts)
        end,
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "fzf-lua" } })
                require("fzf-lua").register_ui_select(function(fzf_opts, items)
                    return vim.tbl_deep_extend("force", fzf_opts, {
                        prompt = " ",
                        winopts = {
                            title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
                            title_pos = "center",
                        },
                    }, fzf_opts.kind == "codeaction" and {
                        winopts = {
                            layout = "vertical",
                            -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
                            height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
                            width = 0.5,
                            preview = {
                                layout = "vertical",
                                vertical = "down:15,border-top",
                            },
                        },
                    } or {
                        winopts = {
                            width = 0.5,
                            -- height is number of items, with a max of 80% screen height
                            height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
                        },
                    })
                end)
                return vim.ui.select(...)
            end
        end,
        keys = {
            { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
            { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
            {
                "<leader>,",
                "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
                desc = "Switch Buffer",
            },
            { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
            { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
            -- find
            { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
            -- { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
            { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
            { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
            -- git
            { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
            { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
            -- search
            { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
            { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
            { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
            { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
            { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
            { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
            { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
            { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
            { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
            { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
            { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
            { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
            { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
            { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
            { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
            { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
            { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word (Root Dir)" },
            { "<leader>uc", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },
            {
                "<leader>ss",
                function()
                    require("fzf-lua").lsp_document_symbols({
                        regex_filter = symbols_filter,
                    })
                end,
                desc = "Goto Symbol",
            },
            {
                "<leader>sS",
                function()
                    require("fzf-lua").lsp_live_workspace_symbols({
                        regex_filter = symbols_filter,
                    })
                end,
                desc = "Goto Symbol (Workspace)",
            },
        },
    },
}
