return {
	{
		"folke/tokyonight.nvim",
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
		priority = 1000,
		build = ":CatppuccinCompile",
		enabled = true,
		opts = {
			flavour = "auto",
			background = { light = "latte", dark = "macchiato" },
			transparent_background = true,
			float = { transparent = true, solid = true },
			term_colors = true,
			custom_highlights = function(C)
				local O = require("catppuccin").options
				return {
					["@module"] = { fg = C.lavender, style = O.styles.miscs or { "italic" } },
					["@type.builtin"] = { fg = C.yellow, style = O.styles.properties or { "italic" } },
				}
			end,
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			integrations = {
				bufferline = false,
				cmp = true,
				diffview = true,
				fidget = true,
				gitsigns = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				lsp_trouble = true,
				mason = true,
				neotree = true,
				noice = true,
				notify = true,
				rainbow_delimiters = true,
				telescope = true,
				treesitter_context = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-nvim")
		end,
	},
}
