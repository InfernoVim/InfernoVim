local M = {}

function M.setup()
    local status_ok, whichkey = pcall(require, "which-key")
	if not status_ok then
	    return
	end

	local whichkey = require "which-key"

	local conf = {
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
		},
	}

	local opts = {
		mode = "n", -- Normal mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
	}

	local mappings = {
    	["q"] = { "<cmd>qa <CR>", "Quit" },

    	w = {
      		name = "Window",
      		h = { "<cmd>wincmd h <CR>", "Left" },
      		j = { "<cmd>wincmd j <CR>", "Up" },
      		k = { "<cmd>wincmd k <CR>", "Down" },
      		l = { "<cmd>wincmd l <CR>", "Right" },
      		q = { "<cmd>q <CR>", "Close" },
    	},

    	g = {
      		name = "Git",
			s = { "<cmd>Telescope git_status <CR>", "Status" },
			c = { "<cmd>Telescope git_commits <CR>", "Commits" },
			b = { "<cmd>Telescope git_branches <CR>", "Branches" },
			n = { "<cmd>Neogit <CR>", "Neogit" },
    	},

		f = {
			name = "File",
			w = { "<cmd>w <CR>", "Write" },
			f = { "<cmd>Telescope find_files <CR>", "Find files" },
			F = { "<cmd>Telescope find_files hidden=true <CR>", "Find hidden files" },
		},

		h = {
			name = "Help",
			k = { "<cmd>Telescope keymaps <CR>", "Keymaps" },
			c = { "<cmd>Telescope colorscheme <CR>", "Colourscheme" },
			C = { "<cmd>Telescope commands <CR>", "Commands" },
			h = { "<cmd>Telescope help_tags <CR>", "Help search" },
		},

		e = {
			name = "Explorer",
			f = { "<cmd>NERDTreeFocus <CR>", "NERDTree" },
			t = { "<cmd>NERDTreeToggle <CR>", "Toggle NERDTree" },
			r = { "<cmd>RnvimrToggle <CR>", "Ranger" },
		},

		l = {
			name = "LSP",
		},

		p = {
			name = "Packer",
			c = { "<cmd>PackerCompile <CR>", "Compile" },
			i = { "<cmd>PackerInstall <CR>", "Install" },
			s = { "<cmd>PackerSync <CR>", "Sync" },
			S = { "<cmd>PackerStatus <CR>", "Status" },
			u = { "<cmd>PackerUpdate <CR>", "Update" },
		},

		d = {
			name = "Debug",
		},
  	}

	whichkey.setup(conf)
	whichkey.register(mappings, opts)
end

return M
