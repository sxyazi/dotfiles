local M = {
	last_unit = nil,
	last_cwd = nil,
}

function M.current_function_name()
	local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	while node and node:type() ~= "function_declaration" do
		node = node:parent()
	end

	if not node then
		return ""
	end
	return vim.treesitter.get_node_text(node:child(1), 0)
end

function M.go_run(last)
	if not last then
		M.last_unit = M.current_function_name()
		M.last_cwd = vim.fn.expand("%:p:h")
	end

	if not M.last_unit then
		return require("notify")("no function name found")
	end

	if M.last_unit:find("Test") == 1 then
		require("terminal").exec(M.last_cwd, "go test -run '^" .. M.last_unit .. "$'")
	elseif M.last_unit == "main" then
		require("terminal").exec(M.last_cwd, "go run .")
	else
		require("notify")("unsupported test")
	end
end

vim.keymap.set("n", "<leader>s", function() M.go_run(true) end)
vim.keymap.set("n", "<leader>S", function() M.go_run(false) end)
