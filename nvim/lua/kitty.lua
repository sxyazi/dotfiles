local mappings = {
  k = "top",
  j = "bottom",
  h = "left",
  l = "right"
}

local function navigate(direction)
  local prev = vim.fn.winnr()
  vim.cmd("wincmd " .. direction)

  if vim.fn.winnr() == prev then
    -- the `--to=$KITTY_LISTEN_ON` env is passed automatically
    vim.fn.system("kitty @ kitten navigate.py cmd " .. mappings[direction])
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

  if modifier == nil then return end
  if direction == "h" or direction == "l" then
    vim.cmd("vertical resize " .. modifier .. "5")
  else
    vim.cmd("resize " .. modifier .. "5")
  end
end

local function test()
  vim.cmd("vsplit")
  vim.cmd("split")
  vim.cmd("wincmd j")
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
end

vim.api.nvim_create_user_command("KittyNavigateTop",
  function() navigate("k") end, {})
vim.api.nvim_create_user_command("KittyNavigateBottom",
  function() navigate("j") end, {})
vim.api.nvim_create_user_command("KittyNavigateLeft",
  function() navigate("h") end, {})
vim.api.nvim_create_user_command("KittyNavigateRight",
  function() navigate("l") end, {})

vim.api.nvim_create_user_command("KittyResizeTop",
  function() resize("k") end, {})
vim.api.nvim_create_user_command("KittyResizeBottom",
  function() resize("j") end, {})
vim.api.nvim_create_user_command("KittyResizeLeft",
  function() resize("h") end, {})
vim.api.nvim_create_user_command("KittyResizeRight",
  function() resize("l") end, {})

vim.api.nvim_create_user_command("KittyTest", test, {})
vim.keymap.set("n", "st", "<cmd>KittyTest<CR>")

local function set_map(key, cmd)
  vim.keymap.set("", "<C-S-M-w>" .. key, cmd .. "<CR>")
  vim.keymap.set("i", "<C-S-M-w>" .. key, "<Esc>" .. cmd .. "<CR>a")
end

-- Jumping
set_map("ju", "<cmd>KittyNavigateTop")
set_map("je", "<cmd>KittyNavigateBottom")
set_map("jn", "<cmd>KittyNavigateLeft")
set_map("ji", "<cmd>KittyNavigateRight")

-- Resizeing
set_map("ru", "<cmd>KittyResizeTop")
set_map("re", "<cmd>KittyResizeBottom")
set_map("rn", "<cmd>KittyResizeLeft")
set_map("ri", "<cmd>KittyResizeRight")

-- Moveing
set_map("mu", "<Nop>")
set_map("me", "<Nop>")
set_map("mn", "<Nop>")
set_map("mi", "<Nop>")
