return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      c = { "clang_format" },
      h = { "clang_format" },
      lua = { "stylua" },
      go = { "gofumpt" },
      python = { "isort", "black" },
      tex = { "latexindent" },
      mjs = { "eslint_d" },
      html = { "prettier" },
      astro = { "prettier" },
      javascript = { "prettier" },
    },
  },
  keys = {
    {
      "<leader>ft",
      function()
        require("conform").format()
      end,
    },
  },
}
