return {
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
              { key = "<Tab>",                          action = "preview" },
              { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
              { key = "r",                              action = "rename_basename" },
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
