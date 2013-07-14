autoload -U compinit promptinit
compinit

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
setopt correctall

# Plugin
# PLUGINS=(git)
# PLUGIN_DIR=~/.zsh/ext
# for plugin in $PLUGINS; do
#     source $PLUGIN_DIR/$plugin.zsh
# done

source ~/.zsh/ext/git-prompt/zshrc.sh
export __GIT_PROMPT_DIR=$HOME/.zsh/ext/git-prompt
# Combined left and right prompt configuration.
local smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"
PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg[white]%}%{$fg_bold[blue]%}%(!.%~.%1~) ${smiley} $(git_super_status)%# '

# Rbenv
eval "$(rbenv init -)"
unset RUBYOPT

# Exports
export HISTSIZE=20000
export SAVEHIST=20000
export HISTFILE="$HOME/.history"

# setopt hist_ignore_all_dups
setopt autocd

# Ext
source ~/.zsh/aliases.sh
source ~/.zsh/functions.sh
