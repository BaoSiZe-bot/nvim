return {
    {
        "smartinellimarco/nvcheatsheet.nvim",
        keys = {
            {
                "<f1>",
                function()
                    require("nvcheatsheet").toggle()
                end,
                mode = { "n", "i", "x" },
                desc = "Cheat Sheet",
            },
        },
        opts = {
            header = {
                "                                      ",
                "                                      ",
                "                                      ",
                "█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀",
                "█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░",
                "                                      ",
                "                                      ",
                "                                      ",
            },
        },
    },
    {
        "nvzone/showkeys",
        cmd = "ShowkeysToggle",
        opts = {
            timeout = 1,
            maxkeys = 8,
            -- more opts
        },
    },
    "nvzone/volt",
    {
        "nvzone/minty",
        cmd = { "Shades", "Huefy" },
    },
    {
        "nvzone/timerly",
        cmd = "TimerlyToggle",
    },
    {
        "nvzone/menu",
        event = "VeryLazy",
        keys = {
            {
                "<C-t>",
                function()
                    require("menu").open("default")
                end,
                mode = { "n", "i", "x" },
                desc = "Menu",
            },
        },
        config = function()
            vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
                require("menu.utils").delete_old_menus()

                vim.cmd.exec('"normal! \\<RightMouse>"')

                -- clicked buf
                local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
                local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

                require("menu").open(options, { mouse = true })
            end, {})
        end,
    },
    {
        "nvzone/typr",
        opts = {},
        cmd = { "Typr", "TyprStats" },
    },
    {
        "m-demare/hlargs.nvim",
        event = "LspAttach",
        opts = {},
    },
    {
        "rainbowhxch/beacon.nvim",
        event = "CursorMoved",
        cond = function()
            -- Don't load in neovide
            return not vim.g.neovide
        end,
    },
    {
        "dstein64/nvim-scrollview",
        event = "UIEnter",
    },
    {
        "soulis-1256/eagle.nvim",
        event = "LspAttach",
        opts = {
            --override the default values found in config.lua
        },
    },
    {
        "Fildo7525/pretty_hover",
        event = "LspAttach",
        opts = {},
    },
    {
        "notomo/gesture.nvim",
        config = function()
            vim.keymap.set("n", "<RightDrag>", [[<Cmd>lua require("gesture").draw()<CR>]], { silent = true })
            vim.keymap.set("n", "<RightRelease>", [[<Cmd>lua require("gesture").finish()<CR>]], { silent = true })

            local gesture = require("gesture")
            gesture.register({
                name = "scroll to bottom",
                inputs = { gesture.up(), gesture.down() },
                action = "normal! G",
            })
            gesture.register({
                name = "next buffer",
                inputs = { gesture.up(), gesture.right() },
                action = "bnext",
            })
            gesture.register({
                name = "previous buffer",
                inputs = { gesture.up(), gesture.left() },
                action = function(_) -- also can use callable
                    vim.cmd.bprevious()
                end,
            })
            gesture.register({
                name = "go back",
                inputs = { gesture.right(), gesture.left() },
                -- map to `<C-o>` keycode
                action = function()
                    vim.api.nvim_feedkeys(vim.keycode("<C-o>"), "n", true)
                end,
            })
            gesture.register({
                name = "close buffer",
                inputs = { gesture.left(), gesture.right() },
                action = function()
                    require("snacks").bufdelete()
                end,
            })
            gesture.register({
                name = "close buffer",
                inputs = { gesture.down(), gesture.right() },
                action = function()
                    require("snacks").bufdelete()
                end,
            })
            gesture.register({
                name = "close gesture traced windows",
                match = function(ctx)
                    local last_input = ctx.inputs[#ctx.inputs]
                    return last_input and last_input.direction == "UP"
                end,
                can_match = function(ctx)
                    local first_input = ctx.inputs[1]
                    return first_input and first_input.direction == "RIGHT"
                end,
                action = function(ctx)
                    table.sort(ctx.window_ids, function(a, b)
                        return a > b
                    end)
                    for _, window_id in ipairs(ctx.window_ids) do
                        if vim.api.nvim_win_is_valid(window_id) then
                            vim.api.nvim_win_close(window_id, false)
                        end
                    end
                end,
            })
        end,
    },
}
