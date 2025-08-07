# MiohitoKiri5474's dotfile

If you want to use any configuration of this repo, please replace files/folders to the right position.

## tmux & zsh

These are the minimal configuration.

## nvim

This configuration is base on [LazyVim](lazyvim.org) with some modify.

## Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [LazyVim](https://www.lazyvim.org/)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater)
  I'm using SauceCode Pro.
- a **C** compiler for `nvim-treesitter`. [More information](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- Node.js & NPM
- Python3, pip3, python3-venv
- Golang
- Rust
  - Recommend using install [script](https://www.rust-lang.org/tools/install)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- [macsim](https://github.com/laishulu/macism/)
  - Switch input source automatically (Traditional Chinese and English).

## Usage

### macOS

1. Install HomeBrew.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install packages with brew.

```sh
# Install essential package
brew tap zegervdv/zathura
brew install neovim tmux hammerspoon karabiner-elements zathura btop bat wget eza ghostty stow clangd

# Install require pacakge for telescope (neovim plugin)
brew install fd ripgrep

# Install require package for tmux theme
brew install bash bc coreutils gawk gh glab gsed jq nowplaying-cli

# Install Aerospace
brew install nikitabobko/tap/aerospace

# Install Oh my Posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Install macsim for NeoVim
brew tap laishulu/homebrew
brew install macism

# Rust install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# NodeJS install, including nvm, npm and nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
brew install nodejs
```

3. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

4. Use `stow` to deploy all config files.

```sh
cd .dotfiles

stow zsh nvim tmux clangd zathura yazi hammerspoon aerospace karabiner ghostty
```

### Ubuntu

> I only install necessary package (editor, shell, tmux etc.) on Ubuntu because I only use it for remote server.

1. Install packages with apt.

```sh
# install neovim nightly instead of stable version for some extra features
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt install neovim bat tmux eza wget btop stow unzip zip

# Install require pacakge for telescope (neovim plugin)
sudo apt install fd-find ripgrep

# Install require package for tmux theme
sudo apt install bash bc coreutils gawk git jq playerctl

# Install Oh my Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Rust install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#NodeJS install, including nvm, npm and nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
sudo apt install nodejs npm
```

2. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

3. Use stow to deploy all config files.

```sh
cd .dotfiles

stow zsh nvim tmux clangd
```
