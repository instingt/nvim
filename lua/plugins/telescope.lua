return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        sorting_strategy = "ascending",
        results_title = false,
        layout_strategy = "horizontal",
        anchor = "CENTER",
        layout_config = {
          prompt_position = "top",
          width = 0.94,
          height = 0.94,
        },
        mappings = {
          i = {
            ['<C-j>'] = 'move_selection_next',
            ['<C-k>'] = 'move_selection_previous',
          }
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    local with_opts = require('utils').with_opts

    vim.keymap.set('n', '<leader>fh', builtin.help_tags, with_opts('Find Help'))
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, with_opts('Find Keymaps'))
    vim.keymap.set('n', '<leader>ff', builtin.find_files, with_opts('Find Files'))
    --       vim.keymap.set("n", "<C-o>", function()
    --             local ok, _ = pcall(builtin.git_files)
    --             if not ok then
    --                 builtin.find_files()
    --             end
    --       end, with_opts('Find files'))
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, with_opts('Live grep'))
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, with_opts('Find Diagnostics'))
    vim.keymap.set('n', '<leader>fr', builtin.resume, with_opts('Find Resume'))
    vim.keymap.set('n', '<leader>fb', builtin.buffers, with_opts('Find existing buffers'))
    vim.keymap.set("n", "<leader>fF", function()
      builtin.find_files({ hidden = true })
    end, with_opts('Find all files'))
    vim.keymap.set("n", "<leader>fW", function()
      require("telescope").extensions.live_grep_args.live_grep_args({
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--no-ignore", -- added this, the rest above are defaults
        },
      })
    end, with_opts('Global live grep'))
  end,
}
