return {
  -- Configurations for build-in LSP of nvim
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local on_attach = function(client, bufnr)
        -- Format on save
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.formatting_seq_sync() end
          })
        end
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

  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "bashls",
          "clangd", -- C/C++
          "cmake",
          "cssls",
          "dockerls",
          "docker_compose_language_service",
          "emmet_ls",
          "html",
          "jsonls",
          "quick_lint_js", -- JavaScript
          "ltex", -- LaTeX
          "lua_ls",
          "marksman", -- Markdown
          "ruff_lsp", -- Python
          "rust_analyzer",
          "sqlls", -- SQL
          "taplo", -- TOML
          "tailwindcss",
          "tsserver", -- TypeScript
          "lemminx", -- XML
          "yamlls", -- YAML
        },
        automatic_installation = true,
      }
    end,
  },
}
