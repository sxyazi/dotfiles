local M = {}

function M.search(forward)
	vim.cmd('noau normal! "vy"')
	local s = vim.fn.getreg("v")

	s = s:gsub("/", "\\/"):gsub([[\]], [[\\]]):gsub("\n", "\\n"):gsub("\r", "\\r")
	s = string.format("%s\\V%s\ngn", forward and "?" or "/", s)

	vim.api.nvim_feedkeys(s, "n", false)
end

function M.list_equal(a, b)
	if #a ~= #b then
		return false
	end
	for k, v in ipairs(a) do
		if v ~= b[k] then
			return false
		end
	end
	return true
end

function M.line_ending(bufnr)
	local format = vim.api.nvim_get_option_value("fileformat", { buf = bufnr })
	if format == "dos" then
		return "\r\n"
	elseif format == "mac" then
		return "\r"
	else
		return "\n"
	end
end

function M.full_lines(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
	if vim.api.nvim_get_option_value("eol", { buf = bufnr }) then
		lines[#lines + 1] = ""
	end
	return lines
end

return M
