return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				vim.schedule(function() require("luasnip.loaders.from_vscode").lazy_load() end)
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		lazy = true,
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
					accept = "<Tab>",
					prev = "<M-[>",
					next = "<M-]>",
					dismiss = "<C-w>",
				},
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-path",

			-- For luasnip users
			"saadparwaiz1/cmp_luasnip",

			-- Vscode-like completion popup
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup {
				preselect = cmp.PreselectMode.None,
				mapping = {
					["<C-w>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-u>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
					["<C-e>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
					["<C-n>"] = cmp.mapping.scroll_docs(-4),
					["<C-i>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm { select = true },
				},
				snippet = {
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = require("lspkind").cmp_format {
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
					},
				},
				experimental = { ghost_text = true },
			}

			local mapping = {
				["<C-w>"] = {
					c = cmp.mapping.abort(),
				},
				["<Tab>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.select_next_item()
					else
						cmp.complete()
					end
				end, { "c" }),
				["<S-Tab>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.select_prev_item()
					else
						cmp.complete()
					end
				end, { "c" }),
			}

			-- Use buffer source for `/` and `?`
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = mapping,
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				sources = {
					{ name = "buffer", keyword_length = 2 },
				},
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(":", {
				mapping = mapping,
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				sources = cmp.config.sources({
					{ name = "cmdline", keyword_length = 2 },
				}, {
					{ name = "path", keyword_length = 3 },
				}),
			})
		end,
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
		},
	},
	{
		"echasnovski/mini.comment",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		keys = {
			{ "<leader>c", nil, mode = { "n", "o", "x" } },
		},
		opts = {
			mappings = {
				comment = "<leader>c",
				comment_line = "<leader>c",
				textobject = "<leader>c",
			},
			hooks = {
				pre = function() require("ts_context_commentstring.internal").update_commentstring {} end,
			},
		},
		config = function(_, opts) require("mini.comment").setup(opts) end,
	},

	-- Switch between single-line and multiline forms of code
	{
		"Wansmer/treesj",
		keys = {
			{ "j", ":TSJJoin<CR>",  silent = true },
			{ "J", ":TSJSplit<CR>", silent = true },
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
			input_buffer_type = "dressing",
		},
	},

	-- LSP signature hint as you type
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			-- noice = false,
			fix_pos = true,
			hint_enable = false,
			handler_opts = {
				border = "rounded",
			},
		},
	},
}
