local M = {}

-- local notify = require("notify")
local ts_utils = require("nvim-treesitter.ts_utils")

function M.current_function_name()
  local node = ts_utils.get_node_at_cursor()
  while node and node:type() ~= "function_declaration" do
    node = node:parent()
  end

  if not node then return "" end
  return vim.treesitter.query.get_node_text(node:child(1), 0)
end

function M.go_run(last)
  local name = M.current_function_name()
  local escape = vim.fn.shellescape
  if name:find("Test") == 1 then
    vim.fn.system("kitty @ kitten testing.py " ..
      escape(vim.fn.expand("%:p:h")) .. " " ..
      escape("go test -run " .. name))
  end
end

vim.keymap.set("n", "<leader>s", function() M.go_run(true) end)
vim.keymap.set("n", "<leader>S", function() M.go_run(false) end)
