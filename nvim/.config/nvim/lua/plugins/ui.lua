return {
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = {
					skip = true,
				},
			})

			opts.presets.lsp_doc_border = true
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>" },
			{ "<S_Tab>", "<Cmd>BufferLineCyclePrev<CR>" },
		},
		opts = {
			options = {
				mode = "tabs",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		priority = 1100,
		config = function()
			local lualine = require("lualine")

			local lsp = {
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
					local clients = vim.lsp.get_active_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				icon = " ",
			}

			local config = {
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { { "diff" }, "filename", "diagnostics" },
					lualine_x = { lsp, "filetype" },
					lualine_y = { "location", "progress" },
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			}

			lualine.setup(config)
		end,
	},
	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.scroll = {
				enable = false,
			}
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		opts = function(_, opts)
			local logo = [[
███╗   ███╗██╗ ██████╗ ██╗  ██╗██╗████████╗ ██████╗   
████╗ ████║██║██╔═══██╗██║  ██║██║╚══██╔══╝██╔═══██╗  
██╔████╔██║██║██║   ██║███████║██║   ██║   ██║   ██║  
██║╚██╔╝██║██║██║   ██║██╔══██║██║   ██║   ██║   ██║  
██║ ╚═╝ ██║██║╚██████╔╝██║  ██║██║   ██║   ╚██████╔╝  
╚═╝     ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝    ╚═════╝   
                                                      
██╗  ██╗██╗██████╗ ██╗███████╗██╗  ██╗███████╗██╗  ██╗
██║ ██╔╝██║██╔══██╗██║██╔════╝██║  ██║╚════██║██║  ██║
█████╔╝ ██║██████╔╝██║███████╗███████║    ██╔╝███████║
██╔═██╗ ██║██╔══██╗██║╚════██║╚════██║   ██╔╝ ╚════██║
██║  ██╗██║██║  ██║██║███████║     ██║   ██║       ██║
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝╚══════╝     ╚═╝   ╚═╝       ╚═╝
            ]]
			logo = string.rep("\n", 8) .. logo .. "\n\n"
			opts.config.header = vim.split(logo, "\n")
		end,
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{
				"<leader>a",
				"<cmd>AerialToggle<Cr>",
			},
		},
		config = function()
			local aerial = require("aerial")
			aerial.setup({
				on_attach = function(bufnr)
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
	},
}
