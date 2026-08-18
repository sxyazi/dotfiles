local icons = {
	Keyword = "󰌋",
	Operator = "󰆕",

	Text = "",
	Value = "󰎠",
	Constant = "󰏿",

	Method = "",
	Function = "󰊕",
	Constructor = "",

	Class = "",
	Interface = "",
	Module = "",

	Variable = "",
	Property = "󰜢",
	Field = "󰜢",

	Struct = "󰙅",
	Enum = "",
	EnumMember = "",

	Snippet = "",

	File = "",
	Folder = "",

	Reference = "󰈇",
	Event = "",
	Color = "",
	Unit = "󰑭",
	TypeParameter = "",
}

return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				vim.schedule(function() require("luasnip.loaders.from_vscode").lazy_load() end)
			end,
		},
		lazy = true,
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		"zbirenbaum/copilot.lua",
		build = ":Copilot auth",
		cmd = "Copilot",
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = false,
					prev = "<M-[>",
					next = "<M-]>",
					dismiss = false,
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
				svn = true,
				["."] = true,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			vim.keymap.set("i", "<Tab>", function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, { silent = true })
		end,
	},

	{
		"saghen/blink.cmp",
		build = function() require("blink.cmp").build():pwait() end,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"saghen/blink.lib",
			"L3MON4D3/LuaSnip",
		},
		opts = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show" },
				["<C-u>"] = { "select_prev", "fallback" },
				["<C-e>"] = { "select_next", "fallback" },
				["<M-u>"] = { "scroll_documentation_up", "fallback" },
				["<M-e>"] = { "scroll_documentation_down", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			appearance = { kind_icons = icons },
			completion = {
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				menu = {
					border = "rounded",
					draw = {
						columns = { { "kind_icon" }, { "label" } },
						components = {
							label = { width = { max = 30 } },
						},
					},
				},
				documentation = {
					window = { border = "rounded" },
				},
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = { fallbacks = {} },
					buffer = {
						min_keyword_length = function(ctx) return ctx.mode == "cmdline" and 2 or 0 end,
					},
					path = {
						min_keyword_length = function(ctx) return ctx.mode == "cmdline" and 2 or 0 end,
					},
					cmdline = {
						min_keyword_length = function(ctx) return ctx.mode == "cmdline" and 2 or 0 end,
					},
				},
			},
			cmdline = {
				keymap = {
					preset = "none",
					["<Tab>"] = {
						function(cmp)
							if cmp.is_menu_visible() then
								return cmp.select_and_accept()
							end
							return cmp.show_and_insert_or_accept_single()
						end,
						"fallback",
					},
					["<S-Tab>"] = {
						function(cmp)
							if cmp.is_menu_visible() then
								return cmp.select_prev()
							end
							return cmp.show_and_insert_or_accept_single { initial_selected_item_idx = -1 }
						end,
						"fallback",
					},
				},
				sources = { default = { "buffer", "path", "cmdline" } },
				completion = {
					menu = { auto_show = true },
				},
			},
			fuzzy = { implementation = "rust" },
		},
	},

	{
		"kylechui/nvim-surround",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_filetype = { "TelescopePrompt", "vim" },
			check_ts = true,
			enable_check_bracket_line = true,
			fast_wrap = {
				chars = { "{", "(", "[", "<", '"', "'", "`" },
			},
		},
		-- TODO: remove this block when https://github.com/windwp/nvim-autopairs/pull/363 is merged
		config = function(opts)
			local autopairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			autopairs.setup(opts)
			autopairs.add_rules {
				Rule("<", ">"):with_pair(cond.before_regex("%a+")):with_move(function(o) return o.char == ">" end),
			}
		end,
		-- END TODO
	},
	{
		"nvim-mini/mini.comment",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				opts = { enable_autocmd = false },
			},
		},
		keys = {
			{ "<leader>c", nil, mode = { "n", "o", "x" } },
		},
		opts = {
			options = {
				ignore_blank_line = true,
				custom_commentstring = function()
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
			mappings = {
				comment = "<leader>c",
				comment_line = "<leader>c",
				comment_visual = "<leader>c",
				textobject = "<leader>c",
			},
		},
	},

	{
		"mg979/vim-visual-multi",
		keys = {
			{ "<C-k>", nil, mode = { "n", "v" } },
			{ "<C-m>", nil, mode = { "n", "v" } },
		},
		init = function()
			vim.g.VM_default_mappings = 0
			vim.g.VM_maps = {
				-- Select
				["Find Under"] = "<C-k>",
				["Find Subword Under"] = "<C-k>",
				["Add Cursor Down"] = "<C-m>",
				["Select All"] = "<leader>a",
				["Goto Next"] = "-",
				["Goto Prev"] = "=",
				["Skip Region"] = "q",
				["Remove Region"] = "Q",

				-- Insert mode
				["A"] = "<C-i>",
				["i"] = "k",
				["I"] = "<C-n>",
				["o"] = "m",
				["O"] = "M",

				-- Undo and Redo
				["Undo"] = "l",
				["Redo"] = "L",

				-- Keymap conflict
				["Find Next"] = "",
				["Find Prev"] = "",

				-- Fix the issue where the first item is skipped when pressing `<C-k>`
				-- https://github.com/mg979/vim-visual-multi/issues/243#issuecomment-1965536044
				["I BS"] = "",
			}
			vim.g.VM_custom_motions = {
				["u"] = "k",
				["e"] = "j",
				["n"] = "h",
				["N"] = "0",
				["i"] = "l",
				["I"] = "$",
				["h"] = "e",
			}
		end,
	},

	-- Switch between single-line and multiline forms of code
	{
		"Wansmer/treesj",
		keys = {
			{ "j", ":TSJSplit<CR>", silent = true },
			{ "J", ":TSJJoin<CR>", silent = true },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			use_default_keymaps = false,
			max_join_length = 999,
		},
	},

	-- Incremental LSP renaming based on Neovim's command-preview feature
	{
		"smjonas/inc-rename.nvim",
		keys = {
			{
				"<leader>r",
				function() return ":IncRename " .. vim.fn.expand("<cword>") end,
				silent = true,
				expr = true,
			},
		},
		opts = {
			preview_empty_name = true,
		},
	},

	-- Sorting plugin that supports line-wise and delimiter sorting
	{
		"sQVe/sort.nvim",
		keys = {
			{ "go", ":Sort<CR>", mode = "n", silent = true },
			{ "go", "<Esc>:Sort<CR>", mode = "v", silent = true },
		},
	},

	-- Generate sharable file permalinks (with line ranges) for git host websites
	{
		"ruifm/gitlinker.nvim",
		keys = {
			{
				"<leader>p",
				':lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>',
				mode = "n",
				silent = true,
			},
			{
				"<leader>p",
				':lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>',
				mode = "v",
				silent = true,
			},
		},
		config = function()
			require("gitlinker").setup {
				mappings = nil,
			}
		end,
	},
}
