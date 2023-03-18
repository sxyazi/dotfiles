return {
  -- Status
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup {
        options = {
          disabled_filetypes = {
            statusline = {
              "neo-tree"
            },
          },
          ignore_focus = {
            "dapui_watches",
            "dapui_stacks",
            "dapui_breakpoints",
            "dapui_scopes",
            "dapui_console",
            "dap-repl",
          },
        },
      }
    end,
  },

  -- Improve the default `vim.ui` interfaces
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        insert_only = false,
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
          mappings = {
            ["<CR>"] = "Confirm",
            ["<Esc>"] = "Close",
            ["<C-w>"] = "Close",
          },
        },
      },
    }
  },

  -- File tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>1", ":Neotree toggle<CR>", noremap = true, silent = true },
      { "<leader>v", ":Neotree reveal<CR>", noremap = true, silent = true },
    },
    config = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      require("neo-tree").setup({
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
            end
          },
          {
            event = "neo_tree_window_before_close",
            handler = function() require("neo-tree.sources.common.preview").hide() end
          }
        },
        window = {
          mappings = {
            ["k"] = "toggle_preview",
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

              local node = state.tree:get_node()
              if state.commands.clear_filte ~= nil then
                state.commands.clear_filter(state)
                require("neo-tree.sources.filesystem").navigate(state, state.path, node:get_id())
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
          }
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
            }
          }
        },
        buffers = {
          window = {
            mappings = {
              ["."] = "set_root",
              ["<BS>"] = "navigate_up",
              ["d"] = "buffer_delete",
            }
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
            }
          }
        }
      })
    end
  },

  -- Fuzz finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",

      -- Install a native sorter, for better performance
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    keys = {
      {
        "<leader>f",
        function() require("telescope.builtin").find_files({ hidden = true, no_ignore = false }) end,
        noremap = true,
      },
      { ",r", function() require("telescope.builtin").live_grep() end, noremap = true },
      { ",a", function() require("telescope.builtin").buffers() end,   noremap = true },
    },
    config = function()
      local actions = require("telescope.actions")
      local trouble = require("trouble.providers.telescope")

      local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, "--hidden")
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!lazy-lock.json")

      require("telescope").setup {
        defaults = {
          mappings = {
            -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L133
            i = {
              ["<C-w>"] = actions.close,
              ["<C-u>"] = actions.move_selection_previous,
              ["<C-e>"] = actions.move_selection_next,
              ["<M-u>"] = actions.preview_scrolling_up,
              ["<M-e>"] = actions.preview_scrolling_down,
              ["<C-t>"] = trouble.open_with_trouble,
              -- TODO
              -- ["<C-x>"] = actions.select_horizontal,
              -- ["<C-v>"] = actions.select_vertical,
              -- ["<C-t>"] = actions.select_tab,
            },
            n = {
              ["<Esc>"] = actions.close,
              ["<C-w>"] = actions.close,
              ["u"] = actions.move_selection_previous,
              ["e"] = actions.move_selection_next,
              ["<C-u>"] = actions.move_selection_previous,
              ["<C-e>"] = actions.move_selection_next,
              ["<M-u>"] = actions.preview_scrolling_up,
              ["<M-e>"] = actions.preview_scrolling_down,
              ["t"] = trouble.open_with_trouble,
              ["<C-t>"] = trouble.open_with_trouble,
              -- TODO
              -- ["x"] = actions.select_horizontal,
              -- ["v"] = actions.select_vertical,
              -- ["t"] = actions.select_tab,
            }
          },
          vimgrep_arguments = vimgrep_arguments,
          buffer_previewer_maker = function(filepath, bufnr, opts)
            filepath = vim.fn.expand(filepath)
            vim.loop.fs_stat(filepath, function(_, stat)
              if not stat then return end
              if stat.size > 51200 then return end -- less than 50KiB

              require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
            end)
          end,
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      }

      require("telescope").load_extension("fzf")
    end
  },

  -- Manage LSP/DAP servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup {
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
        }
      }
    end,
  },

  -- Beautiful UIs for various LSP-related features, like hover doc
  {
    "glepnir/lspsaga.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "K",         ":Lspsaga hover_doc ++quiet ++keep<CR>", noremap = true,      silent = true },
      { "<C-Enter>", ":Lspsaga code_action<CR>",              mode = { "n", "v" }, noremap = true, silent = true },
      { "<leader>r", ":Lspsaga rename<CR>",                   noremap = true,      silent = true },
      { "<leader>l", ":Lspsaga lsp_finder<CR>",               noremap = true,      silent = true },
      { "<leader>b", ":Lspsaga goto_definition<CR>",          noremap = true,      silent = true },
      { "<leader>B", ":Lspsaga peek_definition<CR>",          noremap = true,      silent = true },
      { "<leader>m", ":Lspsaga goto_type_definition<CR>",     noremap = true,      silent = true },
      { "<leader>M", ":Lspsaga peek_type_definition<CR>",     noremap = true,      silent = true },

      {
        "[e",
        function() require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
        noremap = true,
        silent = true
      },
      {
        "]e",
        function() require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
        noremap = true,
        silent = true
      },
    },
    config = function()
      require("lspsaga").setup {
        request_timeout = 10000,
        finder = {
          keys = {
            jump_to = "<Tab>",
            edit = { "<CR>" },
            vsplit = "<Nop>", -- TODO
            split = "<Nop>",  -- TODO
            tabe = "<Nop>",   -- TODO
            tabnew = "<Nop>", -- TODO
            quit = { "q" },
            close_in_preview = "q"
          },
        },
        definition = {
          edit = "<CR>",
          vsplit = "<Nop>", -- TODO
          split = "<Nop>",  -- TODO
          tabe = "<Nop>",   -- TODO
          quit = "q",
        },
        lightbulb = { sign = false },
        diagnostic = {
          keys = {
            exec_action = "<CR>",
            go_action = "<Tab>"
          },
        },
        rename = { quit = "q", in_select = false },
        outline = {
          keys = {
            jump = "<CR>",
            expand_collapse = "<Tab>",
          },
        },
        symbol_in_winbar = { enable = false },
      }
    end,
  },

  -- Standalone UI for nvim-lsp progress
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      window = { blend = 0 },
    },
  },

  -- A pretty list to show diagnostics, references, and quickfix results
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { ",e", ":TroubleToggle workspace_diagnostics<CR>", noremap = true, silent = true },
      { ",E", ":TroubleToggle document_diagnostics<CR>",  noremap = true, silent = true },
      { ",f", ":TroubleToggle quickfix<CR>",              noremap = true, silent = true },
    },
    config = function()
      require("trouble").setup {
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
      }
    end
  },

  -- Git integration for buffers
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local opts = { buffer = bufnr }
          vim.keymap.set({ "n", "v" }, "<leader>gs", gs.stage_hunk, opts)
          vim.keymap.set("n", "<leader>gS", gs.stage_buffer, opts)
          vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, opts)

          vim.keymap.set({ "n", "v" }, "<leader>gr", gs.reset_hunk, opts)
          vim.keymap.set("n", "<leader>gR", gs.reset_buffer, opts)

          vim.keymap.set("n", "<leader>gp", gs.preview_hunk, opts)

          vim.keymap.set("n", "<leader>gb", function() gs.blame_line { full = true } end, opts)
          vim.keymap.set("n", "<leader>gd", gs.diffthis, opts)
          vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, opts)

          opts = { expr = true, buffer = bufnr }
          vim.keymap.set("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, opts)

          vim.keymap.set("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, opts)
        end
      }
    end,
  },

  -- Highlighting other uses of the word under the cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 100,
        filetypes_denylist = {
          "TelescopePrompt",
          "DressingInput",
          "neo-tree",
          "Outline",
          "sagarename",
        },
      })
    end
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
      }
    end
  },

  -- A tree-like view for symbols
  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { ",o", ":SymbolsOutline<CR>", noremap = true, silent = true },
    },
    config = function()
      require("symbols-outline").setup {
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
      }
    end
  },
}
