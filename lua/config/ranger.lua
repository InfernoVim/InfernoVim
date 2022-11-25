local M = {}
local opt = vim.opt

function M.setup()
	local status_ok, ranger = pcall(require, "rnvimr")
	if not status_ok then
		return
	end

	vim.api.nvim_exec([[let g:rnvimr_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd'
            \ }]])
end

return M
