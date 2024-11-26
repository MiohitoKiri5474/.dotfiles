return {
	"kelvinauta/focushere.nvim",
	config = function()
		require("focushere").setup()
		-- Optional KeyMap
		vim.keymap.set("v", "zf", ":FocusHere<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "zf", ":FocusClear<CR>", { noremap = true, silent = true })
	end,
}
