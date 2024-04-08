return {
	-- Status
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = "catppuccin",
				component_separators = "|",
				section_separators = { left = "", right = "" },
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
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2 },
				},
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = {
					{
						function()
							local loc = require("lualine.components.location")()
							local sel = require("lualine.components.selectioncount")()
							if sel ~= "" then
								loc = loc .. " (" .. sel .. " sel)"
							end
							return loc
						end,
						separator = { right = "" },
						left_padding = 2,
					},
				},
			},
			extensions = { "neo-tree" },
		},
	},

	-- Completely replaces the UI for messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			{ "MunifTanjim/nui.nvim", lazy = true },
			{ "rcarriga/nvim-notify", lazy = true, opts = { background_colour = "#000000" } },
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
					filter = {
						event = "notify",
						any = {
							-- Neo-tree
							{ find = "Toggling hidden files: true" },
							{ find = "Toggling hidden files: false" },
							{ find = "Operation canceled" },

							-- Telescope
							{ find = "Nothing currently selected" },
						},
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = { "echo" },
					},
					opts = { skip = true },
				},
				{
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

							-- Move lines
							{ find = " lines moved" },
							{ find = " lines indented" },

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
					filter = {
						event = "msg_show",
						kind = "emsg",
						any = {
							-- TODO: A bug workaround of Lspsaga's finder
							-- { find = "E134: Cannot move a range of lines into itself" },
						},
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "lsp",
						any = {
							{ find = "formatting" },
							{ find = "Diagnosing" },
							{ find = "Diagnostics" },
							{ find = "diagnostics" },
							{ find = "code_action" },
							{ find = "cargo check" },
							{ find = "Processing full semantic tokens" },
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
			vim.ui.select = function(...)
				require("lazy").load { plugins = { "dressing.nvim" } }
				return vim.ui.select(...)
			end
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
						["<Esc>"] = "Close",
						["<CR>"] = "Confirm",
					},
					i = {
						["<CR>"] = "Confirm",
						["<C-u>"] = "HistoryPrev",
						["<C-e>"] = "HistoryNext",
					},
				},
			},
			select = {
				get_config = function(opts)
					if opts.kind == "codeaction" then
						return {
							backend = "telescope",
							telescope = require("telescope.themes").get_cursor {
								-- initial_mode = "normal",
								layout_config = { height = 15 },
							},
						}
					end

					return { backend = "telescope", telescope = nil }
				end,
			},
		},
	},

	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
			{ "nvim-tree/nvim-web-devicons", lazy = true },
			{ "MunifTanjim/nui.nvim", lazy = true },
			{ "nvim-telescope/telescope.nvim", lazy = true },
		},
		keys = {
			{ "<leader>1", ":Neotree toggle<CR>", silent = true },
			{ "<leader>v", ":Neotree reveal<CR>", silent = true },
		},
		config = function()
			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

			local function fold(state)
				local node = state.tree:get_node()
				local foldable = require("neo-tree.utils").is_expandable(node) and node:is_expanded()

				if foldable then
					state.commands.toggle_node(state)
				elseif node:get_parent_id() then
					require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
				end
			end

			local function expand(on_open)
				return function(state)
					local node = state.tree:get_node()
					local expandable = require("neo-tree.utils").is_expandable(node)

					-- if it's a file, open it
					if not expandable then
						state.commands.open(state)
						return on_open and on_open(state)
					end

					-- if it's a directory, expand or jump into it
					if not node:is_expanded() then
						state.commands.toggle_node(state)
					elseif node:has_children() then
						require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
					end
				end
			end

			local function telescopeOpts(state, path)
				return {
					cwd = path,
					search_dirs = { path },
					attach_mappings = function(prompt_bufnr)
						local actions = require("telescope.actions")
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local selected = require("telescope.actions.state").get_selected_entry()
							local filename = selected.filename and selected.filename or selected[1]
							require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
						end)
						return true
					end,
				}
			end

			require("neo-tree").setup {
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
				window = {
					mappings = {
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

						["n"] = fold,
						["i"] = expand(function(state)
							if state.commands.clear_filter and state.search_pattern then
								local fs = require("neo-tree.sources.filesystem")
								local node = state.tree:get_node()
								fs.reset_search(state, false, false)
								fs.navigate(state, state.path, node:get_id(), function() require("neo-tree").close_all() end)
							else
								require("neo-tree").close_all()
							end
						end),
						["<CR>"] = expand(nil),
						["<Tab>"] = expand(function() vim.cmd("Neotree reveal") end),

						["c"] = function(state)
							local path = state.tree:get_node().path
							if string.find(path, state.path, 1, true) == 1 then
								path = string.sub(path, #state.path + 2)
							end
							vim.fn.system("echo -n " .. string.format("%q", path) .. " | pbcopy")
						end,
						["C"] = function(state)
							local path = state.tree:get_node().path
							vim.fn.system("echo -n " .. string.format("%q", path) .. " | pbcopy")
						end,

						["f"] = function(state)
							local node = state.tree:get_node()
							require("telescope.builtin").live_grep(telescopeOpts(state, node.path))
						end,
						["F"] = function(state)
							local node = state.tree:get_node()
							require("telescope.builtin").find_files(telescopeOpts(state, node.path))
						end,

						["o"] = function(state)
							local path = state.tree:get_node().path
							vim.fn.system("open -R " .. string.format("%q", path))
						end,
					},
				},
				filesystem = {
					commands = {
						delete = function(state)
							local node = state.tree:get_node()
							require("neo-tree").config.filesystem.commands.delete_visual(state, { node })
						end,
						delete_visual = function(state, selected_nodes)
							local path = {}
							for _, node in ipairs(selected_nodes) do
								if node.type ~= "message" then
									path[#path + 1] = "the POSIX file " .. string.format("%q", node.path)
								end
							end

							local term
							if #path < 1 then
								return
							elseif #path == 1 then
								term = "this file"
							else
								term = #path .. " files"
							end

							local inputs = require("neo-tree.ui.inputs")
							inputs.confirm("Are you sure trash " .. term .. "?", function(confirmed)
								if not confirmed then
									return
								end

								vim.fn.system {
									"osascript",
									"-e",
									'tell app "Finder" to move {' .. table.concat(path, ",") .. "} to trash",
								}
								require("neo-tree.sources.manager").refresh(state.name)
							end)
						end,
					},
					group_empty_dirs = true,
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
			}
		end,
	},

	-- Adds support for file operations using built-in LSP
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function() require("lsp-file-operations").setup() end,
	},

	-- Fuzz finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		keys = function()
			local extr_args = {
				"--hidden", -- Search hidden files that are prefixed with `.`
				"--no-ignore", -- Don’t respect .gitignore
				"-g",
				"!.git/",
				"-g",
				"!node_modules/",
				"-g",
				"!.idea/",
				"-g",
				"!pnpm-lock.yaml",
				"-g",
				"!package-lock.json",
				"-g",
				"!go.sum",
				"-g",
				"!lazy-lock.json",
				"-g",
				"!.zsh_history",
			}

			return {
				{ ",a", function() require("telescope.builtin").buffers() end },
				{ "<leader>;", function() require("telescope.builtin").command_history() end },

				-- Search
				{ "<leader>e", function() require("telescope.builtin").find_files() end },
				{
					"<leader>E",
					function()
						require("telescope.builtin").find_files {
							find_command = { "rg", "--color=never", "--smart-case", "--files", unpack(extr_args) },
						}
					end,
				},
				{ "<leader>/", function() require("telescope.builtin").live_grep() end },
				{ "<leader>?", function() require("telescope.builtin").live_grep { additional_args = extr_args } end },

				-- LSP
				{
					"<leader>l",
					function() require("telescope.builtin").lsp_references { initial_mode = "normal", reuse_win = true } end,
				},
				{
					"<leader>b",
					function() require("telescope.builtin").lsp_definitions { initial_mode = "normal", reuse_win = true } end,
				},
				{
					"<leader>m",
					function() require("telescope.builtin").lsp_type_definitions { initial_mode = "normal", reuse_win = true } end,
				},
				{
					"<leader>i",
					function() require("telescope.builtin").lsp_implementations { initial_mode = "normal", reuse_win = true } end,
				},
				{ "<leader>u", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end },
			}
		end,
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local trouble = require("trouble.providers.telescope")

			telescope.setup {
				defaults = {
					scroll_strategy = "limit",
					prompt_prefix = " ",
					selection_caret = " ",
					multi_icon = " ",
					mappings = {
						-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L133
						i = {
							["<C-n>"] = false, -- disable default keybinding

							["<C-u>"] = actions.cycle_history_prev,
							["<C-e>"] = actions.cycle_history_next,
							["<M-u>"] = actions.preview_scrolling_up,
							["<M-e>"] = actions.preview_scrolling_down,
							["<C-s>"] = actions.select_vertical,
							["<C-h>"] = actions.select_horizontal,
							["<C-t>"] = actions.select_tab,
							["<C-q>"] = trouble.smart_open_with_trouble,
						},
						n = {
							["k"] = false, -- disable default keybinding
							["<S-Tab>"] = false, -- disable default keybinding

							["<Tab>"] = actions.toggle_selection,
							["<BS>"] = actions.delete_buffer,
							["u"] = actions.move_selection_previous,
							["e"] = actions.move_selection_next,
							["U"] = function(prompt_bufnr) require("telescope.actions.set").shift_selection(prompt_bufnr, -5) end,
							["E"] = function(prompt_bufnr) require("telescope.actions.set").shift_selection(prompt_bufnr, 5) end,
							["<C-u>"] = actions.cycle_history_prev,
							["<C-e>"] = actions.cycle_history_next,
							["<M-u>"] = actions.preview_scrolling_up,
							["<M-e>"] = actions.preview_scrolling_down,
							["s"] = actions.select_vertical,
							["h"] = actions.select_horizontal,
							["t"] = actions.select_tab,
							["<C-q>"] = trouble.smart_open_with_trouble,
						},
					},
					buffer_previewer_maker = function(filepath, bufnr, opts)
						require("plenary.job")
							:new({
								command = "file",
								args = { "-b", "--mime", filepath },
								on_exit = function(j)
									if j:result()[1]:find("charset=binary", 1, true) then
										vim.schedule(function() vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" }) end)
									else
										require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
									end
								end,
							})
							:sync()
					end,
				},
				pickers = {
					find_files = { previewer = false },
					live_grep = { theme = "ivy" },

					lsp_references = { theme = "ivy" },
					lsp_definitions = { theme = "ivy" },
					lsp_type_definitions = { theme = "ivy" },
					lsp_implementations = { theme = "ivy" },
					lsp_dynamic_workspace_symbols = {
						sorter = telescope.extensions.fzy_native.native_fzy_sorter(),
					},
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = true,
						override_file_sorter = true,
					},
				},
			}

			telescope.load_extension("fzy_native")
			telescope.load_extension("noice")
		end,
	},
	{
		"danielfalk/smart-open.nvim",
		dependencies = {
			{ "kkharji/sqlite.lua", lazy = true },
			{ "nvim-telescope/telescope-fzy-native.nvim", lazy = true },
		},
		keys = {
			{
				"<leader><leader>",
				function()
					require("telescope").extensions.smart_open.smart_open(
						require("telescope.themes").get_dropdown { cwd_only = true, previewer = false }
					)
				end,
			},
		},
		config = function() require("telescope").load_extension("smart_open") end,
	},

	-- Manage LSP/DAP servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			pip = {
				upgrade_pip = true,
			},
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

	-- Find and replace with dark power
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		keys = {
			{ "<leader>f", ":lua require('spectre').open()<CR>", mode = "n", silent = true },
			{ "<leader>f", ":lua require('spectre').open_visual()<CR>", mode = "v", silent = true },
		},
		opts = {
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
					map = "tv",
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
			{ ",E", ":TroubleToggle document_diagnostics<CR>", silent = true },
			{ ",q", ":TroubleToggle quickfix<CR>", silent = true },
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
				next = "e",

				jump = "<Tab>",
				jump_close = "<CR>",

				open_split = "s",
				open_vsplit = "S",
				open_tab = "t",

				toggle_fold = "za",
				open_folds = "zr",
				close_folds = "zm",
			},
		},
		config = function(opts)
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = "Trouble",
				callback = function(event)
					if require("trouble.config").options.mode ~= "telescope" then
						return
					end

					local function delete()
						local folds = require("trouble.folds")
						local telescope = require("trouble.providers.telescope")

						local ord = { "" } -- { filename, ... }
						local files = { [""] = { 1, 1, 0 } } -- { [filename] = { start, end, start_index } }
						for i, result in ipairs(telescope.results) do
							if files[result.filename] == nil then
								local next = files[ord[#ord]][2] + 1
								files[result.filename] = { next, next, i }
								table.insert(ord, result.filename)
							end
							if not folds.is_folded(result.filename) then
								files[result.filename][2] = files[result.filename][2] + 1
							end
						end

						local line = unpack(vim.api.nvim_win_get_cursor(0))
						for i, id in ipairs(ord) do
							if line == files[id][1] then -- Group
								local next = ord[i + 1]
								for _ = files[id][3], next and files[next][3] - 1 or #telescope.results do
									table.remove(telescope.results, files[id][3])
								end
								break
							elseif line <= files[id][2] then -- Item
								table.remove(telescope.results, files[id][3] + (line - files[id][1]) - 1)
								break
							end
						end

						if #telescope.results == 0 then
							require("trouble").close()
						else
							require("trouble").refresh { provider = "telescope", auto = false }
						end
					end

					vim.keymap.set("n", "x", delete, { buffer = event.buf })
				end,
			})

			require("trouble").setup(opts)
		end,
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
				"Trouble",
				"neo-tree",
				"neo-tree-popup",
				"DressingInput",
				"spectre_panel",
				"Outline",
				"checkhealth",
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

	-- Neovim plugin for terminal file manager integration
	{
		"rolv-apneseth/tfm.nvim",
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>v", "", {
				noremap = true,
				callback = require("tfm").open,
			})
		end,
	},
}
