return {
    "j-hui/fidget.nvim",
    opts = {
        progress = {
            suppress_on_insert = false,
            ignore_empty_message = false,
            display = {
                render_limit = 25,
                done_ttl = 6,
            },
        },
        notification = {
            override_vim_notify = true,
            view = {
                stack_upwards = false,
            },
            window = {
                align = "top",
            }
        },
    },
}
