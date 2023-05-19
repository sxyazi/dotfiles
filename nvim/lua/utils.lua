local M = {}

function M.search_partten(forward)
	vim.cmd('noau normal! "vy"')
	local s = vim.fn.getreg("v"):gsub("/", "\\/"):gsub([[\]], [[\\]]):gsub("\n", "\\n"):gsub("\r", "\\r")
	return string.format("%s\\V%s\n", forward and "?" or "/", s)
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
	local format = vim.api.nvim_buf_get_option(bufnr, "fileformat")
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
	if vim.api.nvim_buf_get_option(bufnr, "eol") then
		lines[#lines + 1] = ""
	end
	return lines
end

return M
