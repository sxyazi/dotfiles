return {
  {
    "simrat39/rust-tools.nvim",
    event = "BufRead",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<C-Enter>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      })

      -- For better debugging experience
      local codelldb_root = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
      local codelldb_path = codelldb_root .. "adapter/codelldb"
      local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
      require("dap").adapters.rust = require("rust-tools.dap").get_codelldb_adapter(
        codelldb_path, liblldb_path)
    end
  }
}
