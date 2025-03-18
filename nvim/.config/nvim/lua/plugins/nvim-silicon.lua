return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  config = function()
    require("silicon").setup({
      -- Configuration here, or leave empty to use defaults
      font = "SauceCodePro Nerd Font=34;SauceCOdePro Nerd Font=34",
      to_clipboard = true,
      theme = "Solarized (dark)",
      background = "#0d90b2",
      output = function()
        return "~/Desktop/" .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_code.png"
      end,
    })
  end,
}
