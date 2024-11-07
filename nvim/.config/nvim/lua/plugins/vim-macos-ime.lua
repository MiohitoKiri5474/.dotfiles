return {
	"laishulu/vim-macos-ime",
	config = function()
		vim.g.macosime_normal_ime = "com.apple.keylayout.ABC"
		vim.g.macosime_cjk_ime = "com.apple.inputmethod.TCIM.Zhuyin"
	end,
}
