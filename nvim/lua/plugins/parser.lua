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
		"ron",
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
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = M.ts_langs,
				highlight = {
					enable = true,
					disable = function(lang, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 5000 end,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						node_decremental = "<S-CR>",
						scope_incremental = false,
					},
				},
				indent = { enable = true },
				autotag = { enable = true },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_end = {
							["]a"] = "@parameter.outer",
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_previous_end = {
							["[A"] = "@parameter.outer",
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
						},
						goto_previous_start = {
							["[a"] = "@parameter.outer",
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
						goto_next_start = {
							["]A"] = "@parameter.outer",
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
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

	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local rainbow = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
					html = "rainbow-tags",
					javascript = "rainbow-delimiters-react",
				},
				strategy = {
					[""] = rainbow.strategy["global"],
					vim = rainbow.strategy["local"],
				},
			}
		end,
	},
}
