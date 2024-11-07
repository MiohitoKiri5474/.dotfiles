return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"craftzdog/solarized-osaka.nvim",
		"nvim-tree/nvim-web-devicons",
	},
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
				lualine_c = { { "diff", "diagnostics" }, "filename", "aerial" },
				lualine_x = { lsp, "filetype" },
				lualine_y = { "location", "progress" },
				lualine_z = { "encoding", "filesize" },
			},
		}

		lualine.setup(config)
	end,
}
