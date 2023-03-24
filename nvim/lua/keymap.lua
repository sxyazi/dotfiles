-- leader key
vim.g.mapleader = " "
vim.keymap.set("", "<Space>", "<Nop>")

-- special keys
vim.keymap.set("n", ";", ":")
vim.keymap.set("", "<Tab>", "<Nop>") -- Will be handled in `plugins/completion.lua`

-- reserved keys
vim.keymap.set("", "s", "<Nop>")
vim.keymap.set("", "S", "<Nop>")
vim.keymap.set("", "o", "<Nop>")
vim.keymap.set("", "O", "<Nop>")

-- up, down, left, right
vim.keymap.set("", "u", "k")
vim.keymap.set("", "U", "5k")
vim.keymap.set("", "e", "j")
vim.keymap.set("", "E", "5j")
vim.keymap.set("", "n", "h")
vim.keymap.set("", "N", "^")
vim.keymap.set("", "i", "l")
vim.keymap.set("", "I", "$")

vim.keymap.set("n", "<C-u>", "5<C-y>")
vim.keymap.set("v", "<C-u>", "5<C-y>")
vim.keymap.set("i", "<C-u>", "<Esc>5<C-y>a")
vim.keymap.set("n", "<C-e>", "5<C-e>")
vim.keymap.set("v", "<C-e>", "5<C-e>")
vim.keymap.set("i", "<C-e>", "<Esc>5<C-e>a")

-- word navigation keys
vim.keymap.set("", "h", "e")
vim.keymap.set("n", "W", "5w")
vim.keymap.set("n", "B", "5b")

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
vim.keymap.set("v", "<C-u>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<C-e>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- redo, undo
vim.keymap.set("n", "l", "u", { noremap = true })
vim.keymap.set("n", "L", "<C-r>", { noremap = true })

-- yank, paste
vim.keymap.set("", "Y", '"+y')
vim.keymap.set("x", "p", '"_dp')
vim.keymap.set("x", "P", '"_dP')
vim.keymap.set("n", "x", '"_x')

-- search keys
vim.keymap.set({ "n", "v" }, "-", "n")
vim.keymap.set({ "n", "v" }, "=", "N")

-- tab management
vim.keymap.set({ "n", "v" }, "tt", ":tabe<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "tT", ":tab split<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "tn", ":-tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "ti", ":+tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "tN", ":-tabmove<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "tI", ":+tabmove<CR>", { noremap = true, silent = true })

-- other keys
vim.keymap.set("", "<C-S-M-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-S-M-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })
