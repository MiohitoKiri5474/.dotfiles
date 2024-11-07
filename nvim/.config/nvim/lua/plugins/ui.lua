return {
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
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
}
