return {
	"stevearc/conform.nvim",
	optional = true,
	opts = {
		formatters_by_ft = {
			c = { "clang_format" },
			h = { "clang_format" },
			lua = { "stylua" },
			go = { "gofumpt" },
		},
	},
	keys = {
		{
			"<leader>ft",
			function()
				require("conform").format()
			end,
		},
	},
}
