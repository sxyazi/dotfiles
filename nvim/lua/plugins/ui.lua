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
        view = {
          width = 30,
          mappings = {
            list = {
              -- https://github.com/nvim-tree/nvim-tree.lua/blob/master/lua/nvim-tree/actions/init.lua#L7
              { key = "<Tab>",                     action = "preview" },
              { key = { "<CR>", "<2-LeftMouse>" }, action = "edit" },
              { key = "k",                         action = "create" },
              { key = "r",                         action = "rename_basename" },
              { key = "R",                         action = "rename", },
              { key = "d",                         action = "remove" },
              { key = "x",                         action = "cut" },
              { key = "c",                         action = "copy" },
              { key = "p",                         action = "paste" }
            },
          },
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end,
  },
}
