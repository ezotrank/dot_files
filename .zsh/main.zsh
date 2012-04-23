autoload -U compinit promptinit
compinit
promptinit; prompt gentoo
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
setopt correctall

source ~/.zsh/ext/git-prompt/zshrc.sh
export __GIT_PROMPT_DIR=$HOME/.zsh/ext/git-prompt
prompt_gentoo_user=${2:-'green'}
prompt_gentoo_prompt=${1:-'blue'}
base_prompt="%B%F{$prompt_gentoo_user}%n@%m%k "
post_prompt="%b%f%k"
path_prompt="%B%F{$prompt_gentoo_prompt}%1~"
PROMPT='$base_prompt$path_prompt $(git_super_status)%# $post_prompt'

# RVM as user
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
unset RUBYOPT

# Exports
export HISTSIZE=2000
export SAVEHIST=1000
export HISTFILE="$HOME/.history"

export BROWSER="/usr/bin/chromium"
export LAUNCHY_BROWSER="/usr/bin/chromium"

# ruby and rails falcon path http://goo.gl/RLIvi
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000


# Code highlighting in less
export LESSOPEN="|code2color %s"

# ---[ Alias Section ]-------------------------------------------------
eval `dircolors`
alias c='clear'
alias ls="ls -h --color=auto"
alias L="less"
alias psg="ps aux | egrep -i --color"	

# User ext scripts
PLUGINS=(rvm git)
PLUGIN_DIR=~/.zsh/ext
for plugin in $PLUGINS; do
    source $PLUGIN_DIR/$plugin.zsh
done

setopt hist_ignore_all_dups
setopt autocd

# ---[ Terminal settings ]---------------------------------------------
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
