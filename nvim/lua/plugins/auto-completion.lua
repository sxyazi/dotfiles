return {
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",

      -- For luasnip users.
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Vscode-like completion popup
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require("luasnip")
      local lspkind = require('lspkind')
      local mapping = {
        ["<C-u>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            if not cmp.get_selected_entry() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            end
          else
            fallback()
          end
        end, { 'i', 'c' }),
        ["<C-e>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if not cmp.get_selected_entry() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            if not cmp.get_selected_entry() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end
          else
            fallback()
          end
        end, { 'i', 'c' }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 'c' }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable( -1) then
            luasnip.jump( -1)
          else
            fallback()
          end
        end, { 'i', 'c' }),
      }

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = mapping,
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
          })
        }
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = mapping,
        sources = {
          { name = "buffer" }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = mapping,
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  },

  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
        check_ts = true
      }
    end,
  }
}