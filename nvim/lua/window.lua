local mappings = {
	k = "top",
	j = "bottom",
	h = "left",
	l = "right",
}

local function jump(direction)
	local prev = vim.fn.winnr()
	vim.cmd("wincmd " .. direction)

	if vim.fn.winnr() == prev then
		-- the `--to=$KITTY_LISTEN_ON` env is passed automatically
		vim.fn.system("kitty @ kitten window.py +jump " .. mappings[direction])
	end
end

local function resize(direction)
	local cur = vim.fn.winnr()
	local cur_pos = vim.fn.win_screenpos(0)

	local function neighbor(target)
		local comp = vim.fn.winnr(target)
		if cur == comp then
			return false
		end

		local comp_pos = vim.fn.win_screenpos(comp)
		if target == "k" or target == "j" then
			return comp_pos[0] == cur_pos[0]
		else
			return comp_pos[1] == cur_pos[1]
		end
	end

	local top, bottom = neighbor("k"), neighbor("j")
	local left, right = neighbor("h"), neighbor("l")

	local modifier
	if direction == "k" then
		if top and bottom then
			modifier = "-"
		elseif top then
			modifier = "+"
		elseif bottom then
			modifier = "-"
		end
	elseif direction == "j" then
		if top and bottom then
			modifier = "+"
		elseif top then
			modifier = "-"
		elseif bottom then
			modifier = "+"
		end
	elseif direction == "h" then
		if left and right then
			modifier = "-"
		elseif left then
			modifier = "+"
		elseif right then
			modifier = "-"
		end
	elseif direction == "l" then
		if left and right then
			modifier = "+"
		elseif left then
			modifier = "-"
		elseif right then
			modifier = "+"
		end
	end

	if modifier == nil then
		vim.fn.system("kitty @ kitten window.py +resize " .. mappings[direction])
	elseif direction == "k" or direction == "j" then
		vim.cmd("resize " .. modifier .. "10")
	else
		vim.cmd("vertical resize " .. modifier .. "10")
	end
end

local function move(direction)
	local prev = vim.fn.winnr()
	vim.cmd("wincmd " .. string.upper(direction))

	if vim.fn.winnr() == prev then
		vim.fn.system("kitty @ kitten window.py +move " .. mappings[direction])
	end
end

local function restore_cursor(opts)
	if opts.args == "force" or vim.bo.buftype == "terminal" then
		vim.cmd("startinsert")
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		vim.api.nvim_win_set_cursor(0, { line, col + 1 })
	end
end

vim.api.nvim_create_user_command("WindowJumpTop", function() jump("k") end, {})
vim.api.nvim_create_user_command("WindowJumpBottom", function() jump("j") end, {})
vim.api.nvim_create_user_command("WindowJumpLeft", function() jump("h") end, {})
vim.api.nvim_create_user_command("WindowJumpRight", function() jump("l") end, {})

vim.api.nvim_create_user_command("WindowResizeTop", function() resize("k") end, {})
vim.api.nvim_create_user_command("WindowResizeBottom", function() resize("j") end, {})
vim.api.nvim_create_user_command("WindowResizeLeft", function() resize("h") end, {})
vim.api.nvim_create_user_command("WindowResizeRight", function() resize("l") end, {})

vim.api.nvim_create_user_command("WindowMoveTop", function() move("k") end, {})
vim.api.nvim_create_user_command("WindowMoveBottom", function() move("j") end, {})
vim.api.nvim_create_user_command("WindowMoveLeft", function() move("h") end, {})
vim.api.nvim_create_user_command("WindowMoveRight", function() move("l") end, {})

vim.api.nvim_create_user_command("RestoreCursor", restore_cursor, { nargs = "?" })

local function map_set(key, cmd, term)
	vim.keymap.set("", "<C-S-M-w>" .. key, string.format(":%s<CR>:RestoreCursor<CR>", cmd), { silent = true })
	vim.keymap.set("i", "<C-S-M-w>" .. key, string.format("<Esc>:%s<CR>:RestoreCursor force<CR>", cmd), { silent = true })

	if term == 1 then
		vim.keymap.set("t", "<C-S-M-w>" .. key, string.format("<C-\\><C-n>:%s<CR>", cmd), { silent = true })
	elseif term == 2 then
		vim.keymap.set("t", "<C-S-M-w>" .. key, string.format("<C-\\><C-n>:%s<CR>:startinsert<CR>", cmd), { silent = true })
	end
end

local function on_close(mode)
	return function()
		local ft = vim.bo.filetype
		if ft == "TelescopePrompt" then
			return "<C-w>w"
		end
		if mode == "c" then
			return "<Esc>"
		end
		if mode == "i" then
			return "<Esc>:q<CR>"
		end
		return ":q<CR>"
	end
end

-- Splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.keymap.set("n", "su", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", { silent = true })
vim.keymap.set("n", "se", ":set splitbelow<CR>:split<CR>", { silent = true })
vim.keymap.set("n", "sn", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", { silent = true })
vim.keymap.set("n", "si", ":set splitright<CR>:vsplit<CR>", { silent = true })

-- Closing
vim.keymap.set("", "<C-S-M-w>c", on_close(""), { expr = true, silent = true })
vim.keymap.set("i", "<C-S-M-w>c", on_close("i"), { expr = true, silent = true })
vim.keymap.set("c", "<C-S-M-w>c", on_close("c"), { expr = true, silent = true })

-- Quitting
vim.keymap.set("", "<C-S-M-w>q", ":qa<CR>", { silent = true })
vim.keymap.set("i", "<C-S-M-w>q", "<Esc>:qa<CR>", { silent = true })
vim.keymap.set("c", "<C-S-M-w>q", "<Esc>:qa<CR>", { silent = true })

-- Jumping
map_set("ju", "WindowJumpTop", 1)
map_set("je", "WindowJumpBottom", 1)
map_set("jn", "WindowJumpLeft", 1)
map_set("ji", "WindowJumpRight", 1)

-- Resizing
map_set("ru", "WindowResizeTop", 2)
map_set("re", "WindowResizeBottom", 2)
map_set("rn", "WindowResizeLeft", 2)
map_set("ri", "WindowResizeRight", 2)

-- Moving
map_set("mu", "WindowMoveTop", 2)
map_set("me", "WindowMoveBottom", 2)
map_set("mn", "WindowMoveLeft", 2)
map_set("mi", "WindowMoveRight", 2)
