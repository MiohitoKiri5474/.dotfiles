# MiohitoKiri5474's dotfile

If you want to use any configuration of this repo, please replace files/folders to the right position.

## Tools Overview

### tmux & zsh

Minimal configuration. Tmux uses the [solarized-osaka-tmux](https://github.com/MiohitoKiri5474/solarized-osaka-tmux) theme and includes popup windows:

- `prefix+g` — opens lazygit in a popup
- `prefix+y` — opens Claude Code in a popup (session-scoped, persists between popups)

### nvim

Based on [LazyVim](https://lazyvim.org) with customizations. Uses **Claude Code** as the AI assistant (replaced GitHub Copilot).

### Ghostty

Terminal emulator with a custom Iosevka font (Customize Iosevka) and Solarized Dark theme. Keybinds are mapped to tmux commands (Cmd+T for new window, Cmd+W to close pane, etc.).

### AeroSpace

Tiling window manager for macOS. Workspaces:

- `1–5` — general
- `A` — Arc Browser / Safari
- `C` — Claude desktop
- `D` — Discord / Messenger / Line
- `S` — Spotify
- `T` — Terminal (Ghostty)

## Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [LazyVim](https://www.lazyvim.org/)
- [Iosevka Custom font](https://github.com/be5invis/Iosevka) — build with the "JavaScript" stylistic set, or use any [Nerd Font](https://www.nerdfonts.com/) (v3.0 or greater)
- a **C** compiler for `nvim-treesitter`. [More information](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- Node.js & NPM
- Python3, pip3, python3-venv
- Golang
- Rust
  - Recommend using install [script](https://www.rust-lang.org/tools/install)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- [macsim](https://github.com/laishulu/macism/)
  - Switch input source automatically (Traditional Chinese and English).

## Usage

### macOS

1. Install HomeBrew.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

1. Install packages with brew.

```sh
# Install essential package
brew tap zegervdv/zathura
brew install neovim tmux hammerspoon karabiner-elements zathura btop bat wget eza ghostty stow clangd fzf pyenv lazygit

# Install require pacakge for neovim plugins (telescope etc.)
brew install fd ripgrep luarocks

# Install require package for tmux theme
brew install bash bc coreutils gawk gh glab gsed jq nowplaying-cli

# Install Aerospace
brew install nikitabobko/tap/aerospace

# Install Oh my Posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Install macsim for NeoVim
brew tap laishulu/homebrew
brew install macism

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# NodeJS install, including nvm, npm and nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
brew install nodejs
```

1. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

1. Use `stow` to deploy all config files.

```sh
cd .dotfiles

stow zsh nvim tmux clangd zathura hammerspoon aerospace karabiner ghostty lazygit
```

### Ubuntu

> I only install necessary package (editor, shell, tmux etc.) on Ubuntu because I only use it as remote server.

1. Install packages with apt.

```sh
# Install neovim nightly instead of stable version for some extra features
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt install neovim bat tmux eza wget btop stow unzip zip fzf zsh golang

# Install require pacakge for neovim plugins (telescope etc.)
sudo apt install fd-find ripgrep luarocks

# Install require package for tmux theme
sudo apt install bash bc coreutils gawk git jq playerctl

# Install Oh my Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install pyenv
curl -fsSL https://pyenv.run | bash

# NodeJS install, including nvm, npm and nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
sudo apt install nodejs npm

# Install tmux-plugin-manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

1. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

1. Use stow to deploy all config files.

```sh
cd .dotfiles

stow zsh nvim tmux clangd
```

### ArchLinux

> This script has not been verified yet.

> I only install necessary package (editor, shell, tmux etc.) on ArchLinux because I only use it as remote server.

1. Install packages with apt.

```sh
# install yay
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~

# Install neovim nightly instead of stable version for some extra features
yay -S neovim-nightly
sudo pacman -S bat tmux eza wget btop stow unzip zip fzf zsh golang

# Install require pacakge for neovim plugins (telescope etc.)
sudo pacman -S fd-find ripgrep luarocks

# Install require package for tmux theme
sudo pacman -S bash bc coreutils gawk git jq playerctl

# Install Oh my Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install pyenv
curl -fsSL https://pyenv.run | bash

# NodeJS install, including nvm, npm and nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
sudo pacman -S nodejs npm

# Install tmux-plugin-manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

1. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

1. Use stow to deploy all config files.

```sh
cd .dotfiles

stow zsh nvim tmux clangd
```
