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

nvimUpdate() {
    nvim --headless "+Lazy! sync" +qa
}


dailyUpdate() {
    brew update
    brew upgrade
    brew cleanup &
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

# oh my posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/minimal-solarized-osaka.toml)"
fi


zinit light-mode for \
    OMZL::history.zsh \
    zsh-users/zsh-history-substring-search \
    romkatv/zsh-defer

zinit wait lucid for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting \
    agkozak/zsh-z \
    OMZL::completion.zsh \
    OMZL::key-bindings.zsh \
    OMZL::git.zsh \
    OMZ::plugins/git/git.plugin.zsh \
    OMZL::clipboard.zsh \
    OMZL::termsupport.zsh \
    OMZL::functions.zsh \
    OMZ::plugins/web-search/web-search.plugin.zsh


zsh-defer export_init


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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"

PATH="/Users/miohitokiri5474/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/miohitokiri5474/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/miohitokiri5474/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/miohitokiri5474/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/miohitokiri5474/perl5"; export PERL_MM_OPT;


# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

