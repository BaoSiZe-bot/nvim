return {

    -- Treesitter is a new parser generator tool that we can
    -- use in Neovim to power faster and more accurate
    -- syntax highlighting.
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        version = false, -- last release is way too old and doesn't work on Windows
        build = function()
            local TS = require("nvim-treesitter")
            TS.update(nil, { summary = true })
        end,
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        event = { "LazyFile", "VeryLazy" },
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        opts_extend = { "ensure_installed" },
        opts = {
            indent = { enable = true },
            highlight = { enable = true },
            folds = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "printf",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter")

            -- some quick sanity checks
            -- setup treesitter
            TS.setup(opts)
            -- LazyVim.treesitter.get_installed(true) -- initialize the installed langs

            -- install missing parsers
            -- local install = vim.tbl_filter(function(lang)
            --   return not LazyVim.treesitter.have(lang)
            -- end, opts.ensure_installed or {})
            -- if #install > 0 then
            --   LazyVim.treesitter.ensure_treesitter_cli(function()
            --     TS.install(install, { summary = true }):await(function()
            --       LazyVim.treesitter.get_installed(true) -- refresh the installed langs
            --     end)
            --   end)
            -- end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("nvim_treesitter", { clear = true }),
                callback = function(ev)
                    -- highlighting
                    if vim.tbl_get(opts, "highlight", "enable") ~= false then
                        pcall(vim.treesitter.start)
                    end

                    -- indents
                    if vim.tbl_get(opts, "indent", "enable") ~= false then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end

                    -- folds
                    if vim.tbl_get(opts, "folds", "enable") ~= false then
                        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        opts = {
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                keys = {
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                    },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner",
                    },
                },
            },
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter-textobjects")
            if not TS.setup then
                print("Please use `:Lazy` and update `nvim-treesitter`")
                return
            end
            TS.setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("nvim_treesitter_textobjects", { clear = true }),
                callback = function(ev)
                    if not vim.tbl_get(opts, "move", "enable") then
                        return
                    end
                    ---@type table<string, table<string, string>>
                    local moves = vim.tbl_get(opts, "move", "keys") or {}

                    for method, keymaps in pairs(moves) do
                        for key, query in pairs(keymaps) do
                            local desc = query:gsub("@", ""):gsub("%..*", "")
                            desc = desc:sub(1, 1):upper() .. desc:sub(2)
                            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
                            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
                            if not (vim.wo.diff and key:find("[cC]")) then
                                vim.keymap.set({ "n", "x", "o" }, key, function()
                                    require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
                                end, {
                                    buffer = ev.buf,
                                    desc = desc,
                                    silent = true,
                                })
                            end
                        end
                    end
                end,
            })
        end,
    },

    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        event = "LazyFile",
        opts = {},
    },

    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
