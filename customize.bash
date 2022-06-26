#!/bin/bash
# B"H

# Enable k8s prompt
source ~/dotfiles/k8s/prompt-k8s.bash
source ~/dotfiles/k8s/k8s-prompt-state.bash
### 
source ~/dotfiles/prompt.bash

command -v kubectl >/dev/null 2>&1 && { 
	source ~/dotfiles/k8s/k8s-aliases.bash
}

command -v helmfile >/dev/null 2>&1 && { 
	source ~/dotfiles/k8s/helmfile-autocomplete.bash
}

command -v fzf >/dev/null 2>&1 && { 
	echo "FZF Exist sourcing fzf functions .."

	source ~/dotfiles/fzf/fzf.bash
	source ~/dotfiles/fzf/completion.bash
	source ~/dotfiles/fzf/key-bindings.bash
	source ~/dotfiles/fzf/forgit.bash
	source ~/dotfiles/fzf/kube.bash
	source ~/dotfiles/fzf/gcloud.bash
	source ~/dotfiles/fzf/gcloud.bash
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
