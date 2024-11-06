local with_opts = require("utils").with_opts

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- no hightling after search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- exit insert mode in terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", with_opts "Exit terminal insert mode")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", with_opts "Move focus to the left window")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", with_opts "Move focus to the right window")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", with_opts "Move focus to the lower window")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", with_opts "Move focus to the upper window")

vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", with_opts "Close file")
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", with_opts "Close file")
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", with_opts "Save file")
vim.keymap.set("n", "<leader>W", "<cmd>wa<cr><cmd>qa<cr>", with_opts "Save file")
