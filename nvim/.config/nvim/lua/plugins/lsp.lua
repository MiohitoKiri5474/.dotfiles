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
				ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "gopls" },
				automatic_installation = true,
			})
		end,
		opts = function(_, opts)
			table.insert(opts.ensure_installed, { "black", "clang-format", "isort" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.gopls.setup({})
			lspconfig.clangd.setup({
				cmd = {
					"clangd",
				},
				capabilities = vim.lsp.protocol.make_client_capabilities(),
				on_attach = function(client, bufnr)
					require("nvim-navic").attach(client, bufnr)
				end,
			})
			lspconfig.rust_analyzer.setup({
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
			-- null_ls.formatters.setup({
			-- 	{
			-- 		name = "black",
			-- 		args = { "--line-length", "120" },
			-- 	},
			-- 	{ name = "isort" },
			-- 	{
			-- 		name = "clang_format",
			-- 		timeout = 10000,
			-- 		filetypes = { "c", "cpp", "objc", "objcpp", "java" },
			-- 	},
			-- })
		end,
	},
}
