return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local notify = require("fidget")
        local with_opts = require('utils').with_opts

        harpoon:extend({
            -- notify with a number when file added
            ADD = function(ctx)
                notify.notify("harpoon: " .. ctx.item.value .. " added.", nil,
                    { group = "harpoon", annote = "key: " .. ctx.idx })
            end,
        })

        vim.api.nvim_create_autocmd('VimLeavePre', {
            -- cleanup on exit
            callback = function()
                harpoon:list():clear()
            end
        })

        harpoon:setup()

        vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, with_opts("Add to harpoon"))
        vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            with_opts("Harpoon list"))

        vim.keymap.set("n", "<Leader>1", function() harpoon:list():select(1) end, with_opts('Open Harpoon 1'))
        vim.keymap.set("n", "<Leader>2", function() harpoon:list():select(2) end, with_opts('Open Harpoon 2'))
        vim.keymap.set("n", "<Leader>3", function() harpoon:list():select(3) end, with_opts('Open Harpoon 3'))
        vim.keymap.set("n", "<Leader>4", function() harpoon:list():select(4) end, with_opts('Open Harpoon 4'))
        vim.keymap.set("n", "<Leader>5", function() harpoon:list():select(5) end, with_opts('Open Harpoon 5'))
        vim.keymap.set("n", "<Leader>6", function() harpoon:list():select(6) end, with_opts('Open Harpoon 6'))
        vim.keymap.set("n", "<Leader>7", function() harpoon:list():select(7) end, with_opts('Open Harpoon 7'))

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "H", function() harpoon:list():prev() end)
        vim.keymap.set("n", "L", function() harpoon:list():next() end)
    end
}
