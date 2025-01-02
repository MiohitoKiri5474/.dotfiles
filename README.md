# MiohitoKiri5474's dotfile

If you want to use any configuration of this repo, please replace files/folders to the right position.

## tmux & zsh

These are the minimal configuration.

## nvim

This configuration is base on [LazyVim](lazyvim.org) with some modify.

![cover](/images/cover.png)
![fuzzy](/images/fuzzy.png)
![fzf](/imagus/fzf.png)
![syntax-error](/images/syntax-error.png)
![tag](/images/tag.png)
![terminal-split](/images/terminal-split.png)
![test](/images/test.png)

## Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [LazyVim](https://www.lazyvim.org/)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater) **_(optional, but needed to display some icons)_**
  I'm using SauceCode Pro.
- a **C** compiler for `nvim-treesitter`. [More information](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- Node.js & NPM
- Python3, pip3, python3-venv
- Golang
- Rust
  - Recommend using install [script](https://www.rust-lang.org/tools/install)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)

## Usage

### macOS

1. Install HomeBrew.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install packages with brew.

```sh
# Install all package in Brewfile
brew bundle --file ./Brewfile

# Install essential package only
brew tap zegervdv/zathura
brew install neovim tmux yazi hammerspoon karabiner-elements yazi zathura btop bat wget eza
# Install require pacakge for telescope (neovim plugin)
brew install fd ripgrep
# Install require package for tmux theme
brew install bash bc coreutils gawk gh glab gsed jq nowplaying-cli
# Install Aerospace
brew install --cask nikitabobko/tap/aerospacebrew install --cask nikitabobko/tap/aerospace
# Install Oh my Posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Rust install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

3. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

4. Use `stow` to deploy all config files.

```sh
cd .dotfiles
stow zsh nvim tmux clangd tmux zathura yazi hammerspoon aerospace karabiner
```

6. Replace iTerm2 colorscheme with [Solarized](https://github.com/altercation/solarized) and pick a nerd font.
   > I prefer darker background. Here is my background color Hex code: #06191f.
   > The nerd font I'm using is JetBrainMono Nerd Font Mono.
