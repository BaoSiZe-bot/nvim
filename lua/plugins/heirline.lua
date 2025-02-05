return {
    "rebelot/heirline.nvim",
    enabled = true,
    event = "UIEnter",
    opts = function()
        local Align = { provider = "%=" }
        local Space = { provider = " " }
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")
        local function setup_colors()
            return {
                bright_bg = utils.get_highlight("Folded").bg,
                bright_fg = utils.get_highlight("Folded").fg,
                red = utils.get_highlight("DiagnosticError").fg,
                dark_red = utils.get_highlight("DiffDelete").bg,
                green = utils.get_highlight("String").fg,
                blue = utils.get_highlight("Function").fg,
                gray = utils.get_highlight("NonText").fg,
                orange = utils.get_highlight("Constant").fg,
                purple = utils.get_highlight("Statement").fg,
                cyan = utils.get_highlight("Special").fg,
                diag_warn = utils.get_highlight("DiagnosticWarn").fg,
                diag_error = utils.get_highlight("DiagnosticError").fg,
                diag_hint = utils.get_highlight("DiagnosticHint").fg,
                diag_info = utils.get_highlight("DiagnosticInfo").fg,
                git_del = utils.get_highlight("DiagnosticError").fg,
                git_add = utils.get_highlight("String").fg,
                git_change = utils.get_highlight("Function").fg,
            }
        end
        require("heirline").load_colors(setup_colors)
        vim.api.nvim_create_augroup("Heirline", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                utils.on_colorscheme(setup_colors)
            end,
            group = "Heirline",
        })
        local ViMode = {
            -- get vim current mode, this information will be required by the provider
            -- and the highlight functions, so we compute it only once per component
            -- evaluation and store it as a component attribute
            init = function(self)
                self.mode = vim.fn.mode(1) -- :h mode()
            end,
            -- Now we define some dictionaries to map the output of mode() to the
            -- corresponding string and color. We can put these into `static` to compute
            -- them at initialisation time.
            static = {
                mode_names = { -- change the strings if you like it vvvvverbose!
                    n = "N",
                    no = "N?",
                    nov = "N?",
                    noV = "N?",
                    ["no\22"] = "N?",
                    niI = "Ni",
                    niR = "Nr",
                    niV = "Nv",
                    nt = "Nt",
                    v = "V",
                    vs = "Vs",
                    V = "V_",
                    Vs = "Vs",
                    ["\22"] = "^V",
                    ["\22s"] = "^V",
                    s = "S",
                    S = "S_",
                    ["\19"] = "^S",
                    i = "I",
                    ic = "Ic",
                    ix = "Ix",
                    R = "R",
                    Rc = "Rc",
                    Rx = "Rx",
                    Rv = "Rv",
                    Rvc = "Rv",
                    Rvx = "Rv",
                    c = "C",
                    cv = "Ex",
                    r = "...",
                    rm = "M",
                    ["r?"] = "?",
                    ["!"] = "!",
                    t = "T",
                },
                mode_colors = {
                    n = "red",
                    i = "green",
                    v = "cyan",
                    V = "cyan",
                    ["\22"] = "cyan",
                    c = "orange",
                    s = "purple",
                    S = "purple",
                    ["\19"] = "purple",
                    R = "orange",
                    r = "orange",
                    ["!"] = "red",
                    t = "red",
                },
            },
            -- We can now access the value of mode() that, by now, would have been
            -- computed by `init()` and use it to index our strings dictionary.
            -- note how `static` fields become just regular attributes once the
            -- component is instantiated.
            -- To be extra meticulous, we can also add some vim statusline syntax to
            -- control the padding and make sure our string is always at least 2
            -- characters long. Plus a nice Icon.
            provider = function(self)
                return " %2(" .. self.mode_names[self.mode] .. "%)"
            end,
            -- Same goes for the highlight. Now the foreground will change according to the current mode.
            hl = function(self)
                local mode = self.mode:sub(1, 1) -- get only the first mode character
                return { fg = self.mode_colors[mode], bold = true }
            end,
        }
        local FileNameBlock = {
            -- let's first set up some attributes needed by this component and its children
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
        }
        -- We can now define some children separately and add them later

        local FileIcon = {
            init = function(self)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color =
                    require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
            end,
            provider = function(self)
                return self.icon and (self.icon .. " ")
            end,
            hl = function(self)
                return { fg = self.icon_color }
            end,
        }

        local FileFlags = {
            {
                condition = function()
                    return vim.bo.modified
                end,
                provider = "[+]",
                hl = { fg = "green" },
            },
            {
                condition = function()
                    return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "",
                hl = { fg = "orange" },
            },
        }

        -- Now, let's say that we want the filename color to change if the buffer is
        -- modified. Of course, we could do that directly using the FileName.hl field,
        -- but we'll see how easy it is to alter existing components using a "modifier"
        -- component

        local FileNameModifer = {
            hl = function()
                if vim.bo.modified then
                    -- use `force` because we need to override the child's hl foreground
                    return { fg = "cyan", bold = true, force = true }
                end
            end,
        }
        local FileName = {
            init = function(self)
                self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
                if self.lfilename == "" then
                    self.lfilename = "[No Name]"
                end
            end,
            hl = { fg = utils.get_highlight("Directory").fg },

            flexible = 2,

            {
                provider = function(self)
                    return self.lfilename
                end,
            },
            {
                provider = function(self)
                    return vim.fn.pathshorten(self.lfilename)
                end,
            },
        }

        -- let's add the children to our FileNameBlock component
        MyFileNameBlock = utils.insert(
            FileNameBlock,
            FileIcon,
            utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
            FileFlags,
            { provider = "%<" }                      -- this means that the statusline is cut here when there's not enough space
        )
        local FileType = {
            provider = function()
                return string.upper(vim.bo.filetype)
            end,
            hl = { fg = utils.get_highlight("Type").fg, bold = true },
        }
        -- We're getting minimalist here!
        local Ruler = {
            -- %l = current line number
            -- %L = number of lines in the buffer
            -- %c = column number
            -- %P = percentage through file of displayed window
            provider = "%7(%l/%3L%):%2c %P",
        }
        utils.surround({ "", "" }, function(self)
            return self:mode_color()
        end, { Ruler, hl = { fg = "black" } })
        -- I take no credits for this! 🦁
        local ScrollBar = {
            static = {
                sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
                -- Another variant, because the more choice the better.
                -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
            },
            provider = function(self)
                local curr_line = vim.api.nvim_win_get_cursor(0)[1]
                local lines = vim.api.nvim_buf_line_count(0)
                local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
                return string.rep(self.sbar[i], 2)
            end,
            hl = { fg = "blue", bg = "bright_bg" },
        }
        local LSPActive = {
            on_click = {
                callback = function()
                    vim.defer_fn(function()
                        vim.cmd("LspInfo")
                    end, 100)
                end,
                name = "heirline_LSP",
            },
            condition = conditions.lsp_attached,
            update = { "LspAttach", "LspDetach" },

            -- You can keep it simple,
            -- provider = " [LSP]",

            -- Or complicate things a bit and get the servers names
            provider = function()
                local names = {}
                for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                    table.insert(names, server.name)
                end
                return " [" .. table.concat(names, " ") .. "]"
            end,
            hl = { fg = "green", bold = true },
        }
        -- Awesome plugin
        local bit = require("bit")
        -- Full nerd (with icon colors and clickable elements)!
        -- works in multi window, but does not support flexible components (yet ...)
        local dropbar = {
            provider = function(self)
                return _G.dropbar()
            end,
            hl = { fg = "gray" },
            update = "CursorMoved",
        }
        local Diagnostics = {
            on_click = {
                callback = function()
                    require("trouble").toggle({ mode = "diagnostics" })
                    -- or
                    -- vim.diagnostic.setqflist()
                end,
                name = "heirline_diagnostics",
            },
            condition = conditions.has_diagnostics,

            static = {
                error_icon = " ",
                warn_icon = " ",
                info_icon = " ",
                hint_icon = " ",
            },

            init = function(self)
                self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            end,

            update = { "DiagnosticChanged", "BufEnter" },

            {
                provider = "![",
            },
            {
                provider = function(self)
                    -- 0 is just another output, we can decide to print it or not!
                    return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                end,
                hl = { fg = "diag_error" },
            },
            {
                provider = function(self)
                    return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                end,
                hl = { fg = "diag_warn" },
            },
            {
                provider = function(self)
                    return self.info > 0 and (self.info_icon .. self.info .. " ")
                end,
                hl = { fg = "diag_info" },
            },
            {
                provider = function(self)
                    return self.hints > 0 and (self.hint_icon .. self.hints)
                end,
                hl = { fg = "diag_hint" },
            },
            {
                provider = "]",
            },
        }
        local Git = {
            on_click = {
                callback = function()
                    -- If you want to use Fugitive:
                    -- vim.cmd("G")

                    -- If you prefer Lazygit
                    -- use vim.defer_fn() if the callback requires
                    -- opening of a floating window
                    -- (this also applies to telescope)
                    vim.defer_fn(function()
                        vim.cmd("Lazygit")
                    end, 100)
                end,
                name = "heirline_git",
            },
            condition = conditions.is_git_repo,

            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict
                self.has_changes = self.status_dict.added ~= 0
                    or self.status_dict.removed ~= 0
                    or self.status_dict.changed ~= 0
            end,

            hl = { fg = "orange" },

            { -- git branch name
                provider = function(self)
                    return " " .. self.status_dict.head
                end,
                hl = { bold = true },
            },
            -- You could handle delimiters, icons and counts similar to Diagnostics
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = "(",
            },
            {
                provider = function(self)
                    local count = self.status_dict.added or 0
                    return count > 0 and ("+" .. count)
                end,
                hl = { fg = "git_add" },
            },
            {
                provider = function(self)
                    local count = self.status_dict.removed or 0
                    return count > 0 and ("-" .. count)
                end,
                hl = { fg = "git_del" },
            },
            {
                provider = function(self)
                    local count = self.status_dict.changed or 0
                    return count > 0 and ("~" .. count)
                end,
                hl = { fg = "git_change" },
            },
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = ")",
            },
        }
        -- Note that we add spaces separately, so that only the icon characters will be clickable
        local DAPMessages = {
            condition = function()
                local session = require("dap").session()
                return session ~= nil
            end,
            provider = function()
                return " " .. require("dap").status() .. " "
            end,
            hl = "Debug",
            {
                provider = " ",
                on_click = {
                    callback = function()
                        require("dap").step_into()
                    end,
                    name = "heirline_dap_step_into",
                },
            },
            { provider = " " },
            {
                provider = " ",
                on_click = {
                    callback = function()
                        require("dap").step_out()
                    end,
                    name = "heirline_dap_step_out",
                },
            },
            { provider = " " },
            {
                provider = " ",
                on_click = {
                    callback = function()
                        require("dap").step_over()
                    end,
                    name = "heirline_dap_step_over",
                },
            },
            { provider = " " },
            {
                provider = " ",
                on_click = {
                    callback = function()
                        require("dap").step_back()
                    end,
                    name = "heirline_dap_step_back",
                },
            },
            { provider = " " },
            {
                provider = " ",
                on_click = {
                    callback = function()
                        require("dap").run_last()
                    end,
                    name = "heirline_dap_run_last",
                },
            },
            { provider = " " },
            {
                provider = " ",
                on_click = {
                    callback = function()
                        require("dap").terminate()
                        require("dapui").close({})
                    end,
                    name = "heirline_dap_close",
                },
            },
            { provider = " " },
            -- icons:       ﰇ  
        }
        local WorkDir = {
            init = function(self)
                self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
                local cwd = vim.fn.getcwd(0)
                self.cwd = vim.fn.fnamemodify(cwd, ":~")
            end,
            hl = { fg = "blue", bold = true },

            flexible = 1,

            {
                -- evaluates to the full-lenth path
                provider = function(self)
                    local trail = self.cwd:sub(-1) == "/" and "" or "/"
                    return self.icon .. self.cwd .. trail .. " "
                end,
            },
            {
                -- evaluates to the shortened path
                provider = function(self)
                    local cwd = vim.fn.pathshorten(self.cwd)
                    local trail = self.cwd:sub(-1) == "/" and "" or "/"
                    return self.icon .. cwd .. trail .. " "
                end,
            },
            {
                -- evaluates to "", hiding the component
                provider = "",
            },
        }
        local TerminalName = {
            -- we could add a condition to check that buftype == 'terminal'
            -- or we could do that later (see #conditional-statuslines below)
            provider = function()
                local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
                return " " .. tname
            end,
            hl = { fg = "blue", bold = true },
        }
        local HelpFileName = {
            condition = function()
                return vim.bo.filetype == "help"
            end,
            provider = function()
                local filename = vim.api.nvim_buf_get_name(0)
                return vim.fn.fnamemodify(filename, ":t")
            end,
            hl = { fg = "blue" },
        }

        vim.opt.showcmdloc = "statusline"
        local DropBar = { flexible = 3, dropbar, { provider = "" } }

        ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })
        local DefaultStatusline = {
            condition = function()
                return not (vim.bo.ft == "trouble" or vim.bo.ft == "edgy" or vim.bo.ft == "snacks_terminal" or vim.bo.ft == "yazi")
            end,
            ViMode,
            Space,
            WorkDir,
            Space,
            MyFileNameBlock,
            Space,
            Git,
            Space,
            Diagnostics,
            Space,
            DAPMessages,
            Align,
            LSPActive,
            Space,
            -- LSPMessages,
            Space,
            -- UltTest,
            Space,
            FileType,
            Space,
            Ruler,
            Space,
            ScrollBar,
        }
        local InactiveStatusline = {
            condition = function()
                return not (vim.bo.ft == "trouble" or vim.bo.ft == "edgy" or vim.bo.ft == "snacks_terminal" or vim.bo.ft == "yazi")
                    and conditions.is_not_active()
            end,
            FileType,
            Space,
            FileName,
            Align,
        }
        local SpecialStatusline = {
            condition = function()
                return conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive" },
                    }) and
                    (not (vim.bo.ft == "neotree" or vim.bo.ft == "yazi" or vim.bo.ft == "snacks_terminal" or vim.bo.ft == "edgy" or vim.bo.ft == "terminal"))
            end,

            FileType,
            Space,
            HelpFileName,
            Align,
        }
        local TerminalStatusline = {

            condition = function()
                return conditions.buffer_matches({ buftype = { "terminal" } }) and
                    not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
            end,

            hl = { bg = "dark_red" },

            -- Quickly add a condition to the ViMode to only show it when buffer is active!
            { condition = conditions.is_active, ViMode, Space },
            FileType,
            Space,
            TerminalName,
            Align,
        }
        local StatusLines = {

            hl = function()
                if conditions.is_active() then
                    return "StatusLine"
                else
                    return "StatusLineNC"
                end
            end,

            -- the first statusline with no condition, or which condition returns true is used.
            -- think of it as a switch case with breaks to stop fallthrough.
            fallthrough = false,
            SpecialStatusline,
            TerminalStatusline,
            InactiveStatusline,
            DefaultStatusline,
            static = {
                mode_colors_map = {
                    n = "red",
                    i = "green",
                    v = "cyan",
                    V = "cyan",
                    ["\22"] = "cyan",
                    c = "orange",
                    s = "purple",
                    S = "purple",
                    ["\19"] = "purple",
                    R = "orange",
                    r = "orange",
                    ["!"] = "red",
                    t = "green",
                },
                mode_color = function(self)
                    local mode = conditions.is_active() and vim.fn.mode() or "n"
                    return self.mode_colors_map[mode]
                end,
            },
        }
        local Spacer = { provider = " " }
        local function rpad(child)
            return {
                condition = child.condition,
                child,
                Spacer,
            }
        end
        local function OverseerTasksForStatus(status)
            return {
                condition = function(self)
                    return self.tasks[status]
                end,
                provider = function(self)
                    return string.format("%s%d", self.symbols[status], #self.tasks[status])
                end,
                hl = function(_)
                    return {
                        fg = utils.get_highlight(string.format("Overseer%s", status)).fg,
                    }
                end,
            }
        end

        local Overseer = {
            condition = function()
                return package.loaded.overseer
            end,
            init = function(self)
                local tasks = require("overseer.task_list").list_tasks({ unique = true })
                local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
                self.tasks = tasks_by_status
            end,
            static = {
                symbols = {
                    ["CANCELED"] = " ",
                    ["FAILURE"] = "󰅚 ",
                    ["SUCCESS"] = "󰄴 ",
                    ["RUNNING"] = "󰑮 ",
                },
            },

            rpad(OverseerTasksForStatus("CANCELED")),
            rpad(OverseerTasksForStatus("RUNNING")),
            rpad(OverseerTasksForStatus("SUCCESS")),
            rpad(OverseerTasksForStatus("FAILURE")),
        }
        local WinBars = {
            fallthrough = false,
            { -- A special winbar for terminals
                condition = function()
                    return conditions.buffer_matches({ buftype = { "terminal", "snacks_terminal" } })
                end,
                utils.surround({ "", "" }, "dark_red", {
                    FileType,
                    Space,
                    TerminalName,
                    Space,
                    Overseer,
                }),
            },
            { -- An inactive winbar for regular files
                condition = function()
                    return not conditions.is_active() and
                        not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
                end,
                utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, MyFileNameBlock }),
                {
                    condition = function()
                        return not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
                    end,
                    Space,
                    DropBar,
                }
            },
            {
                condition = function()
                    return not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
                end,
                -- A winbar for regular files
                utils.surround({ "", "" }, "bright_bg", MyFileNameBlock),
                {
                    condition = function()
                        return not (vim.bo.filetype == "yazi" or vim.bo.filetype == "snacks_terminal")
                    end,
                    Space,
                    DropBar
                }
            },
        }
        local TablineBufnr = {
            provider = function(self)
                return tostring(self.bufnr) .. ". "
            end,
            hl = "Comment",
        }

        -- we redefine the filename component, as we probably only want the tail and not the relative path
        local TablineFileName = {
            provider = function(self)
                -- self.filename will be defined later, just keep looking at the example!
                local filename = self.filename
                filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
                return filename
            end,
            hl = function(self)
                return { bold = self.is_active or self.is_visible, italic = true }
            end,
        }

        -- this looks exactly like the FileFlags component that we saw in
        -- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
        -- also, we are adding a nice icon for terminal buffers.
        local TablineFileFlags = {
            {
                condition = function(self)
                    return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
                end,
                provider = "[+]",
                hl = { fg = "green" },
            },
            {
                condition = function(self)
                    return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
                        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
                end,
                provider = function(self)
                    if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
                        return "  "
                    else
                        return ""
                    end
                end,
                hl = { fg = "orange" },
            },
        }

        -- Here the filename block finally comes together
        local TablineFileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(self.bufnr)
            end,
            hl = function(self)
                if self.is_active then
                    return "TabLineSel"
                    -- why not?
                elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
                    return { fg = "gray" }
                else
                    return "TabLine"
                end
            end,
            on_click = {
                callback = function(_, minwid, _, button)
                    if button == "m" then -- close on mouse middle click
                        vim.schedule(function()
                            vim.api.nvim_buf_delete(minwid, { force = false })
                        end)
                    else
                        vim.api.nvim_win_set_buf(0, minwid)
                    end
                end,
                minwid = function(self)
                    return self.bufnr
                end,
                name = "heirline_tabline_buffer_callback",
            },
            TablineBufnr,
            FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
            TablineFileName,
            TablineFileFlags,
        }

        -- a nice "x" button to close the buffer
        local TablineCloseButton = {
            condition = function(self)
                return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
            end,
            { provider = " " },
            {
                provider = "",
                hl = { fg = "gray" },
                on_click = {
                    callback = function(_, minwid)
                        vim.schedule(function()
                            vim.api.nvim_buf_delete(minwid, { force = false })
                            vim.cmd.redrawtabline()
                        end)
                    end,
                    minwid = function(self)
                        return self.bufnr
                    end,
                    name = "heirline_tabline_close_buffer_callback",
                },
            },
        }

        -- The final touch!
        local TablineBufferBlock = utils.surround({ "", "" }, function(self)
            if self.is_active then
                return utils.get_highlight("TabLineSel").bg
            else
                return utils.get_highlight("TabLine").bg
            end
        end, { TablineFileNameBlock, TablineCloseButton })

        -- this is the default function used to retrieve buffers
        local get_bufs = function()
            return vim.tbl_filter(function(bufnr)
                return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
            end, vim.api.nvim_list_bufs())
        end

        -- initialize the buflist cache
        local buflist_cache = {}

        -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
        vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
            callback = function()
                vim.schedule(function()
                    local buffers = get_bufs()
                    for i, v in ipairs(buffers) do
                        buflist_cache[i] = v
                    end
                    for i = #buffers + 1, #buflist_cache do
                        buflist_cache[i] = nil
                    end

                    -- check how many buffers we have and set showtabline accordingly
                    if #buflist_cache > 1 then
                        vim.o.showtabline = 2          -- always
                    elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
                        vim.o.showtabline = 1          -- only when #tabpages > 1
                    end
                end)
            end,
        })

        local BufferLine = utils.make_buflist(
            TablineBufferBlock,
            { provider = " ", hl = { fg = "gray" } },
            { provider = " ", hl = { fg = "gray" } },
            -- out buf_func simply returns the buflist_cache
            function()
                return buflist_cache
            end,
            -- no cache, as we're handling everything ourselves
            false
        )
        vim.keymap.set("n", "gbp", function()
            local tabline = require("heirline").tabline
            local buflist = tabline._buflist[1]
            buflist._picker_labels = {}
            buflist._show_picker = true
            vim.cmd.redrawtabline()
            local char = vim.fn.getcharstr()
            local bufnr = buflist._picker_labels[char]
            if bufnr then
                vim.api.nvim_win_set_buf(0, bufnr)
            end
            buflist._show_picker = false
            vim.cmd.redrawtabline()
        end)
        local Tabpage = {
            provider = function(self)
                return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
            end,
            hl = function(self)
                if not self.is_active then
                    return "TabLine"
                else
                    return "TabLineSel"
                end
            end,
        }

        local TabpageClose = {
            provider = "%999X  %X",
            hl = "TabLine",
        }

        local TabPages = {
            -- only show this component if there's 2 or more tabpages
            condition = function()
                return #vim.api.nvim_list_tabpages() >= 2
            end,
            { provider = "%=" },
            utils.make_tablist(Tabpage),
            TabpageClose,
        }
        local TabLineOffset = {
            condition = function(self)
                local win = vim.api.nvim_tabpage_list_wins(0)[1]
                local bufnr = vim.api.nvim_win_get_buf(win)
                self.winid = win
            end,

            provider = function(self)
                local title = self.title
                local width = vim.api.nvim_win_get_width(self.winid)
                local pad = math.ceil((width - #title) / 2)
                return string.rep(" ", pad) .. title .. string.rep(" ", pad)
            end,

            hl = function(self)
                if vim.api.nvim_get_current_win() == self.winid then
                    return "TablineSel"
                else
                    return "Tabline"
                end
            end,
        }
        local TabLine = { TabLineOffset, BufferLine, TabPages }

        -- Yep, with heirline we're driving manual!
        vim.o.showtabline = 2
        vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
        return {
            statusline = StatusLines,
            winbar = WinBars,
            tabline = TabLine,
            opts = {
                -- if the callback returns true, the winbar will be disabled for that window
                -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
                disable_winbar_cb = function(args)
                    return conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
                    }, args.buf)
                end,
            },
        }
    end,
}
