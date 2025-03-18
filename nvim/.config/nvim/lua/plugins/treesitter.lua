return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "javascript",
      "typescript",
      "graphql",
      "http",
      "astro",
      "cmake",
      "c",
      "cpp",
      "css",
      "json",
      "gitignore",
      "vim",
      "go",
      "graphql",
      "http",
      "java",
      "php",
      "rust",
      "scss",
      "sql",
      "svelte",
      "fish",
      "lua",
      "python",
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
  },
  confirg = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    vim.filetype.add({
      extension = {
        mdx = "mdx",
      },
    })
    vim.treesitter.language.register("markdown", "mdx")
  end,
}
