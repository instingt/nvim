local M = {}

local function git_branch()
  local branch = vim.fn.system "git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'"
  if string.len(branch) > 0 then
    return branch
  else
    return "[no git]"
  end
end

local function colorize(s, colorn) return string.format("%%%d*%s%%*", colorn, s) end

local function work_dir()
  -- :t truncates the given CWD to a last segment,
  -- which is often used as a project name.
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

--
local macro = ""

local function status_line()
  -- local bufferNumber  = "#%n"
  local gitBranch = git_branch()
  local workdir = work_dir()
  local fileFullPath = "%<%f"
  local modifiedFlag = " %m"
  local readonlyFlag = " %r"
  local lineInfo = "%5l/%L%* %p%%"
  local cmdLine = "%S" -- show cmdline content in statusline
  local filetype = "%y"

  local aligner = "%="
  local leftSeparator = " :: "

  return table.concat({
    " ",
    colorize(workdir, 0),
    leftSeparator,
    colorize(gitBranch, 0),
    leftSeparator,
    colorize(fileFullPath, 0),
    colorize(modifiedFlag, 0),
    colorize(readonlyFlag, 0),
    aligner,
    " ",
    macro,
    " ",
    cmdLine,
    colorize(filetype, 0),
    colorize(lineInfo, 0),
    " ",
  }, "")
end

function M.setup()
  local group = vim.api.nvim_create_augroup("status-line-hooks", {})
  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    group = group,
    callback = function(ctx)
      if ctx.event == "RecordingEnter" then macro = "recording @" .. vim.fn.reg_recording() end
      if ctx.event == "RecordingLeave" then macro = "@" .. vim.fn.reg_recording() end

      -- redraw status line with updated macros status
      vim.opt.statusline = status_line()
    end,
  })

  -- move status line from separate line to a statusline
  -- (%S in the status_line() function)
  vim.opt.cmdheight = 0
  vim.opt.laststatus = 3
  vim.opt.showcmdloc = "statusline"
  vim.opt.statusline = status_line()
end

return M
