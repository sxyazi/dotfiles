-- leader key
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>")

-- special keys
vim.keymap.set("n", ";", ":")

-- reserved keys
vim.keymap.set("n", "s", "<Nop>")
vim.keymap.set("n", "S", "<Nop>")
vim.keymap.set("n", "j", "<Nop>")
vim.keymap.set("n", "J", "<Nop>")
vim.keymap.set("i", "<C-u>", "<Nop>")
vim.keymap.set("i", "<C-e>", "<Nop>")
vim.keymap.set("c", "<C-u>", "<Nop>")
vim.keymap.set("c", "<C-e>", "<Nop>")

-- up, down, left, right
vim.keymap.set("", "u", "k")
vim.keymap.set("", "U", "5k")
vim.keymap.set("", "e", "j")
vim.keymap.set("", "E", "5j")
vim.keymap.set("", "n", "h")
vim.keymap.set("", "N", "^")
vim.keymap.set("", "i", "l")
vim.keymap.set("", "I", "$")

-- insert mode keys
vim.keymap.set("", "k", "i")
vim.keymap.set("", "K", "I")
vim.keymap.set("", "m", "o")
vim.keymap.set("", "M", "O")

vim.keymap.set("n", "<C-n>", "I")
vim.keymap.set("i", "<C-n>", "<Esc>I")
vim.keymap.set("n", "<C-i>", "A")
vim.keymap.set("i", "<C-i>", "<Esc>A")

-- visual mode keys
vim.keymap.set("v", "<C-u>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-e>", ":m '>+1<CR>gv=gv")

-- redo, undo
vim.keymap.set("", "y", "u")
vim.keymap.set("", "Y", "<C-r>")

-- search keys
vim.keymap.set("n", "-", "nzz")
vim.keymap.set("n", "=", "Nzz")
vim.keymap.set("n", ",c", ":nohlsearch<CR>")
