return {
	{
		"williamboman/mason.nvim",

		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")

			mason.setup({
				ui = {
					icons = {
						server_installed = "✓",
						server_pending = "➜",
						server_uninstalled = "✗",
					},
				},
			})
			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "pyright", "gopls" },
				automatic_installation = true,
			})
		end,
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "black")
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
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.black,
				},
			})
		end,
	},
}
