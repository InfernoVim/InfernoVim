local g = vim.g

local M = {}

function M.setup()
	-- disable netrw at the very start of your init.lua (strongly advised)
	g.loaded_netrw = 1
	g.loaded_netrwPlugin = 1

	-- Start NERDTree when Vim starts with a directory argument.
	vim.api.nvim_exec([[ autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif ]], false)
end

return M
