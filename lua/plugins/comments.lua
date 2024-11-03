local with_opts = require('utils').with_opts

return {
    'numToStr/Comment.nvim',
    config = function()
        local c = require("Comment")
        c.setup()

        vim.keymap.set("n", "<Leader>/", function()
                return require("Comment.api").call(
                    "toggle.linewise." .. (vim.v.count == 0 and "current" or "count_repeat"),
                    "g@$"
                )()
            end,
            with_opts("Toggle comment"))

        vim.keymap.set("x", "<Leader>/",
            "<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>",
            with_opts("Toggle comment"))
    end
}
