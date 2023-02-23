-- leader key
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>")

-- special keys
vim.keymap.set("n", ";", ":")

-- reserved keys
vim.keymap.set("n", "s", "<Nop>")
vim.keymap.set("n", "S", "<Nop>")
vim.keymap.set("n", "u", "<Nop>")
vim.keymap.set("n", "U", "<Nop>")

-- up, down, left, right
vim.keymap.set("", "i", "k")
vim.keymap.set("", "I", "5k")
vim.keymap.set("", "k", "j")
vim.keymap.set("", "K", "5j")
vim.keymap.set("", "j", "h")
vim.keymap.set("", "J", "^")
vim.keymap.set("", "l", "l")
vim.keymap.set("", "L", "$")

-- insert mode keys
vim.keymap.set("", "n", "i")
vim.keymap.set("", "N", "I")
vim.keymap.set("", "m", "o")
vim.keymap.set("", "M", "O")

vim.keymap.set("n", "<C-j>", "I")
vim.keymap.set("i", "<C-j>", "<Esc>I")
vim.keymap.set("n", "<C-l>", "A")
vim.keymap.set("i", "<C-l>", "<Esc>A")

-- visual mode keys
vim.keymap.set("v", "<C-i>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '>+1<CR>gv=gv")

-- redo, undo
vim.keymap.set("", "o", "u")
vim.keymap.set("", "O", "<C-r>")

-- search keys
vim.keymap.set("n", "-", "nzz")
vim.keymap.set("n", "=", "Nzz")
vim.keymap.set("n", ",c", ":nohlsearch<CR>")

