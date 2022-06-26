#!/bin/bash
# B"H

function Dcdi(){
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p| grep --color=never '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}


function Dcdtree(){
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(ls -pa)
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                cdtreeIsFile -f $__cd_path;
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}


function Dcdall(){
    dir=${1:-"/"}
    dir=$(find ~+ $dir -type d 2> /dev/null | fzf)
    cd $dir
}

function Fshowallfiles(){
    basedir="./"
    dir=${1:-"./"}
    find ~+ $dir -type f 2> /dev/null | fzf --preview 'bat --style numbers,changes --color=always {}'
}


function Fshowlocalfiles(){
    basedir="./"
    dir=${1:-"./"}
    fzf --preview 'bat --style numbers,changes --color=always {}'
}


# _fzf_comprun() {
#   local command=$1
#   shift

#   case "$command" in
#     cdall)        find ~+ $dir -type d 2> /dev/null | fzf ;;
#     *)            fzf "$@" ;;
#   esac
# }


# vf - fuzzy open with vim from anywhere
# ex: vf word1 word2 ... (even part of a file name)
# zsh autoload function
Fvf(){
  local files

  files=($(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m))

  if [[ -n $files ]]
  then
     vim -- $files
     print -l $files[1]
  fi
}


# vf - fuzzy open with vim from anywhere
# ex: vf word1 word2 ... (even part of a file name)
# zsh autoload function
Fvfs(){
  local files

  files=($(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m))

  if [[ -n $files ]]
  then
     sudo vim -- $files
     printf "$files\n"
  fi
}


# Open file with vim
Fe() {
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Open file with vim alternative
Fed() {
  local file=$(fzf)
  vim $file
}