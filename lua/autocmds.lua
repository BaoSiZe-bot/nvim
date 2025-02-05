-- [nfnl] Compiled from fnl/autocmds.fnl by https://github.com/Olical/nfnl, do not edit.
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
    name = "ABL_" .. name
    return vim.api.nvim_create_augroup(name, { clear = true })
end
local augroups = vim.tbl_map(function(name)
    return augroup(name)
end, {
    "Buffer",
    "Cursor",
    "FASD",
    "Fugitive",
    "Help",
    "Keywordprg",
    "Man",
    "Term",
    "Yank",
    "Zen",
    "Snacks",
    "Untitled",
    "ColorScheme",
})

autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = { "*" },
    callback = function()
        if vim.b.buftype ~= "nofile" then
            vim.cmd("silent! wall")
        end
    end,
    nested = true
})
autocmd({ "BufWritePre" }, {
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = "*",
    group = augroups.ColorScheme,
    callback = function()
        -- 解决 vim 帮助文件的示例代码的不够突显的问题
        vim.cmd("hi def link helpExample Special")
        if vim.fn.exists("g:neovide") == 1 then
            vim.cmd("highlight MyBorder guifg=bg guibg=NONE")
        else
            vim.cmd("highlight MyBorder guifg=" .. vim.g.lbs_colors.orange .. " guibg=NONE")
        end
        vim.cmd("highlight DiagnosticSignInfo guibg=NONE")
        -- Setting the color scheme of the Complement window
        local pallete = {
            background = vim.g.lbs_colors.yellow,
            fg = vim.g.lbs_colors.darkblue,
            strong = vim.g.lbs_colors.red,
        }
        if vim.o.background == "dark" then
            pallete = {
                background = vim.g.lbs_colors.darkblue,
                fg = vim.g.lbs_colors.fg_float,
                strong = vim.g.lbs_colors.red,
            }
        end

        vim.cmd("highlight MyPmenu guibg=" .. pallete.background)
        vim.cmd("highlight CmpItemAbbr guifg=" .. pallete.fg)
        vim.cmd("highlight CmpItemAbbrMatch guifg=" .. pallete.strong)
        vim.cmd("highlight MsgSeparator guibg=bg guifg=" .. pallete.strong)
        vim.cmd("highlight ObsidianHighlightText guifg=" .. pallete.strong)
        vim.cmd("highlight @markdown.strong gui=underline")
        vim.cmd("highlight @markup.raw.markdown_inline guibg=NONE")

        vim.cmd.highlight("link IndentLine LineNr")
        vim.cmd.highlight("IndentLineCurrent guifg=" .. vim.g.lbs_colors.orange)
    end,
    desc = "Define personal highlight group",
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})
autocmd("BufReadPost", {
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
autocmd("FileType", {
    pattern = {
        "PlenaryTestPopup",
        "checkhealth",
        "dbout",
        "gitsigns-blame",
        "grug-far",
        "help",
        "lspinfo",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "q", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

autocmd("FileType", {
    pattern = { "man" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
    end,
})
autocmd("FileType", {
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})
autocmd({ "FileType" }, {
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})
