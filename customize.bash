#!/bin/bash
# B"H

### Order is importent here
# Enable k8s prompt
source ~/dotfiles/k8s/prompt-k8s.bash
source ~/dotfiles/utils/state-files/k8s-prompt-state.bash
### Order is importent here
source ~/dotfiles/utils/colors/colors-codes.bash
source ~/dotfiles/utils/state-files/prompt-state.bash
source ~/dotfiles/utils/shell-functions/prompt-utils.bash
source ~/dotfiles/prompt.bash
#

command -v kubectl >/dev/null 2>&1 && { 
	source ~/dotfiles/k8s/k8s-aliases.bash
} || K8S_PS1_ENABLED=false

command -v helmfile >/dev/null 2>&1 && { 
	source ~/dotfiles/k8s/helmfile-autocomplete.bash
}

command -v __git_ps1 >/dev/null 2>&1 || source $(find /usr/ -iname git-sh-prompt) || true

command -v fzf >/dev/null 2>&1 && { 
	echo "FZF Exist sourcing fzf functions .."

	source ~/dotfiles/fzf/fzf.bash
	source ~/dotfiles/fzf/completion.bash
	source ~/dotfiles/fzf/key-bindings.bash
	command -v git >/dev/null 2>&1 && source ~/dotfiles/fzf/forgit.bash
	command -v kubectl >/dev/null 2>&1 && source ~/dotfiles/fzf/kube.bash
	command -v gcloud >/dev/null 2>&1 && source ~/dotfiles/fzf/gcloud.bash

}

# aliases

alias Addhost='sudo vim /etc/hosts'
alias rc='source ~/.bashrc'
alias Copy='xclip -r -sel clip'

# ls
alias ll='ls -la'
alias lll='ls -la'
alias l='ls -la'

alias grep='grep --color=always'

# Git
alias commit='git commit -m '




# hash kubectl 2>/dev/null || { echo >&2 "I require kubectl but it's not installed.";}

# To add git colors
# Version: 2.13
# Add the following to your ~/.gitconfig
#includeIf "gitdir:~/dotfiles/"]
#  path = .gitconfig
#
# For eariler versions
# export GIT_CONFIG=~/dotfiles/.gitconfig
