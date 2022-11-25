local M = {}

function M.setup()
	local keymap = vim.api.nvim_set_keymap
	local default_opts = { noremap = true, silent = true }
	local expr_opts = { noremap = true, expr = true, silent = true }

	-- Better escape using jk in insert and terminal mode
	keymap("i", "jk", "<ESC>", default_opts)
	keymap("t", "jk", "<C-\\><C-n>", default_opts)

	-- Center search results
	keymap("n", "n", "nzz", default_opts)
	keymap("n", "N", "Nzz", default_opts)

	-- Cancel search highlighting with ESC
	keymap("n", "<ESC>", ":nohlsearch <Bar> :echo <CR>", default_opts)

	-- Better indent
	keymap("v", "<", "<gv", default_opts)
	keymap("v", ">", ">gv", default_opts)

	-- Paste over currently selected text without yanking it
	keymap("v", "p", '"_dP', default_opts)

	-- Move selected line / block of text in visual mode
	keymap("v", "K", ":move '<-2 <CR> gv-gv", default_opts)
	keymap("v", "J", ":move '>+1 <CR> gv-gv", default_opts)

	-- Switch buffer
	keymap("n", "<S-h>", ":bprevious<CR>", default_opts)
	keymap("n", "<S-l>", ":bnext<CR>", default_opts)

	-- Resizing panes
	keymap("n", "<Left>", ":vertical resize +1 <CR>", default_opts)
	keymap("n", "<Right>", ":vertical resize -1 <CR>", default_opts)
	keymap("n", "<Up>", ":resize -1 <CR>", default_opts)
	keymap("n", "<Down>", ":resize +1 <CR>", default_opts)

	-- Tabs
	keymap("n", "<C-Tab>", ":tabNext <CR>", default_opts)
	keymap("n", "<S-Tab>", ":tabprevious <CR>", default_opts)
	keymap("n", "<C-t>", ":tabnew <CR>", default_opts)
	keymap("n", "<S-t>", ":tabclose <CR>", default_opts)
end

return M
