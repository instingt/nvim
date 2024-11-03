vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
}

vim.keymap.set("n", "<Leader>o", "<cmd>Neotree filesystem reveal float<cr>", {})
vim.keymap.set("n", "<Leader>e", "<cmd>Neotree toggle left<cr>", {})

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        tabs_layout = "active",
        add_blank_line_at_top = false,
        use_popups_for_input = false,
        popup_border_style = "single",
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        source_selector = {
            winbar = false,
            statusline = false,
            sources = {
                { source = "filesystem" },
                { source = "git_status" },
                { source = "document_symbols" },
            },
        },
        default_component_configs = {
            name = {
                trailing_slash = true,
            },
            modified = {
                symbol = "",
                highlight = "NeoTreeModified",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "",
                default = "",
            },
            git_status = {
                symbols = {
                    added     = "+",
                    modified  = "",
                    deleted   = "",
                    renamed   = "",
                    -- Status type
                    untracked = "",
                    ignored   = "",
                    unstaged  = "",
                    staged    = "+",
                    conflict  = "",
                },
            },
        },
        filesystem = {
            group_empty_dirs = true,
            follow_current_file = {
                enabled = false,         -- This will find and focus the file in the active buffer every time
                leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            },
            filtered_items = {
                visible = true,
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    --".DS_Store",
                    --"thumbs.db"
                },
            },
        },
        document_symbols = {
            follow_cursor = true,
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
        },
        commands = {
            system_open = function(state)
                (vim.ui.open)(state.tree:get_node():get_id())
            end,

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
                    else                           -- if expanded and has children, seleect the next child
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
        }
    },
}
