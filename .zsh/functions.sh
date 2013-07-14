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

function refresh_aliases() {
    source ~/.zsh/aliases.sh
}

function refresh_functions() {
    source ~/.zsh/functions.sh
}

function git_squash_log() {
  git log --pretty=oneline --abbrev-commit $*
}

function github_file() { 
  file=$(git ls-tree --name-only --full-name HEAD file $*)
  repo=$(git remote -v|head -n 1 | sed -n 's/git@github.com:\(.*\).git/\1/p'|awk '{print $2}')
  branch=$(git rev-parse --abbrev-ref HEAD)
  url="https://github.com/$repo/blob/$branch/$file"
  echo $url
}