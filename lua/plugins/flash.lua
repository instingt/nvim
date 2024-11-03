return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        search = {
            -- search/jump in all windows
            multi_window = false,
        },
        jump = {
            -- save location in the jumplist
            jumplist = false,
            -- automatically jump when there is only one match
            autojump = true,
        },
        label = {
            rainbow = {
                enabled = false,
                shade = 5, -- number between 1 and
            },
        },
        prompt = {
            enabled = false,
        },
        modes = {
            search = { enabled = true },
        },
    },
    keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
}
