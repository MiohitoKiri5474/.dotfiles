return {
	{
		"williamboman/mason.nvim",
		optional = true,
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, {
					-- Lua related
					"lua-language-server",
					"stylua",
					"luacheck",
					-- C/C++ related
					"clangd",
					"clang-format",
					-- Golang related
					"gopls",
					"golangci-lint-langserver",
					-- Python related
					"pyright",
					"black",
					"isort",
					-- LaTeX related
					"ltex-ls",
					"latexindent",
					-- CSS related
					"typescript-language-server",
					"css-lsp",
					-- TailWindCSS related
					"tailwindcss-language-server",
					"astro-language-server",
					-- JavaScript related
					"eslint_d",
					-- sh related
					"shfmt",
					"shellcheck",
				})
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = true },
			---@type lspconfig.options
			servers = {
				cssls = {},
				html = {},
				pyright = {},
				gopls = {
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
					autoformat = false,
				},
				ltex = {
					filetypes = { "tex" },
					flags = { debounce_text_changes = 300 },
				},
				tsserver = {
					cmd = { "tsserver" },
					filetypes = { "typescript", "typescriptreact" },
				},
				astro = {},
				clangd = {
					filetypes = { "c", "cpp" },
					cmd = { "clangd" },
					capabilities = vim.lsp.protocol.make_client_capabilities(),
				},
				lua_ls = {
					-- enabled = false,
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {
									-- "--log-level=trace",
								},
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
			},
			setup = {},
		},
	},
	"nvim-lua/lsp-status.nvim",
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
		end,
	},
}
