local lsp_attached = function(client, bufnr)
  -- Format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format({ timeout_ms = 5000, bufnr = bufnr }) end
    })
  end
end

return {
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
          "texlab",        -- LaTeX
          "lua_ls",
          "marksman",      -- Markdown
          "ruff_lsp",      -- Python
          "rust_analyzer",
          "sqlls",         -- SQL
          "taplo",         -- TOML
          "tailwindcss",
          "tsserver",      -- TypeScript
          "lemminx",       -- XML
          "yamlls",        -- YAML
        },
        automatic_installation = true,
      }
    end,
  },

  -- As a complement to Mason, integrating non-LSPs like Prettier
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        on_attach = lsp_attached,
        sources = {
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.diagnostics.eslint_d.with({
            diagnostics_format = "[eslint] #{m}\n(#{c})"
          }),
        },
      })
    end
  },

  -- Configurations for build-in LSP of nvim
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Set up lspconfig
      local lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      lsp.lua_ls.setup {
        on_attach = lsp_attached,
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
        on_attach = lsp_attached,
        capabilities = capabilities,
      }
      lsp.ruff_lsp.setup {
        on_attach = lsp_attached,
        capabilities = capabilities,
      }
      lsp.marksman.setup {
        on_attach = lsp_attached,
        capabilities = capabilities,
      }
    end
  },
}
