function rbenvinfo(){
    echo -e "rbenv ruby version: \033[1m`rbenv version|cut -f 1 -d ' ' -s`\033[0m
real ruby version: \033[1m`ruby --version`\033[0m
ruby gemsets: \033[1m`rbenv gemset active`\033[0m"
}

function biggest_folder(){
    maxdepth=1
    if [ $1 ]; then maxdepth=$1; fi
    find -maxdepth $maxdepth -type d -exec du -s {} \;|sort -n -r
}

function zsh_refresh_aliases(){
    source ~/.zsh/aliases.sh
}

function zsh_edit_aliases(){
    vim ~/.zsh/aliases.sh && zsh_refresh_aliases
}

function zsh_refresh_functions(){
    source ~/.zsh/functions.sh
}

function zsh_edit_functions(){
    vim ~/.zsh/functions.sh && zsh_refresh_functions
}

function zsh_ping_google(){
  ping 8.8.8.8
}

function git_squash_log(){
  git log --pretty=oneline --abbrev-commit $*
}

function git_pull_rebase(){
  git fetch origin  && git pull --rebase origin "$(git rev-parse --abbrev-ref HEAD)"
}

function git_push(){
  git push origin "$(git rev-parse --abbrev-ref HEAD)"
}

function github_repo(){
  echo "$(git remote -v|head -n 1 | sed -n 's/git@github.com:\(.*\).git/\1/p'|awk '{print $2}')"
}

function github_repo_url(){
  echo "https://github.com/`github_repo`"
}

function github_file(){ 
  file=$(git ls-tree --name-only --full-name HEAD file $*)
  repo=$(git remote -v|head -n 1 | sed -n 's/git@github.com:\(.*\).git/\1/p'|awk '{print $2}')
  branch=$(git rev-parse --abbrev-ref HEAD)
  url="https://github.com/$repo/blob/$branch/$file"
  echo $url
}

function github_show_commit(){
  url="`github_repo_url`/commit/$1"
  echo $url|pbcopy
  open $url
}

function as_resolve_beta(){
  if [ "$(ssh-add -l &>/dev/null; echo $?)" -ne "0" ]; then `ssh-add &>/dev/null`; fi
  echo $(ssh aviasales@10.66.2.1 "beta list|grep ${1}")
}

function rails_logs(){
  tail -f log/*.log
}

function service_redis(){
  redis-server /usr/local/etc/redis.conf &>/dev/null &
}

function zsh_add_project(){
  [ ! -d ~/Development/.symlinks ] && mkdir -p ~/Development/.symlinks && echo "Dir created"
  if [ -n "$1" ]; then
    name="$1"
  else
    name="$(basename `pwd`)"
  fi
  ln -snf `pwd` ~/Development/.symlinks/$name
}

function zsh_list_projects(){
  ls -l ~/Development/.symlinks
}

function zsh_goto (){
  cd -P ~/Development/.symlinks/$1
}

function zsh_grep_history (){
  grep -i $1 ~/.history
}

function dash_search (){
  open "dash://$1:$2"
}

function as_scout (){
  curl -v "gominprices2.int.avs.io:3000/$1"
}
