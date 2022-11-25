local M = {}

function M.setup()
    -- Indicate first time installation
    local packer_bootstrap = false

    -- packer.nvim configuration
    local conf = {
        display = {
            open_fn = function()
                return require("packer.util").float {border = "rounded"}
            end
        }
    }

    -- Check if packer.nvim is installed
    -- Run PackerCompile if there are changes in this file
    local function packer_init()
        local fn = vim.fn
        local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
        if fn.empty(fn.glob(install_path)) > 0 then
            packer_bootstrap =
                fn.system {
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path
            }
            vim.cmd [[packadd packer.nvim]]
        end
        vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
    end

    -- Plugins
    local function plugins(use)
        -- Package manager
        use { "wbthomason/packer.nvim" }
        use { "williamboman/mason.nvim" }

        -- Themes
        use {
            "navarasu/onedark.nvim",
            config = function()
                vim.cmd "colorscheme onedark"
            end
        }
        use {"folke/tokyonight.nvim"}

        -- Formatting
        use {
            "ntpeters/vim-better-whitespace",
            config = function()
                require("config.better-whitespace").setup()
            end
        }

        -- Status line
        use {
            "nvim-lualine/lualine.nvim",
            requires = { "nvim-tree/nvim-web-devicons", opt = true }
        }

        -- File explorer
        use {
			"preservim/nerdtree",
            requires = "ryanoasis/vim-devicons",
            config = function()
                require("config.nerdtree").setup()
            end
        }
		use {
			"kevinhwang91/rnvimr",
			config = function()
				require("config.ranger").setup()
			end,
		}
        use {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.0",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("config.telescope").setup()
            end
        }

        -- git
        use {
            "TimUntersberger/neogit",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("config.neogit").setup()
            end
        }

        -- Greeter
        use {
            "goolord/alpha-nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = function()
                require("config.alpha").setup()
            end
        }

        -- Help
        use {
            "folke/which-key.nvim",
            config = function()
                require("config.whichkey").setup()
            end
        }

        if packer_bootstrap then
            print "Restart Neovim required after installation!"
            require("packer").sync()
        end
    end

    packer_init()

    local packer = require "packer"
    packer.init(conf)
    packer.startup(plugins)
end

return M
