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
		vim.cmd("resize " .. modifier .. "5")
	else
		vim.cmd("vertical resize " .. modifier .. "5")
	end
end

local function move(direction)
	local prev = vim.fn.winnr()
	vim.cmd("wincmd " .. string.upper(direction))

	if vim.fn.winnr() == prev then
		vim.fn.system("kitty @ kitten window.py +move " .. mappings[direction])
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

local function map_set(key, cmd)
	vim.keymap.set("", "<C-S-M-w>" .. key, string.format(":%s<CR>", cmd), { silent = true })
	vim.keymap.set("i", "<C-S-M-w>" .. key, string.format("<Esc>:%s<CR>a", cmd), { silent = true })
end

-- Splitting, Closing
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.keymap.set("n", "su", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", { silent = true })
vim.keymap.set("n", "se", ":set splitbelow<CR>:split<CR>", { silent = true })
vim.keymap.set("n", "sn", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", { silent = true })
vim.keymap.set("n", "si", ":set splitright<CR>:vsplit<CR>", { silent = true })

map_set("c", "q")

-- Jumping
map_set("ju", "WindowJumpTop")
map_set("je", "WindowJumpBottom")
map_set("jn", "WindowJumpLeft")
map_set("ji", "WindowJumpRight")

-- Resizeing
map_set("ru", "WindowResizeTop")
map_set("re", "WindowResizeBottom")
map_set("rn", "WindowResizeLeft")
map_set("ri", "WindowResizeRight")

-- Moveing
map_set("mu", "WindowMoveTop")
map_set("me", "WindowMoveBottom")
map_set("mn", "WindowMoveLeft")
map_set("mi", "WindowMoveRight")