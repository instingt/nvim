vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.showmode = false

vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

vim.opt.breakindent = true
vim.opt.undofile = true

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv "HOME" .. "/.cache/nvim/undodir"
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.termguicolors = true -- enabl 24-bit RGB color in the TUI

vim.opt.showmode = false -- we are experienced, wo don't need the '-- INSERT --' mode hint
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right

vim.opt.confirm = true -- confirm write instead of error
vim.opt.visualbell = false -- no visual bell
vim.opt.errorbells = false
vim.opt.synmaxcol = 300 -- Text after this column is not highlightedim.opt.showtabline = 0
