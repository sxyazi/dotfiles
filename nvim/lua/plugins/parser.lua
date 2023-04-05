local M = {
	ts_langs = {
		-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
		"bash",
		"c",
		"cmake",
		"comment",
		"cpp",
		"css",
		"dart",
		"diff",
		"dockerfile",
		"fish",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"gomod",
		"gosum",
		"gowork",
		"graphql",
		"html",
		"ini",
		"java",
		"javascript",
		"json",
		"json5",
		"jsonc",
		"kdl",
		"latex",
		"lua",
		"luap",
		"make",
		"markdown",
		"markdown_inline",
		"nix",
		"php",
		"pug",
		"python",
		"regex",
		"ruby",
		"rust",
		"scss",
		"smali",
		"sql",
		"svelte",
		"swift",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vue",
		"yaml",
		"zig",
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"HiPhish/nvim-ts-rainbow2",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = M.ts_langs,
				highlight = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<Enter>",
						node_incremental = "<Enter>",
						node_decremental = "<S-Enter>",
						scope_incremental = false,
					},
				},
				indent = { enable = true },

				autotag = { enable = true },
				context_commentstring = { enable = true, enable_autocmd = false },
				rainbow = { enable = true, strategy = require("ts-rainbow.strategy.local") },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_end = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_previous_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
						goto_next_start = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
						},
					},
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/scripts/minimal_init.lua#L41
							["af"] = "@function.outer",
							["kf"] = "@function.inner",
							["ab"] = "@block.outer",
							["kb"] = "@block.inner",
							["aa"] = "@parameter.outer",
							["ka"] = "@parameter.inner",
							["ac"] = "@comment.outer",
						},
						include_surrounding_whitespace = true,
					},
				},
			}
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
}
