return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "yavorski/lualine-lsp-client-name.nvim" },
  },
  config = function()
    local filename = {
      "filename",
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
    }

    local hide_in_width = function() return vim.fn.winwidth(0) > 100 end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      colored = false,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      "diff",
      colored = false,
      symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
      cond = hide_in_width,
    }

    local lsp_status = {
      "lsp_client_name",
      cond = hide_in_width,
    }

    local function project() return vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end
    local function isRecording()
      local reg = vim.fn.reg_recording()
      if reg == "" then return "" end -- not recording
      return "recording to " .. reg
    end

    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = "catppuccin", -- Set theme based on environment variable
        -- Some useful glyphs:
        -- https://www.nerdfonts.com/cheat-sheet
        --        
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "neo-tree" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "branch" },
        lualine_b = { project, filename },
        lualine_c = { isRecording },
        lualine_x = {
          lsp_status,
          diagnostics,
          diff,
          { "encoding", cond = hide_in_width },
          { "filetype", cond = hide_in_width },
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { { "location", padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    }
    -- set opts to imrove look and feel
    vim.opt.cmdheight = 0 -- set cmd line height to 0; cmd line will be replaced lualine while command being writing
    vim.opt.showcmdloc = "statusline" -- set cmd line in place of statusline where placed lualine
  end,
}
