return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip"
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = 'Replace',
                                },
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            preselect = cmp.PreselectMode.None,
            formatting = {
                fields = { "abbr", "kind", },
            },
            completion = {
                -- auto-select the first option, expand by <CR>
                -- Intellij-like behaviour.
                completeopt = "menu,menuone,noinsert",
            },
            view = {
                -- native vindows are compact and minimalistic
                entries = { name = "custom" },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm { select = true },
                ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
            }),
            sources = cmp.config.sources({
                {
                    name = 'lazydev',
                    -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                    group_index = 0,
                },
                { name = 'luasnip',                 priority = 9999, option = { show_autosnippets = true } },
                { name = 'nvim_lsp_signature_help', priority = 400 }, -- function signatures
                { name = 'nvim_lsp',                priority = 300 },
                { name = 'buffer',                  priority = 200 },
                { name = 'path',                    priority = 100 },
            }),
            enable = function()
                -- disable completion in comments
                local context = require 'cmp.config.context'
                return not context.in_treesitter_capture("comment")
                    and not context.in_syntax_group("Comment")
                    and not context.in_syntax_group("TSComment")
            end,
        })

        vim.diagnostic.config({
            virtual_text = true,
            update_in_insert = true,
            float = {
                focusable = false,
                scope = "line", -- or "cursor" to show only hovered
                border = "single",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
