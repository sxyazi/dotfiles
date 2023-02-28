return {
  -- Status
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>v", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        remove_keymaps = true,
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
        on_attach = function(bufnr)
          -- https://github.com/nvim-tree/nvim-tree.lua/blob/master/lua/nvim-tree/actions/init.lua#L7
          local api = require('nvim-tree.api')
          vim.keymap.set("n", "<Tab>", api.node.open.preview, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "<CR>", api.node.open.edit, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "k", api.fs.create, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "r", api.fs.rename_basename, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "R", api.fs.rename, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "d", api.fs.remove, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "x", api.fs.cut, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "c", api.fs.copy.node, { buffer = bufnr, noremap = true })
          vim.keymap.set("n", "p", api.fs.paste, { buffer = bufnr, noremap = true })
        end
      })
    end,
  },

  -- Fuzz finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      'nvim-lua/plenary.nvim',

      -- Install a native sorter, for better performance
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local actions = require('telescope.actions')
      local builtin = require("telescope.builtin")

      require('telescope').setup {
        defaults = {
          mappings = {
            -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L133
            i = {
              ["<CR>"] = actions.select_default,
              ["<Esc>"] = actions.close,

              ["<C-u>"] = actions.move_selection_previous,
              ["<C-e>"] = actions.move_selection_next,
              ["<M-u>"] = actions.preview_scrolling_up,
              ["<M-e>"] = actions.preview_scrolling_down,

              -- TODO
              -- ["<C-x>"] = actions.select_horizontal,
              -- ["<C-v>"] = actions.select_vertical,
              -- ["<C-t>"] = actions.select_tab,

              ["<Tab>"] = actions.toggle_selection,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          }
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
      require('telescope').load_extension('fzf')

      vim.keymap.set('n', '<leader>f', function()
        builtin.find_files({
          hidden = true,
          no_ignore = false,
        })
      end)
      vim.keymap.set('n', ',r', function()
        builtin.live_grep()
      end)
      vim.keymap.set('n', ',b', function()
        builtin.buffers()
      end)
      vim.keymap.set('n', ',e', function()
        builtin.diagnostics()
      end)
    end
  },

  -- Manage LSP/DAP servers
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
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
    event = "BufRead",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lspsaga").setup {

      }

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
      vim.keymap.set({ "n", "v", "i" }, "<C-Enter>", "<cmd>Lspsaga code_action<CR>", opts)

      vim.keymap.set("n", "<leader>r", "<cmd>Lspsaga rename<CR>", opts)
      vim.keymap.set("n", "<leader>s", "<cmd>Lspsaga lsp_finder<CR>", opts)
      vim.keymap.set("n", "<leader>l", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)

      vim.keymap.set("n", "<leader>b", "<cmd>Lspsaga goto_definition<CR>", opts)
      vim.keymap.set("n", "<leader>B", "<cmd>Lspsaga peek_definition<CR>", opts)

      vim.keymap.set("n", "<leader>m", "<cmd>Lspsaga goto_type_definition<CR>", opts)
      vim.keymap.set("n", "<leader>M", "<cmd>Lspsaga peek_type_definition<CR>", opts)

      vim.keymap.set("n", "[e", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, opts)
      vim.keymap.set("n", "]e", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, opts)

      vim.keymap.set("n", "<M-o>", "<cmd>Lspsaga outline<CR>", opts)
      vim.keymap.set({ "n", "t" }, "<M-z>", "<cmd>Lspsaga term_toggle<CR>", opts)
    end,
  },

  -- Git integration for buffers
  {
    'lewis6991/gitsigns.nvim',
    event = "BufRead",
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local opts = { buffer = bufnr }
          vim.keymap.set({ 'n', 'v' }, '<leader>hs', gs.stage_hunk, opts)
          vim.keymap.set('n', '<leader>hS', gs.stage_buffer, opts)
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, opts)

          vim.keymap.set({ 'n', 'v' }, '<leader>hr', gs.reset_hunk, opts)
          vim.keymap.set('n', '<leader>hR', gs.reset_buffer, opts)

          vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts)

          vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end, opts)
          vim.keymap.set('n', '<leader>hd', gs.diffthis, opts)
          vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, opts)

          opts = { expr = true, buffer = bufnr }
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, opts)

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, opts)
        end
      }
    end,
  },

  -- Highlighting other uses of the word under the cursor
  {
    "RRethy/vim-illuminate",
    event = "BufRead",
    config = function()
      require('illuminate').configure({
        providers = { 'lsp', 'treesitter', 'regex' },
        delay = 100,
        filetypes_denylist = { "NvimTree" },
      })
    end
  }
}
