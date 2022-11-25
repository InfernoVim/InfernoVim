local M = {}

function M.setup()
	local status_ok, alpha = pcall(require, "better-whitespace")
	if not status_ok then
		return
	end
end

return M
