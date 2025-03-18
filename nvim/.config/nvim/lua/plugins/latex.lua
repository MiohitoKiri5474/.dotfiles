return {
  "lervag/vimtex",
  lazy = false, -- Load VimTeX on startup
  config = function()
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_view_general_viewer = "/Applications/Skim.app/Contents/MacOS/Skim"
    vim.g.vimtex_view_general_options = "--reuse-instance"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdf",
        "-shell-escape",
        "-interaction=nonstopmode",
        "-synctex=1",
      },
    }
  end,
  keys = {
    {
      "<leader>vt",
      ":VimtexCompile<Return>",
    },
  },
}
