return {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  keys = {
    {
      "<leader>n",
      function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      desc = "Incremental rename",
      mode = "n",
      noremap = true,
      expr = true,
    },
  },
  config = true,
}
