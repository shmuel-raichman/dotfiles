#!/bin/bash
# B"H
LIGTH_RED_COLOR="\001\033[91m\002"
CAYN_COLOR="\001\033[36m\002"
RESET_COLOR_K8S="\001\033[00m\002"


__k8s_ps1()
{
    if [ "$K8S_PS1_ENABLED" = "true" ];
        local current_context=$(kubectl config current-context)
        local current_namespace=$(kubectl config view --minify | grep namespace | awk '{print $2}')

        DEFAULT_K8S_PS1=" [$LIGTH_RED_COLOR$current_context$RESET_COLOR_K8S:$CAYN_COLOR$current_namespace$RESET_COLOR_K8S] "
        printf $DEFAULT_K8S_PS1
    fi
}

enable_k8s_ps1()
{
    echo "K8S_PS1_ENABLED=true" > ~/dotfiles/k8s/k8s-ps1-state.bash
    . ~/dotfiles/k8s/ps1-state.bash
    . ~/dotfiles/.bash_customize
}


disable_k8s_ps1()
{
    echo "K8S_PS1_ENABLED=false" > ~/dotfiles/k8s/k8s-ps1-state.bash
    . ~/dotfiles/k8s/ps1-state.bash
    . ~/dotfiles/.bash_customize
}


