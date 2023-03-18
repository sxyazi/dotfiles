return {
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
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
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Vscode-like completion popup
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
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
        end, { "i", "c" }),
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
        end, { "i", "c" }),
        ["<Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.confirm({ select = true })
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

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          -- TODO
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = mapping,
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "calc" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
          })
        }
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = mapping,
        sources = {
          { name = "buffer", keyword_length = 2 },
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = mapping,
        sources = cmp.config.sources({
          { name = "cmdline", keyword_length = 2 }
        }, {
          { name = "path", keyword_length = 3 },
        })
      })
    end
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
        check_ts = true,
      }
    end,
  },

  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("mini.comment").setup {
        mappings = {
          comment = '<leader>c',
          comment_line = '<leader>c',
          textobject = '<leader>c',
        },
        hooks = {
          pre = function() require("ts_context_commentstring.internal").update_commentstring({}) end,
        },
      }
    end
  },
}
