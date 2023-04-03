return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		enabled = false,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		build = ":CatppuccinCompile",
		enabled = true,
		opts = {
			flavour = "macchiato",
			background = { light = "latte", dark = "macchiato" },
			transparent_background = true,
			term_colors = true,
			custom_highlights = function(C)
				return {
					TreesitterContext = { bg = C.mantle, fg = C.text },
				}
			end,
			integrations = {
				bufferline = false,
				cmp = true,
				fidget = true,
				gitsigns = true,
				illuminate = true,
				lsp_saga = true,
				lsp_trouble = true,
				markdown = true,
				mason = true,
				neotree = true,
				noice = false,
				notify = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				ts_rainbow2 = true,
				dap = { enabled = true, enable_ui = true },
				indent_blankline = { enabled = true },
				native_lsp = { enabled = true },
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
