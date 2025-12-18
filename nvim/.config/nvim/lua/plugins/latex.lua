return {
  {
    "lervag/vimtex",
    lazy = false, -- Load VimTeX on startup
    config = function()
      vim.g.vimtex_view_general_viewer = "zathura"
      vim.g.vimtex_view_zathura_options = "-reuse-instance"
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_synctex = true
      vim.g.vimtex_compiler_method = "latexmk"
    end,
    keys = {
      {
        "<leader>vt",
        ":VimtexCompile<Return>",
      },
    },
  },
  {
    "3rd/image.nvim",
  },
}
