-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opt = { noremap = true, silent = true }

keymap.set("n", "<C-q>", ":q!<Return>", opt)
keymap.set("i", "<C-q>", "<esc>:q!<Return>", opt)

keymap.set("n", "<C-s>", ":w<Return>", opt)
keymap.set("i", "<C-s>", "<esc>:w<Return>", opt)

keymap.set("n", "te", ":tabedit<Return>", opt)

keymap.set("n", "<leader>cp", "gg0vG$y<Return>", opt)

keymap.set("v", "<leader>sc", ":Silicon<Return>", opt)
