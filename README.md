# MiohitoKiri5474's dotfile

If you want to use any configuration of this repo, please replace files/folders to the right position.

## tmux & zsh

These are the minimal configuration.

## nvim

This configuration is base on [LazyVim](lazyvim.org) with some modify.

![](/images/cover.png)
![](/images/lazy-nvim.png)
![](/images/fuzzy.png)
![](/images/shot-1.png)
![](/images/shot-2.png)

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
brew bundle --file ~/myFolder/Brewfile
```

3. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

4. Install `tpm` for tmux.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

4. Install packages for zsh.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

5. Use `stow` to deploy all config files.

```sh
cd .dotfiles
stow zsh nvim tmux clangd tmux zathura
```

5. Replace iTerm2 colorscheme with [Solarized](https://github.com/altercation/solarized)
   > I prefer darker background. Here is my background color Hex code: #001a20.

### Ubuntu

1. Install packages with apt.

```sh
# install NeoVim Nightly
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update

sudo apt install neovim

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

sudo apt install git python3 python3-venv stow nodejs npm curl build-essential golang
```

2. Clone dotfiles into home folder at localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

3. Install `tpm` for tmux.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

3. Install packages for zsh.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

4. Use `stow` to deploy all config files.

```sh
cd .dotfiles
stow zsh nvim tmux clangd tmux
```
