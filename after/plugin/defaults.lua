local g = vim.g
local o = vim.o
local opt = vim.opt

-- Neovide
if vim.fn["exists"]("g:neovide") then
	opt.guifont = "JetBrainsMono Nerd Font:h7.5"
end

-- Leader key
g.mapleader = " "
g.maplocalleader = " "

-- Formatting
o.tabstop=4
o.shiftwidth=4

-- Required for bufferline and nerd tree idk
opt.termguicolors = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Mouse mode
opt.mouse = "a" -- Enable mouse mode

-- Text search
opt.hlsearch = true -- Highlight on search
opt.ignorecase = true

-- Access system clipboard
opt.clipboard = "unnamedplus"

-- Change how long it takes for whichkey to appear
opt.timeoutlen = 300
