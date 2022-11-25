local M = {}

function M.setup()
    local status_ok, telescope = pcall(require, "telescope")
    if not status_ok then
		return
    end
end

return M
