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
			float = { transparent = true, solid = true },
			term_colors = true,
			custom_highlights = function(C)
				local O = require("catppuccin").options
				return {
					["@module"] = { fg = C.lavender, style = O.styles.miscs or { "italic" } },
					["@type.builtin"] = { fg = C.yellow, style = O.styles.properties or { "italic" } },
					["@property"] = { fg = C.lavender, style = O.styles.properties or {} },
				}
			end,
			integrations = {
				bufferline = false,
				cmp = true,
				fidget = true,
				gitsigns = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				lsp_trouble = true,
				markdown = true,
				mason = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				neotree = true,
				noice = true,
				notify = true,
				rainbow_delimiters = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
