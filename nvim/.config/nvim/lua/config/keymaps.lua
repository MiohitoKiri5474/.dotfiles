-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opt = { noremap = true, silent = true }

keymap.set("n", "<C-q>", ":q!<Return>", opt)
keymap.set("i", "<C-q>", "<esc>:q!<Return>", opt)

keymap.set("n", "<C-s>", ":w<Return>", opt)
keymap.set("i", "<C-s>", "<esc>:w<Return>", opt)

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

keymap.set("n", "te", ":tabedit<Return>", opt)
keymap.set("n", "<tab>", ":tabnext<Return>", opt)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opt)

keymap.set("n", "ss", ":split<Return>", opt)
keymap.set("n", "sv", ":vsplit<Return>", opt)

keymap.set("n", "<leader>t", ":TagbarToggle<cr>", opt)
