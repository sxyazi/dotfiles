require("core")
require("keymap")
require("window")
require("terminal")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"health",
				"man",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"nvim",
				"rplugin",
				"shada",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

local commands = require("lazy.view.config").commands
commands.install = nil
commands.update = nil
commands.clean = nil
commands.check = nil
commands.restore.button = false
commands.help = nil

require("editconfig")
