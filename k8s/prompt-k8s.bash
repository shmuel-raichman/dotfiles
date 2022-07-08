#!/bin/bash
# B"H
# LIGTH_RED_COLOR="\001\033[91m\002"
# CAYN_COLOR="\001\033[36m\002"
# RESET_COLOR_K8S="\001\033[00m\002"

LIGTH_RED_COLOR=$(__color_a 91)
CAYN_COLOR=$(__color_a 33)
RESET_COLOR_K8S=$RESET_COLORS_A
K8S_PS1_STATE_FILE="$HOME/dotfiles/utils/state-files/k8s-prompt-state.bash"


__k8s_ps1()
{
    if [ "$K8S_PS1_ENABLED" = "true" ]; then
        local current_context=$(kubectl config current-context)
        local current_namespace=$(kubectl config view --minify | grep namespace | awk '{print $2}')

        K8S_PS1_CONTEXT="${LIGTH_RED_COLOR}${current_context}${RESET_COLORS_A}"
        K8S_PS1_NAMESPACE="${CAYN_COLOR}${current_namespace}${RESET_COLORS_A}"
        K8S_PS1="$RESET_COLORS_A[${K8S_PS1_CONTEXT}:${K8S_PS1_NAMESPACE}]"

        echo -e ${K8S_PS1}
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


