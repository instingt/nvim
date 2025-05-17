return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Allows extra capabilities provided by nvim-cmp
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(e)
          local builtin = require "telescope.builtin"
          local with_opts = require("utils").with_opts
          local function opts(desc) return vim.tbl_extend("force", { buffer = e.buf }, with_opts(desc)) end

          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts "Go to definition")
          vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts "Go to implementation")
          vim.keymap.set("n", "grr", function() vim.lsp.buf.references() end, opts "Find references")
          vim.keymap.set("n", "grn", function() vim.lsp.buf.rename() end, opts "Rename")
          vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts "Diagnostic float")
          vim.keymap.set("n", "<leader>ls", function() builtin.lsp_document_symbols() end, opts "Show document symbols")
          vim.keymap.set("n", "<leader>ld", function() builtin.diagnostics() end, opts "Diagnostic")
          vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts "Code action")
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts "LSP Hover")
          vim.keymap.set({ "n", "i" }, "<SC-K>", function() vim.lsp.buf.signature_help() end, opts "Signature help")
          vim.keymap.set("n", "[e", function() vim.diagnostic.jump { count = 1, float = true } end, opts "Next error")
          vim.keymap.set("n", "]e", function() vim.diagnostic.jump { count = 1, float = true } end, opts "Prev error")

          vim.lsp.handlers["textDocument/references"] = function(_, _, _) builtin.lsp_references() end
          vim.lsp.handlers["textDocument/implementation"] = function(_, _, _) builtin.lsp_implementations() end
          vim.lsp.buf.hover {
            border = "single",
            focus = true,
            focusable = true,
          }
          vim.lsp.buf.signature_help {
            border = "single",
            focus = false,
            focusable = false,
          }
        end,
      })
      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { Error = "", Warn = "", Hint = "", Info = "" }
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      -- enable fold
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        emmet_ls = {
          init_options = {
            usePlaceholders = true,
            showExpandedSnippets = true,
            emmetExpandCompletion = true,
            html = {
              options = {
                ["bem.enabled"] = true,
                ["jsx.enabled"] = true,
                ["jsx.selfClosingStyle"] = "html",
              },
            },
          },
        },
        gopls = {
          capabilities = capabilities,
          single_file_support = true,
          settings = {
            gopls = {
              usePlaceholders = false,
              completeFunctionCalls = false,
              symbolScope = "all",
              symbolStyle = "dynamic",
              symbolMatcher = "fastfuzzy",
              importShortcut = "both",
              hoverKind = "FullDocumentation", -- or "SynopsisDocumentation", "SingleLine"
              completeUnimported = true,
              experimentalPostfixCompletions = true,
              staticcheck = true,
              gofumpt = true,
              diagnosticsDelay = "1s",
              diagnosticsTrigger = "Edit",
              analysisProgressReporting = true,
              codelenses = {
                tidy = true,
                generate = true,
                upgrade_dependency = true,
              },
              semanticTokens = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
                unusedvariable = true,
                assign = true,
                atomic = true,
                bools = true,
                composites = true,
                copylocks = true,
                defers = true,
                deprecated = true,
                directive = true,
                embed = true,
                errorsas = true,
                fillreturns = true,
                httpresponse = true,
                ifaceassert = true,
                infertypeargs = true,
                loopclosure = true,
                lostcancel = true,
                nilfunc = true,
                nilness = true,
                nonewvars = true,
                noresultvalues = true,
                printf = true,
                shadow = false, -- MAYBE NOT
                shift = true,
                sigchanyzer = true,
                simplifycompositelit = true,
                simplifyrange = true,
                simplifyslice = true,
                sortslice = true,
                stdmethods = true,
                stringintconv = true,
                structtag = true,
                testinggoroutine = true,
                tests = true,
                timeformat = true,
                unmarshal = true,
                unreachable = true,
                unsafeptr = true,
                unusedresult = true,
                unusedwrite = true,
                useany = true,
              },
            },
          },
        },
        angularls = {
          root_dir = function(fname)
            local lspconfig = require "lspconfig"

            return lspconfig.util.root_pattern("angular.json", "nx.json", ".git")(fname)
          end,
        },
        clangd = {},
        nil_ls = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      -- extend Mason audoinstall with formatters
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "prettierd",
      })

      -- extend Masson  autoinstall with linters
      vim.list_extend(ensure_installed, {
        "eslint_d",
      })

      -- Masson install
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      local function on_attach(client, bufrn)
        -- Enable navic if the server supports document symbols
        if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, bufrn) end
      end

      require("mason-lspconfig").setup {
        ensure_installed = {},
        automatic_installation = {},
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            server.on_attach = on_attach

            require("lspconfig")[server_name].setup(server)
          end,
        },
      }

      require("typescript-tools").setup {
        on_attach = on_attach,
        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = "insert_leave",
          -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
          -- "remove_unused_imports"|"organize_imports") -- or string "all"
          -- to include all supported code actions
          -- specify commands exposed as code_actions
          expose_as_code_action = { "all" },
          -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
          -- not exists then standard path resolution strategy is applied
          tsserver_path = nil,
          -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
          -- (see 💅 `styled-components` support section)
          tsserver_plugins = {},
          -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
          -- memory limit in megabytes or "auto"(basically no limit)
          tsserver_max_memory = "auto",
          -- described below
          tsserver_format_options = {},
          tsserver_file_preferences = {},
          -- locale of all tsserver messages, supported locales you can find here:
          -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
          tsserver_locale = "en",
          -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
          complete_function_calls = false,
          include_completions_with_insert_text = true,
          -- CodeLens
          -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
          -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          code_lens = "off",
          -- by default code lenses are displayed on all referencable values and for some of you it can
          -- be too much this option reduce count of them by removing member references from lenses
          disable_member_code_lens = true,
          -- JSXCloseTag
          -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
          -- that maybe have a conflict if enable this feature. )
          jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      }
    end,
  },
  {
    -- Linter
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"
      local with_opts = require("utils").with_opts

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }

      -- fuck unpredictable plugins!!!!! (╯°□°)╯︵ ┻━┻
      local disable_plubin_args = {
        "--rule",
        "file-progress/activate: 0",
      }
      lint.linters.eslint_d.args = disable_plubin_args

      -- disbale eslint when config not found
      -- lint.linters.eslint_d.cmd = function()
      local function has_eslint_config()
        local config_files = { ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json" }
        for _, config_file in ipairs(config_files) do
          if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. config_file) == 1 then return true end
        end
        return false
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          if has_eslint_config() then lint.try_lint() end
        end,
      })

      vim.keymap.set("n", "<leader>ll", function() lint.try_lint() end, with_opts "Lint file")
    end,
  },
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function() require("conform").format { async = true, lsp_format = "fallback" } end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        -- local disable_filetypes = { c = true, cpp = true }
        local disable_filetypes = {}
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = "never"
        else
          lsp_format_opt = "fallback"
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        html = { "prettierd", "eslint_d" },
        css = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        nix = { "nixfmt" },
      },
    },
  },

  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then return end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      "saadparwaiz1/cmp_luasnip",

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind.nvim",
    },
    config = function()
      -- See `:help cmp`
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      luasnip.config.setup {}
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        -- idea like suggest
        completion = { completeopt = "menu,menuone,noinsert" },

        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = require("lspkind").cmp_format {
            mode = "symbol", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
            menu = {
              nvim_lsp = nil,
            },
          },
        },

        mapping = cmp.mapping.preset.insert {
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm {
                  select = true,
                }
              end
            else
              fallback()
            end
          end),
          ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<s-tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.close()
            else
              fallback()
            end
          end),
          ["<c-k>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<c-j>"] = cmp.mapping.select_next_item(cmp_select),
          ["<c-b>"] = cmp.mapping.scroll_docs(-4),
          ["<c-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete {},
        },
        sources = {
          {
            name = "lazydev",
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = "luasnip", priority = 9999, option = { show_autosnippets = true } },
          { name = "nvim_lsp_signature_help", priority = 400 }, -- function signatures
          { name = "nvim_lsp", priority = 300 },
          { name = "buffer", priority = 200 },
          { name = "path", priority = 100 },
          { name = "nvim_lsp_signature_help" },
          { name = "vim-dadbod-completion" },
        },
      }
    end,
  },
  -- typescript
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
}
