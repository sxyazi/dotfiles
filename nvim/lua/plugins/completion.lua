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
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-calc",

			-- For luasnip users
			"saadparwaiz1/cmp_luasnip",

			-- Vscode-like completion popup
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local mapping = {
				["<C-w>"] = cmp.mapping.abort(),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-u>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
						if not cmp.get_selected_entry() then
							cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
						end
					else
						fallback()
					end
				end, { "i", "c" }),
				["<C-e>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if not cmp.get_selected_entry() then
							cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
						end
						cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
						if not cmp.get_selected_entry() then
							cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
						end
					else
						fallback()
					end
				end, { "i", "c" }),
				-- ["<C-n>"] = cmp.mapping.scroll_docs(-4),
				-- ["<C-i>"] = cmp.mapping.scroll_docs(4),
				["<Tab>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.confirm { select = true }
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						vim.api.nvim_feedkeys("\t", "n", false)
					end
				end, { "i", "c" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "c" }),
			}

			cmp.setup {
				preselect = cmp.PreselectMode.None,
				mapping = mapping,
				snippet = {
					expand = function(args) luasnip.lsp_expand(args.body) end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "calc" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = lspkind.cmp_format {
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
					},
				},
				experimental = { ghost_text = true },
			}

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = mapping,
				sources = {
					{ name = "buffer", keyword_length = 2 },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = mapping,
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
