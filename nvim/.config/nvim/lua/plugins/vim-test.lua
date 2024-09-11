return {
	"vim-test/vim-test",
	dependencies = {
		"preservim/vimux",
	},
	keys = {
		{ "<leader>t", ":TestNearest<CR>" },
		{ "<leader>T", ":TestFile<CR>" },
		{ "<leader>a", ":TestSuite<CR>:" },
		{ "<leader>L", ":TestLast<CR>" },
		{ "<leader>g", "::TestVisit<CR>" },
	},
	config = function()
		vim.cmd("let test#strategy = 'vimux'")
	end,
}
