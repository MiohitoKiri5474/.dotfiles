# MiohitoKiri5474's dotfile

If you want to use any configuration of this repo, please replace files/folders to the right position.

## tmux & zsh

These are minimal setting configuration.

## nvim

This configuration is base on [LazyVim](lazyvim.org) with some modify.

![](/images/cover.png)
![](/images/lazy-nvim.png)
![](/images/fuzzy.png)
![](/images/shot-1.png)
![](/images/shot-2.png)

## Usage

1. Install HomeBrew first. [Install HomeBrew](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install package with brew.

```sh
brew bundle --file ~/myFolder/Brewfile
```

3. Clone dotfiles into localhost.

```sh
git clone https://github.com/MiohitoKiri5474/.dotfiles.git
```

4. Use `stow` to deploy all config files.

```sh
cd .dotfiles
stow */
```

5. Replace iTerm2 colorscheme with [Solarized](https://github.com/altercation/solarized)
   > I prefer make background more darker. Here is my background color Hex code: #001a20.
