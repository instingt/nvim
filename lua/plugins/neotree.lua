-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<Leader>o", ":Neotree filesystem reveal float<CR>" },
    { "<Leader>e", ":Neotree toggle left<CR>" },
  },
  opts = {
    close_if_last_window = true,
    tabs_layout = "active",
    add_blank_line_at_top = false,
    use_popups_for_input = false,
    popup_border_style = "single",
    auto_clean_after_session_restore = true,

    default_component_configs = {
      name = {
        trailing_slash = true,
      },
    },

    source_selector = {
      winbar = false,
      statusline = false,
      sources = {
        { source = "filesystem" },
        { source = "git_status" },
        { source = "document_symbols" },
      },
    },

    filesystem = {
      group_empty_dirs = true,
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
            vim.opt_local.foldcolumn = "0"
          end,
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      filtered_items = {
        visible = true,
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
      },
      hijack_netrw_behavior = "open_current",
    },
    window = {
      position = "left",
      width = 34,
      mappings = {
        ["<Space>"] = false,
        ["<S-CR>"] = "system_open",
        O = "system_open",
        ["h"] = "parent_or_close",
        ["l"] = "child_or_open",
        ["a"] = "add",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gu"] = "git_unstage_file",
        ["gc"] = "git_commit",
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        ["<C-J>"] = "move_cursor_down",
        ["<C-K>"] = "move_cursor_up",
      },
    },
    commands = {
      system_open = function(state) (vim.ui.open)(state.tree:get_node():get_id()) end,

      parent_or_close = function(state)
        local node = state.tree:get_node()
        if node:has_children() and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,

      child_or_open = function(state)
        local node = state.tree:get_node()
        if node:has_children() then
          if not node:is_expanded() then -- if unexpanded, expand
            state.commands.toggle_node(state)
          else -- if expanded and has children, seleect the next child
            if node.type == "file" then
              state.commands.open(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          end
        else -- if has no children
          state.commands.open(state)
        end
      end,
    },
  },
}
