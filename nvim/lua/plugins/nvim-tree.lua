return {
  { 
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy", 
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>")
      vim.keymap.set("n", "<leader>v", ":NvimTreeFindFile<CR>")

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
          mappings = {
            list = {
              { key = "u", action = "dir_up" },
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
