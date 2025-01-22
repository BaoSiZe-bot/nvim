return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        dashboard = {
            enabled = true,
            preset = {
                -- pick = function(cmd, opts)
                --     return LazyVim.pick(cmd, opts)()
                -- end,
                header = [[
         (   )              (   )                                 .-.                 
  .---.   | |.-.     .---.   | |    .--.    ___ .-.    ___  ___  ( __)  ___ .-. .-.   
 / .-, \  | /   \   / .-, \  | |   /    \  (   )   \  (   )(   ) (''") (   )   '   \  
(__) ; |  |  .-. | (__) ; |  | |  |  .-. ;  |  .-. .   | |  | |   | |   |  .-.  .-. ; 
  .'`  |  | |  | |   .'`  |  | |  | |  | |  | |  | |   | |  | |   | |   | |  | |  | | 
 / .'| |  | |  | |  / .'| |  | |  | |  | |  | |  | |   | |  | |   | |   | |  | |  | | 
| /  | |  | |  | | | /  | |  | |  | |  | |  | |  | |   | |  | |   | |   | |  | |  | | 
; |  ; |  | '  | | ; |  ; |  | |  | '  | |  | |  | |   ' '  ; '   | |   | |  | |  | | 
' `-'  |  ' `-' ;  ' `-'  |  | |  '  `-' /  | |  | |    \ `' /    | |   | |  | |  | | 
`.__.'_.   `.__.   `.__.'_. (___)  `.__.'  (___)(___)    '_.'    (___) (___)(___)(___)
                ]],
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
        },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = false }, -- we set this in options.lua
        -- toggle = { map = LazyVim.safe_keymap_set },
        words = { enabled = true },
    },
    -- stylua: ignore
    keys = {
        { "<leader>n", function() require('snacks').notifier.show_history() end, desc = "Notification History" },
        { "<leader>un", function() require('snacks').notifier.hide() end, desc = "Dismiss All Notifications" },
    },
}
