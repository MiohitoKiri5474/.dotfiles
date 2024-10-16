# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.zsh_history

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

export_init() {
    export PATH="/Users/mac/Yinge/cli/bin:$PATH"
    autoload -U compinit; compinit

    export PATH="$HOME/.ycli/release:$PATH"

    eval $(thefuck --alias)

    if command -v ngrok &>/dev/null; then
        eval "$(ngrok completion)"
    fi

    export PATH=$PATH:$HOME/.local/bin

    export N_PREFIX=$HOME/.n
    export PATH=$N_PREFIX/bin:$PATH
}

dailyUpdate() {
    speedtest
    brew update
    brew upgrade
    zinit self-update
    zinit update --parallel 10
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
    cp -r ~/bits ~/.local/share/nvim/mason/packages/clangd/clangd_18.1.3/lib/clang/18/include/
}

zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


zinit light-mode for \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-history-substring-search \
    zdharma-continuum/fast-syntax-highlighting \
    agkozak/zsh-z \
    romkatv/zsh-defer


zinit lucid wait for \
    OMZL::completion.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::git.zsh \
    OMZ::plugins/git/git.plugin.zsh \
    OMZL::clipboard.zsh \
    OMZL::termsupport.zsh \
    OMZL::functions.zsh \
    OMZ::plugins/web-search/web-search.plugin.zsh
    # OMZL::theme-and-appearance.zsh \


zsh-defer export_init


alias "vim"="nvim"
alias "ls"="exa"
alias "ll"="exa -alh"
alias "lt"="exa --tree"
alias "ltl"="exa --tree --long"
alias "htop"="sudo btop"
alias "cat"="bat"

source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
