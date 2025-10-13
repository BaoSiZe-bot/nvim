return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "User FilePost",
    priority = 1919810,     -- needs to be loaded in first
    opts = {
        preset = "modern",
        -- transparent_bg = true,
        -- transparent_cursorline = true, -- Set the background of the cursorline to transparent (only one the first diagnostic)
        options = {
            virt_texts = {
                priority = 8192,
            },
            show_source = {
                enabled = true,
                if_many = true,
            },
            use_icons_from_diagnostic = true,
            multiple_diag_under_cursor = true,
            multilines = {
                enabled = true,
                always_show = true,
            },
            show_all_diags_on_cursorline = true,
            enable_on_insert = true,
            enable_on_select = true,
            break_line = {
                enabled = true,
                after = 80,
            },
            format = function(diagnostic)
                return diagnostic.source .. ": " .. diagnostic.message
            end,
        },
    },
}
