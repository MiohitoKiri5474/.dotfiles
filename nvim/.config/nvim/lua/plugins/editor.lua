return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      config = {
        cpp = "// %s",
      },
    },
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
    "laishulu/vim-macos-ime",
    config = function()
      vim.g.macosime_normal_ime = "com.apple.keylayout.ABC"
      vim.g.macosime_cjk_ime = "com.apple.inputmethod.TCIM.Zhuyin"
    end,
  },
  {
    "otavioschwanck/new-file-template.nvim",
    lazy = true,
    opts = {},
    event = "BufNewFile",
  },
  {
    "laishulu/vim-macos-ime",
    config = function()
      vim.g.macosime_normal_ime = "com.apple.keylayout.ABC"
      vim.g.macosime_cjk_ime = "com.apple.inputmethod.TCIM.Zhuyin"
    end,
  },
}
