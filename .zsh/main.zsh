autoload -U compinit promptinit
compinit

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
setopt correctall

# Plugin
PLUGINS=(git)
PLUGIN_DIR=~/.zsh/ext
for plugin in $PLUGINS; do
    source $PLUGIN_DIR/$plugin.zsh
done

source ~/.zsh/ext/git-prompt/zshrc.sh
export __GIT_PROMPT_DIR=$HOME/.zsh/ext/git-prompt
# Combined left and right prompt configuration.
local smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg[white]%}%{$fg_bold[blue]%}%(!.%~.%1~) ${smiley}%b$(git_super_status)%# '

# RVM as user
export PATH="$HOME/.rbenv/bin:$PATH:$HOME/develop/dot_files/bin"
eval "$(rbenv init -)"
unset RUBYOPT

# Exports
export HISTSIZE=20000
export SAVEHIST=20000
export HISTFILE="$HOME/.history"

export BROWSER="/usr/bin/chromium"
export LAUNCHY_BROWSER="/usr/bin/chromium"
export EDITOR="editor"

# Ruby hacks
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_FREE_MIN=200000

# code highlighting in less
export LESSOPEN="|code2color %s"

# ---[ Alias Section ]-------------------------------------------------
eval `dircolors`
alias c='clear'
alias ls="ls -h --color=auto"
alias L="less -N"
alias psg="ps aux | egrep -i --color"
alias cpwd="pwd|xclip -i"
alias ppwd="xclip -o"
alias tmux="TERM=xterm-256color tmux"
alias tmuxa="tmux attach || tmux new"

# Git aliases
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'

#Rails helpers
alias be='bundle exec'
alias rails='be rails'
alias rake='be rake'
alias cap='be cap'

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
