vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

local augroup = vim.api.nvim_create_augroup
local the_autoformat_group = augroup("the_autoformat_group", {})
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
  group = the_autoformat_group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
