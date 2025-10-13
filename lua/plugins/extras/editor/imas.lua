return {
    "Old-Farmer/im-autoswitch.nvim",
    event = "LazyFile",
    opts = {
        cmd = {
            -- default im
            default_im = "1",
            -- get current im
            get_im_cmd = "fcitx5-remote",
            -- cmd to switch im. the plugin will put an im name in "{}"
            switch_im_cmd = "fcitx5-remote -t",
        },
    },
}
