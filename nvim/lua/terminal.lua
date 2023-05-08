local M = {
	window = nil,
	buffer = nil,
	job_id = nil,
}

function M.open(cwd)
	if vim.fn.win_gotoid(M.window) == 0 then
		vim.cmd("new")
		vim.cmd("setlocal nonumber")
		vim.cmd("setlocal signcolumn=no")
		vim.cmd("setlocal nobuflisted")
		M.window = vim.fn.win_getid()
	end

	if vim.fn.bufexists(M.buffer) == 0 then
		local job_id = nil
		M.buffer = vim.fn.bufnr("%")
		M.job_id = vim.fn.termopen(vim.o.shell, {
			cwd = cwd or vim.fn.getcwd(),
			detach = true,
			on_exit = function()
				if M.job_id == job_id then
					M.destroy()
				end
			end,
		})
		job_id = M.job_id
	else
		vim.cmd("buffer " .. M.buffer)
	end
end

function M.destroy()
	if vim.fn.bufexists(M.buffer) == 1 then
		vim.api.nvim_buf_delete(M.buffer, { force = true })
	end

	M.window = nil
	M.buffer = nil
	M.job_id = nil
end

function M.exec(cwd, cmd)
	M.destroy()
	M.open(cwd)
	vim.fn.chansend(M.job_id, cmd .. "\n")
	vim.cmd("wincmd p")
end

vim.api.nvim_create_user_command("TerminalOpen", function() M.open(nil) end, {})

-- Toggle
vim.keymap.set("", "<C-\\>", ":TerminalOpen<CR>:startinsert<CR>", { silent = true })
vim.keymap.set("i", "<C-\\>", "<Esc>:TerminalOpen<CR>:startinsert<CR>", { silent = true })
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>:hide<CR>", { silent = true })

-- Close
vim.keymap.set("t", "<C-S-M-w>c", "<C-\\><C-n>:bwipeout!<CR>", { silent = true })

-- Move cursor to the end of line, specific to zsh
vim.keymap.set("t", "<Tab>", "<Tab>")
vim.keymap.set("t", "<C-i>", "\x1b[105;5u")

return M
