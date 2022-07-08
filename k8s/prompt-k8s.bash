#!/bin/bash
# B"H
LIGTH_RED_COLOR="\001\033[91m\002"
CAYN_COLOR="\001\033[36m\002"
RESET_COLOR_K8S="\001\033[00m\002"
K8S_PS1_STATE_FILE="$HOME/dotfiles/utils/state-files/k8s-prompt-state.bash"


__k8s_ps1()
{
    if [ "$K8S_PS1_ENABLED" = "true" ]; then
        local current_context=$(kubectl config current-context)
        local current_namespace=$(kubectl config view --minify | grep namespace | awk '{print $2}')

        DEFAULT_K8S_PS1=" [${LIGTH_RED_COLOR}${current_context}${RESET_COLOR_K8S}:${CAYN_COLOR}${current_namespace}${RESET_COLOR_K8S}] "
        printf ${DEFAULT_K8S_PS1}
    fi
}

enable_k8s_ps1()
{
    echo "K8S_PS1_ENABLED=true" > ${K8S_PS1_STATE_FILE}
    . ${K8S_PS1_STATE_FILE}
    . ~/dotfiles/customize.bash
}


disable_k8s_ps1()
{
    echo "K8S_PS1_ENABLED=false" > ${K8S_PS1_STATE_FILE}
    . ${K8S_PS1_STATE_FILE}
    . ~/dotfiles/customize.bash
}


