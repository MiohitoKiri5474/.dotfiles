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
keymap.set("n", "<tab>", ":tabnext<Return>", opt)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opt)

keymap.set("n", "<leader>cp", "gg0vG$y<Return>", opt)

keymap.set("v", "<leader>sc", ":Silicon<Return>", opt)

-- in your neovim config
local function navigate(dir)
  local ghostty_dir = { h = "left", j = "bottom", k = "top", l = "right" }
  -- try to move within neovim first
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  if vim.api.nvim_get_current_win() == cur_win then
    -- didn't move, tell ghostty to navigate
    io.write("\x1b]1337;GhosttyNavigate=" .. ghostty_dir[dir] .. "\x07")
  end
end

vim.keymap.set("n", "<C-h>", function()
  navigate("h")
end)
vim.keymap.set("n", "<C-j>", function()
  navigate("j")
end)
vim.keymap.set("n", "<C-k>", function()
  navigate("k")
end)
vim.keymap.set("n", "<C-l>", function()
  navigate("l")
end)
