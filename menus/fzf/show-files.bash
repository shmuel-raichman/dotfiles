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

Fshowfiles
