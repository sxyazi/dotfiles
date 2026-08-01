local M = {
	ts_langs = {
		-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
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
		"typescriptreact",
		"vim",
		"vue",
		"yaml",
		"zig",
	},
}

local function set_textobject_keymaps()
	local move = require("nvim-treesitter-textobjects.move")
	local select = require("nvim-treesitter-textobjects.select")

	vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_end("@parameter.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_end("@function.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_end("@class.outer", "textobjects") end)

	vim.keymap.set({ "n", "x", "o" }, "[A", function() move.goto_previous_end("@parameter.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)

	vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)

	vim.keymap.set({ "n", "x", "o" }, "]A", function() move.goto_next_start("@parameter.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_start("@function.outer", "textobjects") end)
	vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_start("@class.outer", "textobjects") end)

	vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
	vim.keymap.set({ "x", "o" }, "kf", function() select.select_textobject("@function.inner", "textobjects") end)
	vim.keymap.set({ "x", "o" }, "ab", function() select.select_textobject("@block.outer", "textobjects") end)
	vim.keymap.set({ "x", "o" }, "kb", function() select.select_textobject("@block.inner", "textobjects") end)
	vim.keymap.set({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end)
	vim.keymap.set({ "x", "o" }, "ka", function() select.select_textobject("@parameter.inner", "textobjects") end)
	vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@comment.outer", "textobjects") end)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = function() require("nvim-treesitter").install(M.ts_langs, { summary = true }):wait() end,
		dependencies = {
			{ "windwp/nvim-ts-autotag", opts = {} },
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
				config = function()
					require("nvim-treesitter-textobjects").setup {
						move = { set_jumps = true },
						select = { lookahead = true, include_surrounding_whitespace = true },
					}
					set_textobject_keymaps()
				end,
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
				pattern = M.ts_langs,
				callback = function(args)
					if vim.api.nvim_buf_line_count(args.buf) > 5000 then
						return
					end

					vim.treesitter.start(args.buf)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					-- Incremental selection
					vim.keymap.set({ "n", "x" }, "<CR>", function() vim.treesitter.select("parent") end, { buffer = args.buf })
					vim.keymap.set({ "n", "x" }, "<S-CR>", function() vim.treesitter.select("child") end, { buffer = args.buf })
				end,
			})
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

	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			layout = {
				default_direction = "prefer_left",
			},
			keymaps = {
				["<C-v>"] = false,
				["<Tab>"] = "actions.jump",
			},
		},
		keys = {
			{ "<leader>u", "<cmd>AerialToggle<CR>" },
		},
	},

	-- VSCode-style diff
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		opts = {
			diff = {
				layout = "inline",
				ignore_trim_whitespace = true,
				compute_moves = true,
			},
			keymaps = {
				view = {
					toggle_explorer = false,
					toggle_layout = "<leader>t",
					toggle_stage = false,
					stage_hunk = "<leader>s",
					unstage_hunk = "<leader>S",
					discard_hunk = "<leader>r",
				},
				explorer = {
					select = "<Tab>",
					unstage_all = false,
					restore = false,
				},
			},
		},
	},
}
