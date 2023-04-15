return {
	-- Status
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = "catppuccin",
				globalstatus = true,
				ignore_focus = {
					"dapui_watches",
					"dapui_stacks",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dap-repl",
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = {
					function()
						local loc = require("lualine.components.location")()
						local sel = require("lualine.components.selectioncount")()
						if sel ~= "" then
							loc = loc .. " (" .. sel .. " sel)"
						end
						return loc
					end,
				},
			},
			extensions = { "neo-tree" },
		},
	},

	-- Notification manager for NeoVim
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			background_colour = "#000000",
		},
	},

	-- Completely replaces the UI for messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			{ "MunifTanjim/nui.nvim", lazy = true },
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
			views = {
				mini = {
					win_options = { winblend = 0 },
				},
			},
			routes = {
				{
					view = "notify",
					filter = {
						event = "msg_show",
						kind = { "echo" },
					},
					opts = { skip = true },
				},
				{
					view = "notify",
					filter = {
						event = "msg_show",
						kind = "",
						any = {
							-- Save
							{ find = " bytes written" },

							-- Redo/Undo
							{ find = " changes; before #" },
							{ find = " changes; after #" },
							{ find = "1 change; before #" },
							{ find = "1 change; after #" },

							-- Yank
							{ find = " lines yanked" },

							-- Bulk edit
							{ find = " fewer lines" },
							{ find = " more lines" },
							{ find = "1 more line" },
							{ find = "1 line less" },

							-- General messages
							{ find = "Already at newest change" },
							{ find = "Already at oldest change" },
							{ find = "E21: Cannot make changes, 'modifiable' is off" },
						},
					},
					opts = { skip = true },
				},
				{
					view = "mini",
					filter = {
						any = {
							{ find = "formatting" },
							{ find = "Diagnosing" },
							{ find = "Diagnostics" },
						},
					},
					opts = { skip = true },
				},
			},
		},
	},

	-- Improve the default `vim.ui` interfaces
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load { plugins = { "dressing.nvim" } }
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load { plugins = { "dressing.nvim" } }
				return vim.ui.input(...)
			end
		end,
		opts = {
			input = {
				insert_only = false,
				win_options = { winblend = 0 },
				mappings = {
					n = {
						["<CR>"] = "Confirm",
						["<Esc>"] = "Close",
						["<C-w>"] = "Close",
					},
					i = {
						["<CR>"] = "Confirm",
						["<C-w>"] = "Close",
						["<C-u>"] = "HistoryPrev",
						["<C-e>"] = "HistoryNext",
					},
				},
			},
			select = {
				builtin = {
					win_options = { winblend = 0 },
					mappings = {
						["<CR>"] = "Confirm",
						["<Esc>"] = "Close",
						["<C-w>"] = "Close",
					},
				},
			},
		},
	},

	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			{ "nvim-lua/plenary.nvim",       lazy = true },
			{ "nvim-tree/nvim-web-devicons", lazy = true },
			{ "MunifTanjim/nui.nvim",        lazy = true },
		},
		keys = {
			{ "<leader>1", ":Neotree toggle<CR>", silent = true },
			{ "<leader>v", ":Neotree reveal<CR>", silent = true },
		},
		init = function() vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]]) end,
		opts = {
			popup_border_style = "rounded",
			sort_case_insensitive = true,
			sort_function = function(a, b)
				if a.type == b.type then
					return a.path < b.path
				else
					return a.type < b.type
				end
			end,
			use_popups_for_input = false,
			use_default_mappings = false,
			-- ...source_selector...
			event_handlers = {
				{
					event = "after_render",
					handler = function()
						local state = require("neo-tree.sources.manager").get_state_for_window()
						if state == nil then
							return
						end
						if not require("neo-tree.sources.common.preview").is_active() then
							state.config = { use_float = false }
							state.commands.toggle_preview(state)
						end
					end,
				},
				{
					event = "neo_tree_window_before_close",
					handler = function() require("neo-tree.sources.common.preview").hide() end,
				},
			},
			window = {
				mappings = {
					["<Tab>"] = function(state)
						local node = state.tree:get_node()
						if require("neo-tree.utils").is_expandable(node) then
							state.commands.toggle_node(state)
						else
							state.commands.focus_preview()
						end
					end,
					["<CR>"] = function(state)
						state.commands.open(state)

						if state.commands.clear_filter and state.search_pattern then
							local fs = require("neo-tree.sources.filesystem")
							local node = state.tree:get_node()
							fs.reset_search(state, false, false)
							fs.navigate(state, state.path, node:get_id(), function() require("neo-tree").close_all() end)
						else
							require("neo-tree").close_all()
						end
					end,
					["a"] = "add",
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["R"] = "refresh",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["s"] = "prev_source",
					["S"] = "next_source",
					["z"] = "close_all_subnodes",
					["Z"] = "close_all_nodes",
					-- TODO
					-- ["s"] = "open_vsplit",
					-- ["S"] = "open_split",
					-- ["t"] = "open_tabnew",
					-- ["w"] = "open_with_window_picker",
				},
			},
			filesystem = {
				group_empty_dirs = true,
				follow_current_file = true,
				use_libuv_file_watcher = true,
				window = {
					mappings = {
						["."] = "set_root",
						["<BS>"] = "navigate_up",
						["/"] = "filter_on_submit",
						["<Esc>"] = "clear_filter",
						["h"] = "toggle_hidden",
						["m"] = "next_git_modified",
						["M"] = "prev_git_modified",
					},
				},
			},
			buffers = {
				window = {
					mappings = {
						["."] = "set_root",
						["<BS>"] = "navigate_up",
						["d"] = "buffer_delete",
					},
				},
			},
			git_status = {
				window = {
					mappings = {
						["a"] = "git_add_file",
						["A"] = "git_add_all",
						["l"] = "git_unstage_file",
						["r"] = "git_revert_file",
						["c"] = "git_commit",
						["C"] = "git_commit_and_push",
						["p"] = "git_push",
					},
				},
			},
		},
	},

	-- Fuzz finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim",                    lazy = true },

			-- Install a native sorter, for better performance
			{ "nvim-telescope/telescope-fzf-native.nvim", lazy = true },
		},
		keys = {
			{ "<leader><leader>", function() require("telescope.builtin").oldfiles { only_cwd = true } end },
			{ "<leader>/",        function() require("telescope.builtin").live_grep() end },
			{ "<leader>;",        function() require("telescope.builtin").command_history() end },
			{
				"<leader>e",
				function() require("telescope.builtin").find_files() end,
			},
			{ ",a", function() require("telescope.builtin").buffers() end },
		},
		config = function()
			local actions = require("telescope.actions")
			local trouble = require("trouble.providers.telescope")
			local extr_args = {
				"--hidden", -- Search hidden files that are prefixed with `.`
				"--no-ignore", -- Don’t respect .gitignore
				"-g",
				"!.git/",
				"-g",
				"!go.sum",
				"-g",
				"!lazy-lock.json",
			}

			local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }
			for i = 1, #extr_args do
				vimgrep_arguments[#vimgrep_arguments + 1] = extr_args[i]
			end

			require("telescope").setup {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					mappings = {
						-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L133
						i = {
							["<C-u>"] = actions.cycle_history_prev,
							["<C-e>"] = actions.cycle_history_next,
							["<M-u>"] = actions.preview_scrolling_up,
							["<M-e>"] = actions.preview_scrolling_down,
							["<C-s>"] = actions.select_vertical,
							["<C-S-s>"] = actions.select_horizontal,
							["<C-t>"] = actions.select_tab,
							["<C-S-t>"] = trouble.open_with_trouble,
						},
						n = {
							["u"] = actions.move_selection_previous,
							["e"] = actions.move_selection_next,
							["U"] = function(prompt_bufnr) require("telescope.actions.set").shift_selection(prompt_bufnr, -5) end,
							["E"] = function(prompt_bufnr) require("telescope.actions.set").shift_selection(prompt_bufnr, 5) end,
							["<C-u>"] = actions.cycle_history_prev,
							["<C-e>"] = actions.cycle_history_next,
							["<M-u>"] = actions.preview_scrolling_up,
							["<M-e>"] = actions.preview_scrolling_down,
							["s"] = actions.select_vertical,
							["S"] = actions.select_horizontal,
							["t"] = actions.select_tab,
							["T"] = trouble.open_with_trouble,
							["k"] = false, -- disable default keybinding
							["<Esc>"] = false, -- disable default keybinding
						},
					},
					vimgrep_arguments = vimgrep_arguments,
					buffer_previewer_maker = function(filepath, bufnr, opts)
						filepath = vim.fn.expand(filepath)
						vim.loop.fs_stat(filepath, function(_, stat)
							if not stat then
								return
							end
							if stat.size > 51200 then
								return
							end -- less than 50KiB

							require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
						end)
					end,
				},
				pickers = {
					find_files = {
						find_command = {
							"rg",
							"--color=never",
							"--smart-case",
							"--files",
							unpack(extr_args),
						},
					},
					live_grep = {
						only_sort_text = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			}

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("noice")
		end,
	},

	-- Manage LSP/DAP servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ui = {
				keymaps = {
					-- https://github.com/williamboman/mason.nvim/blob/main/lua/mason/settings.lua#L87
					toggle_package_expand = "<Tag>",
					install_package = "k",
					update_all_packages = "K",
					uninstall_package = "x",
					cancel_installation = "<C-c>",
					apply_language_filter = "<C-f>",
					update_package = "<Nop>",
					check_package_version = "<Nop>",
					check_outdated_packages = "<Nop>",
				},
			},
		},
	},

	-- Beautiful UIs for various LSP-related features, like hover doc
	{
		"glepnir/lspsaga.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "K",         ":Lspsaga hover_doc ++quiet ++keep<CR>", silent = true },
			{ "<C-Enter>", ":Lspsaga code_action<CR>",              mode = { "n", "v" }, silent = true },
			{ "<leader>l", ":Lspsaga lsp_finder<CR>",               silent = true },
			{ "<leader>b", ":Lspsaga goto_definition<CR>",          silent = true },
			{ "<leader>B", ":Lspsaga peek_definition<CR>",          silent = true },
			{ "<leader>m", ":Lspsaga goto_type_definition<CR>",     silent = true },
			{ "<leader>M", ":Lspsaga peek_type_definition<CR>",     silent = true },

			{
				"[;",
				function() require("lspsaga.diagnostic"):goto_prev { severity = vim.diagnostic.severity.ERROR } end,
				silent = true,
			},
			{
				"];",
				function() require("lspsaga.diagnostic"):goto_next { severity = vim.diagnostic.severity.ERROR } end,
				silent = true,
			},
		},
		opts = {
			ui = {
				kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
			},
			scroll_preview = {
				scroll_down = "<C-u>",
				scroll_up = "<C-e>",
			},
			request_timeout = 10000,
			finder = {
				keys = {
					expand_or_jump = "<Tab>",
					vsplit = "s",
					split = "S",
					tabe = "t",
					tabnew = "T",
					quit = { "<ESC>" },
					close_in_preview = "<ESC>",
				},
			},
			definition = {
				edit = "<CR>",
				vsplit = "s",
				split = "S",
				tabe = "t",
				quit = "<ESC>",
			},
			code_action = {
				keys = {
					quit = "<ESC>",
					exec = "<CR>",
				},
			},
			lightbulb = { sign = false },
			diagnostic = {
				keys = {
					exec_action = "<CR>",
					quit = "<ESC>",
					go_action = "<Tab>",
					expand_or_jump = "<Tab>",
					quit_in_show = { "<ESC>" },
				},
			},
			outline = {
				keys = {
					expand_or_collapse = "<Tab>",
					quit = "<ESC>",
				},
			},
			symbol_in_winbar = { enable = false },
		},
	},

	-- Find and replace with dark power
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		keys = {
			{ "<leader>f", function() require("spectre").open() end },
		},
		opts = {
			live_update = true,
			highlight = {
				search = "DiffDelete",
				replace = "DiffAdd",
			},
			mapping = {
				["toggle_line"] = {
					map = "<Tab>",
					cmd = ":lua require('spectre').toggle_line()<CR>",
				},
				["enter_file"] = {
					map = "<CR>",
					cmd = ":lua require('spectre.actions').select_entry()<CR>",
				},
				["send_to_qf"] = { map = "<Nop>" },
				["replace_cmd"] = { map = "<Nop>" },
				["show_option_menu"] = { map = "<Nop>" },
				["run_current_replace"] = {
					map = "r",
					cmd = ":lua require('spectre.actions').run_current_replace()<CR>",
				},
				["run_replace"] = {
					map = "R",
					cmd = ":lua require('spectre.actions').run_replace()<CR>",
				},
				["change_view_mode"] = {
					map = "v",
					cmd = ":lua require('spectre').change_view()<CR>",
				},
				["change_replace_sed"] = { map = "<Nop>" },
				["change_replace_oxi"] = { map = "<Nop>" },
				["toggle_live_update"] = { map = "<Nop>" },
				["toggle_ignore_case"] = {
					map = "tc",
					cmd = ":lua require('spectre').change_options('ignore-case')<CR>",
				},
				["toggle_ignore_hidden"] = {
					map = "th",
					cmd = ":lua require('spectre').change_options('hidden')<CR>",
				},
				["resume_last_search"] = {
					map = "l",
					cmd = ":lua require('spectre').resume_last_search()<CR>",
				},
			},
			is_insert_mode = true,
		},
	},

	-- A pretty list to show diagnostics, references, and quickfix results
	{
		"folke/trouble.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ ",e", ":TroubleToggle workspace_diagnostics<CR>", silent = true },
			{ ",E", ":TroubleToggle document_diagnostics<CR>",  silent = true },
			{ ",f", ":TroubleToggle quickfix<CR>",              silent = true },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").previous { skip_groups = true, jump = true }
					else
						vim.cmd.cprev()
					end
				end,
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next { skip_groups = true, jump = true }
					else
						vim.cmd.cnext()
					end
				end,
			},
		},
		opts = {
			action_keys = {
				previous = "u",
				next = "k",
				jump = "<Tab>",
				jump_close = "<CR>",
				-- TODO
				-- open_split = { "<c-x>" },
				-- open_vsplit = { "<c-v>" },
				-- open_tab = { "<c-t>" },
				hover = "K",
				toggle_mode = "s",
				toggle_preview = "p",
				toggle_fold = "zz",
				open_folds = "zr",
				close_folds = "zc",
			},
		},
	},

	-- Git integration for buffers
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local opts = { buffer = bufnr }
				vim.keymap.set({ "n", "v" }, "<leader>gs", gs.stage_hunk, opts)
				vim.keymap.set("n", "<leader>gS", gs.stage_buffer, opts)
				vim.keymap.set("n", "<leader>gl", gs.undo_stage_hunk, opts)

				vim.keymap.set({ "n", "v" }, "<leader>gr", gs.reset_hunk, opts)
				vim.keymap.set("n", "<leader>gR", gs.reset_buffer, opts)

				vim.keymap.set("n", "<leader>gp", gs.preview_hunk, opts)
				vim.keymap.set("n", "<leader>gb", function() gs.blame_line { full = true } end, opts)

				vim.keymap.set("n", "<leader>gd", gs.diffthis, opts)
				vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, opts)

				opts = { expr = true, buffer = bufnr }
				vim.keymap.set("n", "[[", function()
					if vim.wo.diff then
						return "[["
					end
					vim.schedule(function() gs.prev_hunk() end)
					return "<Ignore>"
				end, opts)

				vim.keymap.set("n", "]]", function()
					if vim.wo.diff then
						return "]]"
					end
					vim.schedule(function() gs.next_hunk() end)
					return "<Ignore>"
				end, opts)
			end,
		},
	},

	-- Highlighting other uses of the word under the cursor
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "neovim/nvim-lspconfig" },
		keys = { "_", "+" },
		opts = {
			providers = { "lsp", "treesitter", "regex" },
			delay = 200,
			filetypes_denylist = {
				"TelescopePrompt",
				"DressingInput",
				"neo-tree",
				"neo-tree-popup",
				"sagarename",
				"sagacodeaction",
				"lspsagafinder",
				"spectre_panel",
				"Outline",
			},
			min_count_to_highlight = 2,
		},
		config = function(_, opts)
			local illuminate = require("illuminate")
			illuminate.configure(opts)

			local function map(buffer)
				vim.keymap.set("n", "_", function() illuminate.goto_next_reference(false) end, { buffer = buffer })
				vim.keymap.set("n", "+", function() illuminate.goto_prev_reference(false) end, { buffer = buffer })
			end

			map(nil)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function() map(vim.api.nvim_get_current_buf()) end,
			})
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			filetype_exclude = { "help", "neo-tree", "Trouble" },
			show_trailing_blankline_indent = false,
			show_current_context = true,
			show_current_context_start = true,
		},
	},

	-- A tree-like view for symbols
	{
		"simrat39/symbols-outline.nvim",
		keys = {
			{ ",o", ":SymbolsOutline<CR>", silent = true },
		},
		opts = {
			keymaps = {
				close = "q",
				goto_location = "<CR>",
				focus_location = "<Tab>",
				hover_symbol = "<Nop>",
				toggle_preview = "K",
				rename_symbol = "r",
				code_actions = "a",
				fold = "n",
				unfold = "i",
				fold_all = "N",
				unfold_all = "I",
				fold_reset = "<Nop>",
			},
		},
	},
}
