return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      open_mapping = "<c-/>",
      direction = "float",
      float_opts = {
        border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
        title_pos = "left", -- 'left' | 'center' | 'right'
      },
    }

    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ff79c6", bg = "#282a36" })
  end,
}
