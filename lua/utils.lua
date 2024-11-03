local M = {}
-- custom keymaps
M.with_opts = function(s)
	local ta = { noremap = true, silent = true }
	if s ~= "" then
		ta["desc"] = s
	end
	return ta
end

return M
