local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local FileType = {
    provider = function()
        return string.upper(vim.bo.filetype)
    end,
    hl = { fg = utils.get_highlight("Type").fg, bold = true },
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

local Space = { provider = " " }
local function rpad(child)
    return {
        condition = child.condition,
        child,
        Space,
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
    {         -- A special winbar for terminals
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
    {         -- An inactive winbar for regular files
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
        }
    },
}

return WinBars
