local Terminal = require("toggleterm.terminal").Terminal

local function is_lazygit_installed() return vim.fn.executable "lazygit" == 1 end

if is_lazygit_installed() then
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    float_opts = {
      width = function() return math.floor(vim.o.columns * 0.9) end,
      height = function() return math.floor(vim.o.lines * 0.9) end,
    },
  }

  ---@diagnostic disable-next-line: lowercase-global
  function _lazygit_toggle() lazygit:toggle() end

  vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
else
  ---@diagnostic disable-next-line: lowercase-global
  function _notify() vim.notify("Lazygit should be install. Plase install it to use lazygit integration", vim.log.ERROR) end

  vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _notify()<CR>", { noremap = true, silent = true })
end
