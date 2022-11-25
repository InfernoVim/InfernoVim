local M = {}

function M.setup()
    local status_ok, alpha = pcall(require, "alpha")
    if not status_ok then
		return
    end

    local dashboard = require "alpha.themes.dashboard"

    local function header()
	return {
		[[           (]],
		[[ (         )\ )    (   (                 )   (      )]],
		[[ )\   (   (()/(   ))\  )(    (      (   /((  )\    (]],
		[[((_)  )\ ) /(_)) /((_)(()\   )\ )   )\ (_))\((_)   )\  ']],
		[[ (_) _(_/((_) _|(_))   ((_) _(_/(  ((_)_)((_)(_) _((_))]],
		[[ | || ' \))|  _|/ -_) | '_|| ' \))/ _ \\ V / | || '  \()]],
		[[ |_||_||_| |_|  \___| |_|  |_||_| \___/ \_/  |_||_|_|_|]],
		[[                          ...]],
		[['The truth always carries the ambiguity of the words]],
		[[ used to express it']],
		[[                   -- Frank Herbert, God Emperor of Dune]],
	}
    end

    dashboard.section.header.val = header()

    dashboard.section.buttons.val = {
        dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("F", "  Find hidden file", ":Telescope find_files hidden=true <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  Projects", ":Telescope find_files <CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep<CR>"),
        dashboard.button("c", "  Configuration", ":NERDTree Neovim <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
    }

    local function footer()
		-- Number of plugins
		local total_plugins = #vim.tbl_keys(packer_plugins)
		local datetime = os.date "%d-%m-%Y  %H:%M:%S"
		local plugins_text = "\t" .. total_plugins .. " plugins  " .. datetime

		-- Quote
		-- local fortune = require("alpha.fortune")
		-- local quote = table.concat(fortune(), "\n")

		-- return plugins_text .. "\n" .. quote
		return plugins_text
	end

    dashboard.section.footer.val = footer()

    dashboard.section.footer.opts.hl = "Constant"
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Function"
    dashboard.section.buttons.opts.hl_shortcut = "Type"
    dashboard.opts.opts.noautocmd = true

    alpha.setup(dashboard.opts)
end

return M
