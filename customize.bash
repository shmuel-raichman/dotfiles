#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

# ### Order is importent here
# export DF_PATHES="${DF_HOME}/utils/global-variables/global-pathes.bash"
# ### Sourcing
# # Global pathes sourcing
# source ${DF_PATHES}
# Colors
source ${DF_COLORS_CODES_FILE}
source ${DF_COLORS_UTILS_FILE}
# State files
source ${DF_STATE_FILE}
source ${DF_PS1_STATE_FILE}
source ${DF_PS1_K8S_STATE_FILE}
# Prompt
source ${DF_PS1_K8S_PROMPT_FILE}
source ${DF_PS1_UTILS_FILE}
source ${DF_PS1_PROMPT_FILE}
#

# Enable azure az auto complete
command -v az >/dev/null 2>&1 && { 
	source ${DF_AZ_COMPLETION}
}

command -v kubectl >/dev/null 2>&1 && { 
	source ${DF_K8S_ALIASES_FILE}
	source ${DF_K8S_COMP_RELATED_FILE}
} || echo "K8S_PS1_ENABLED=false" > ${DF_PS1_K8S_STATE_FILE}

##### fzf
############################################################################
################################ FZF #######################################
############################################################################
command -v fzf >/dev/null 2>&1 && { 
	echo "FZF Exist sourcing fzf functions .."

	source ${DF_FZF_DEFAULTS_FILE}
	source ${DF_FZF_FS_FILE}
	# source ${DF_FZF_SOURCE_COMP_FILE}
	source ${DF_FZF_SOURCE__KEY_BINDING_FILE}
	# source ${DF_FZF_FS_FILE}
	command -v git >/dev/null 2>&1 && source ${DF_FZF_SOURCE_GIT_FILE}
	command -v kubectl >/dev/null 2>&1 && source ${DF_FZF_GCLOUD_FILE}
	command -v gcloud >/dev/null 2>&1 && source ${DF_FZF_K8S_FILE}

}
#############################################################################
#############################################################################
#############################################################################


### aliases
############################################################################
################################ aliases ###################################
############################################################################
# Basics
alias hosts='sudo vim /etc/hosts'
alias rc='source ~/.bashrc'
alias apt='sudo apt'


# basic GNU
## alias ll='ls -la'
alias ll='ls -la'
command -v fzf >/dev/null 2>&1 && { 
	alias ll='exa -la --icons --group-directories-first'
}
alias lll='ls -la'
alias l='ls -la'
alias grep='grep --color=always'

# Git
alias commit='git commit -m '

# Extra
alias Copy='xclip -r -sel clip'

alias kill_ssh_sessions='kill -9 $(ps -aux | grep ssh | grep -v "grep" | grep -v "/usr/" | awk "{print $2}") |true'
#############################################################################
#############################################################################
#############################################################################

# Custom Configs
export STARSHIP_CONFIG=${DF_CONFIGS_STARSHIP_FILE}

### TODO
##############################################################################
## Add check for exa and completion script
source /opt/installs/programs/exa/completions/exa.bash
## Test this line
command -v __git_ps1 >/dev/null 2>&1 || source $(find /usr/ -iname git-sh-prompt) || true
