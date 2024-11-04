return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  config = function()
    local gitsigns = require "gitsigns"
    local with_opts = require("utils").with_opts

    gitsigns.setup {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      on_attach = function(bufnr)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]g", function()
          if vim.wo.diff then
            vim.cmd.normal { "]g", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, with_opts "Next git change")

        map("n", "[g", function()
          if vim.wo.diff then
            vim.cmd.normal { "[g", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, with_opts "Prev git change")

        -- view with telescope, V for VCS
        local tele = require "telescope.builtin"
        map("n", "<leader>gvL", tele.git_bcommits, with_opts "git log (buffer)")
        map("n", "<leader>gvl", tele.git_commits, with_opts "git log (all)")
        map("n", "<leader>gvb", tele.git_branches, with_opts "git branches")
        map("n", "<leader>gvs", "<cmd>Neotree float git_status<cr>", with_opts "git status")

        -- Actions
        map("n", "<leader>gs", gitsigns.stage_hunk, with_opts "stage hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, with_opts "reset hunk")
        map(
          "v",
          "<leader>gs",
          function() gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end,
          with_opts "stage hunk"
        )
        map(
          "v",
          "<leader>gr",
          function() gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end,
          with_opts "reset hunk"
        )
        map("n", "<leader>gS", gitsigns.stage_buffer, with_opts "stage buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, with_opts "reset buffer")
        map("n", "<leader>gp", gitsigns.preview_hunk, with_opts "preview hunk")
        map("n", "<leader>gb", function() gitsigns.blame_line { full = false } end, with_opts "blame line")
        map("n", "<leader>gB", gitsigns.toggle_current_line_blame, with_opts "toggle blame")
        map("n", "<leader>gd", gitsigns.diffthis, with_opts "diff this")
        map("n", "<leader>gD", function() gitsigns.diffthis "~" end, with_opts "diff this")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    }
  end,
}
