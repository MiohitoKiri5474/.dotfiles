### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

nvimUpdate() {
    nvim --headless "+Lazy! sync" "+MasonUpdate" +qa
}

brewUpdate() {
    brew update
    brew upgrade -y
    brew cleanup --prune=all &
}

dailyUpdate() {
    brewUpdate
    nvimUpdate &
    zinit self-update
    zinit update --parallel 3
}

create_latex_template() {
    filename=$1
    mkdir "$filename"
    ln ~/school_hw/latex_template/macros.tex ./"$filename"
    ln ~/school_hw/latex_template/preamble.tex ./"$filename"
    ln ~/school_hw/latex_template/letterfonts.tex ./"$filename"
    cp ~/school_hw/latex_template/template.tex ./"$filename"
}

bits-install() {
    cp -r ~/bits ~/.local/share/nvim/mason/packages/clangd/clangd_*/lib/clang/*/include/
}

# oh my posh: cache the init script per version, rebuilt when the config changes
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  () {
    local config=~/.config/ohmyposh/minimal-solarized-osaka.toml
    local cache=~/.cache/oh-my-posh/zsh-init-${commands[oh-my-posh]:A:h:h:t}.zsh
    if [[ ! -s $cache || $config -nt $cache ]]; then
      local init=$(oh-my-posh init zsh --config $config --print)
      # Strip the baked-in session ID; each shell sets its own below
      print -r -- ${init#export POSH_SESSION_ID=*;} >| $cache
    fi
    export POSH_SESSION_ID=$(uuidgen)
    source $cache
  }
fi

zinit light-mode for \
    zsh-users/zsh-autosuggestions \
    OMZL::history.zsh \
    zsh-users/zsh-history-substring-search \
    romkatv/zsh-defer \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    OMZL::completion.zsh \
    OMZL::key-bindings.zsh \
    OMZL::git.zsh \
    OMZ::plugins/git/git.plugin.zsh \
    OMZL::clipboard.zsh \
    OMZL::termsupport.zsh \
    OMZL::functions.zsh \
    OMZ::plugins/web-search/web-search.plugin.zsh

zinit wait lucid light-mode for \
    zsh-users/zsh-completions \
    zdharma-continuum/fast-syntax-highlighting \
    agkozak/zsh-z

zsh-defer zinit snippet OMZP::command-not-found

# Docker CLI completions
fpath=(~/.docker/completions $fpath)

# Rebuild the completion dump at most once a day; otherwise load it as-is
autoload -Uz compinit
() {
  setopt local_options extended_glob
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
}


alias "vim"="nvim"
alias "ls"="eza"
alias "ll"="eza -alh"
alias "lt"="eza --tree"
alias "ltl"="eza --tree --long"
alias "htop"="sudo btop"
alias "cat"="bat"

source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

function set_poshcontext() {
    export POSH=$(date)
}

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
zsh-defer -c 'eval "$(pyenv init - zsh)"'

zsh-defer -c 'eval "$(thefuck --alias)"'

source ~/.secrets
export EDITOR=nvim

# Open buffer line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

# Replace diff with difft
alias "diff"="difft"

export PATH="/opt/homebrew/opt/lua@5.1/bin:$PATH"
export PATH="/opt/homebrew/opt/lua@5.4/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Clean up stale pyenv lock on startup
[[ -f ~/.pyenv/shims/.pyenv-shim ]] && rm ~/.pyenv/shims/.pyenv-shim

export GITHUB_USERNAME="ardge-milolin"
export MIRROR_CONTAINER_REGISTRY="https://proxy.ardge.me"
