return {
    "mbbill/undotree",

    config = function()
        local with_opts = require('utils').with_opts
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, with_opts("Undo tree"))
    end
}
