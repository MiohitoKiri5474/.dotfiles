return {
	{
		"williamboman/mason.nvim",
		optional = true,
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "clangd", "clang-format" }) -- C/C++ related
				vim.list_extend(opts.ensure_installed, { "gopls", "golangci-lint-langserver" }) -- Golang related
				vim.list_extend(opts.ensure_installed, { "pyright", "black", "isort" }) -- Python related
				vim.list_extend(opts.ensure_installed, { "ltex-ls", "latexindent" }) -- LaTeX related
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
			lspconfig.pyright.setup({})
			lspconfig.ltex.setup({})
		end,
	},
	"nvim-lua/lsp-status.nvim",
}
