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
brew install neovim tmux yazi hammerspoon karabiner-elements yazi zathura btop bat

# Rust install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

````

3. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
````

4. Install packages for zsh.

```sh
# Install Oh my Posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
```

5. Use `stow` to deploy all config files.

```sh
cd .dotfiles
stow zsh nvim tmux clangd tmux zathura yazi hammerspoon aerospace karabiner
```

5. Replace iTerm2 colorscheme with [Solarized](https://github.com/altercation/solarized)
   > I prefer darker background. Here is my background color Hex code: #06191f.

### Ubuntu

1. Install packages with apt.

```sh
# install require packages
sudo apt install git python3 python3-venv stow nodejs npm curl build-essential golang unzip zsh tmux fzf yazi ripgrep fd-find

# install NeoVim Nightly
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt install neovim

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# Rust install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

2. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

3. Install packages for zsh, and set zsh as default shell.

```sh
# Install Oh my Posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
```

4. Use `stow` to deploy all config files.

```sh
cd .dotfiles
stow zsh nvim tmux clangd tmux zathura yazi
```
