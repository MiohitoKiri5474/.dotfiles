return {
	{
		"williamboman/mason.nvim",
		optional = true,
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "lua-language-server", "stylua" }) -- Lua related
				vim.list_extend(opts.ensure_installed, { "clangd", "clang-format" }) -- C/C++ related
				vim.list_extend(opts.ensure_installed, { "gopls", "golangci-lint-langserver" }) -- Golang related
				vim.list_extend(opts.ensure_installed, { "pyright", "black", "isort" }) -- Python related
				vim.list_extend(opts.ensure_installed, { "ltex-ls", "latexindent" }) -- LaTeX related
				vim.list_extend(
					opts.ensure_installed,
					{ "tailwindcss-language-server", "typescript-language-server", "css-lsp" }
				) -- CSS related
				vim.list_extend(opts.ensure_installed, { "typescript-language-server" }) -- typescript related
				vim.list_extend(opts.ensure_installed, { "astro-language-server" }) -- astro related
				vim.list_extend(opts.ensure_installed, { "eslint_d" }) -- javascript related
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.gopls.setup({
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
				autoformat = false,
			})
			lspconfig.clangd.setup({
				filetypes = { "c", "cpp" },
				cmd = { "clangd" },
				capabilities = vim.lsp.protocol.make_client_capabilities(),
				on_attach = function(client, bufnr)
					require("nvim-navic").attach(client, bufnr)
				end,
			})
			lspconfig.pyright.setup({})
			lspconfig.ltex.setup({
				filetypes = { "tex" },
				flags = { debounce_text_changes = 300 },
			})
			lspconfig.lua_ls.setup({})
			lspconfig.tsserver.setup({
				-- cmd = { "tsserver" },
				filetypes = { "typescript", "typescriptreact" },
			})
			lspconfig.astro.setup({})
		end,
	},
	"nvim-lua/lsp-status.nvim",
}
