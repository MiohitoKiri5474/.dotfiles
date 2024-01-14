return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"clangd",
				"shfmt",
				"black",
				"isort",
				"pylint",
				"css-lsp",
			})
		end,
	},
	{

		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig")
			require("lspconfig").lua_ls.setup({})
			require("lspconfig").pyright.setup({})
			require("lspconfig").gopls.setup({})
			require("lspconfig").clangd.setup({})
			require("lspconfig").rust_analyzer.setup({
				-- Server-specific settings. See `:help lspconfig-setup`
				settings = {
					["rust-analyzer"] = {},
				},
			})
		end,
	},
	"nvim-lua/lsp-status.nvim",
}
