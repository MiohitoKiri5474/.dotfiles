return {
	{
		"williamboman/mason.nvim",
		optional = true,
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "clangd", "clang-format" }) -- C/C++ related
				vim.list_extend(opts.ensure_installed, { "gopls", "golangci-lint-langserver" }) -- Golang related
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
				autoformat = false,
			})
			lspconfig.clangd.setup({
				cmd = { "clangd" },
				capabilities = vim.lsp.protocol.make_client_capabilities(),
				on_attach = function(client, bufnr)
					require("nvim-navic").attach(client, bufnr)
				end,
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
					null_ls.builtins.formatting.isort,
				},
			})
		end,
	},
}
