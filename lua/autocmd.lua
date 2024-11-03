vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local augroup = vim.api.nvim_create_augroup
local the_autoformat_group = augroup('the_autoformat_group', {})
local autocmd = vim.api.nvim_create_autocmd
local with_opts = require('utils').with_opts


autocmd('LspAttach', {
    group = the_autoformat_group,
    callback = function(e)
        local tele = require("telescope.builtin")

        function opts(desc)
            return vim.tbl_extend("force", { buffer = e.buf }, with_opts(desc))
        end

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts('Go to definition'))
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts('Go to implementation'))
        vim.keymap.set("n", "grr", function() vim.lsp.buf.references() end, opts('Find references'))
        vim.keymap.set("n", "grn", function() vim.lsp.buf.rename() end, opts('Rename'))
        vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts('Diagnostic float'))
        vim.keymap.set("n", "<leader>ls", function() tele.lsp_document_symbols() end, opts('Show document symbols'))
        vim.keymap.set("n", "<leader>ld", function() tele.diagnostics() end, opts('Diagnostic'))
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts('Code action'))
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, opts('Format buffer'))
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts('LSP Hover'))
        vim.keymap.set("n", "<SC-K>", function() vim.lsp.buf.signature_help() end, opts('Signature help'))
        vim.keymap.set("n", "[e", function() vim.diagnostic.goto_next() end, opts('Next error'))
        vim.keymap.set("n", "]e", function() vim.diagnostic.goto_prev() end, opts('Prev error'))

        vim.lsp.handlers["textDocument/references"] = function(_, _, _)
            tele.lsp_references()
        end
        vim.lsp.handlers["textDocument/implementation"] = function(_, _, _)
            tele.lsp_implementations()
        end
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
                border = "single",
                focus = false,
                focusable = true,
            }
        )
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
                border = "single",
                focus = false,
                focusable = false,
            }
        )
    end
})

autocmd("BufWritePre", {
    group = the_autoformat_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd("BufWritePre", {
    group = the_autoformat_group,
    pattern = "*",
    callback = function()
        vim.lsp.buf.format()
    end,
})
