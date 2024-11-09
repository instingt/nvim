return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      flavour = "macchiato",
      default_integrations = false,
      integrations = {
        cmp = true,
        neotree = true,
        gitsigns = true,
        treesitter = true,
        telescope = true,
        navic = {
          enabled = true,
          custom_bg = "NONE",
        },
        harpoon = true,
        which_key = true,
      },
    }

    vim.cmd.colorscheme "catppuccin-macchiato"
  end,
}
