# Solarized Osaka Tmux

This theme is forked from [jenoamaral/tokyo-night-tmux](https://github.com/janoamaral/tokyo-night-tmux), replace color scheme tokyo-night with [craftzdog/solarized-osaka.nvim](https://github.com/craftzdog/solarized-osaka.nvim).

All configure options are same as tokyo-night-tmux, but the suffix is `solarized-osaka-tmux` instead of `tokyo-night-tmux`.

## Requirements

### macOS

macOS still ships with bash 3.2 so you must provide a newer version.
You can easily install all dependencies via [Homebrew]:

```bash
brew install --cask font-monaspace-nerd-font font-noto-sans-symbols-2
brew install bash bc coreutils gawk gh glab gsed jq nowplaying-cli
```

### Linux

#### Alpine Linux

```bash
apk add bash bc coreutils gawk git jq playerctl sed
```

#### Arch Linux

```bash
pacman -Sy bash bc coreutils git jq playerctl
```

#### Ubuntu

```bash
apt-get install bash bc coreutils gawk git jq playerctl
```
