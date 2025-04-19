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

autocmd("BufEnter", {
  desc = "Open Neotree on startup with directory",
  callback = function()
    if package.loaded["neo-tree"] then
      return true
    else
      local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
      if stats and stats.type == "directory" then
        require("lazy").load { plugins = { "neo-tree.nvim" } }
        return true
      end
    end
  end,
})

autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
  desc = "disable search hightling on cursor move",
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function() vim.cmd.nohlsearch() end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  pattern = "*",
  desc = "don't close nvim on last buffer delete",
  callback = function()
    if #vim.fn.getbufinfo { buflisted = 1 } == 1 and not package.loaded["neo-tree"] then vim.cmd "enew" end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.go",
  callback = function() vim.lsp.codelens.refresh() end,
})
