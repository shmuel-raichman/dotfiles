#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

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

    if command -v fd >/dev/null 2>&1; then 
        # If fd binary exist use fd
        dir=$(fd . ${dir} -t d -H | fzf)
    else 
        # If fd binary not exist use find
        dir=$(find ~+ $dir -type d 2> /dev/null | fzf)
    fi

    cd $dir
}

function Fshowfiles(){
    basedir="./"
    dir=${1:-"/"}

    if command -v fd >/dev/null 2>&1; then 
        # If fd binary exist use fd
        fd . ${dir} -t f -H --exclude '.git' | fzf --preview 'bat --style numbers,changes --color=always {}'
    else 
        # If fd binary not exist use find
        find ~+ $dir -type f 2> /dev/null | fzf --preview 'bat --style numbers,changes --color=always {}'
    fi
}


function Fshowlocalfiles(){
    basedir="./"
    dir=${1:-"./"}
    fzf --preview 'bat --style numbers,changes --color=always {}'
}

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

FLvim()
{
    vim $(exa -a --icons --group-directories-first | fzf | awk '{print $2}')
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


command -v rg >/dev/null 2>&1 && {
    # https://betterprogramming.pub/boost-your-command-line-productivity-with-fuzzy-finder-985aa162ba5d#1afd
    # Here’s a function fif by gbstan that combines ripgrep and fzf:
    # find-in-file - usage: fif <SEARCH_TERM>
    FGrep() {

    dir=${2:-"./"}

    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!";
        return 1;
    fi
        rg --files-with-matches --no-messages "$1" ${dir} | fzf $FZF_PREVIEW_WINDOW \
            --preview "rg --ignore-case --pretty --context 10 '$1' {}"
    }
}