return {
  -- Configurations for build-in LSP of nvim
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      local opts = { noremap = true, silent = true }
      -- vim.keymap.set("n", '<C-u>', vim.diagnostic.goto_prev, opts)
      -- vim.keymap.set("n", '<C-e>', vim.diagnostic.goto_next, opts)
      -- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Format on save
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.formatting_seq_sync() end
          })
        end

        opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, opts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      end


      -- Set up lspconfig
      local lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lsp.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }

      lsp.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end
  },

  -- Install & Manage LSP servers
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    config = function()
      require("mason").setup {
        ui = {
          keymaps = {
            install_package = "n",
            uninstall_package = "x",
          },
        }
      }
    end,
  }
}
