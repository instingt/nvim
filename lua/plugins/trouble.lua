return {
    {
        "folke/trouble.nvim",
        config = function()
            local with_opts = require('utils').with_opts
            require("trouble").setup({})

            vim.keymap.set("n", "[t", function()
                require("trouble").next({ skip_groups = true, jump = true });
            end, with_opts("Next trouble"))

            vim.keymap.set("n", "]t", function()
                require("trouble").previous({ skip_groups = true, jump = true });
            end, with_opts("Next trouble"))
        end
    },
}
