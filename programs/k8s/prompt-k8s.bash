#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

CONTEXT_COLOR=$(__color_a ${DF_PS1_K8S_CONTEXT_COLOR_CODE})
NAMESPACE_COLOR=$(__color_a ${DF_PS1_K8S_NS_COLOR_CODE})
RESET_COLOR_K8S=${DF_PS1_K8S_RESET_COLOR}


# __k8s_ps1 prints the current k8s context+namespace with colors
# Output format: [dev:default]
__k8s_ps1()
{
    if [ "$K8S_PS1_ENABLED" = "true" ]; then
        local current_context=$(kubectl config current-context)
        local current_namespace=$(kubectl config view --minify | grep namespace | awk '{print $2}')

        K8S_PS1_CONTEXT="${CONTEXT_COLOR}${current_context}${DF_RESET_COLORS_A}"
        K8S_PS1_NAMESPACE="${NAMESPACE_COLOR}${current_namespace}${DF_RESET_COLORS_A}"
        K8S_PS1="$DF_RESET_COLORS_A[${K8S_PS1_CONTEXT}:${K8S_PS1_NAMESPACE}]"

        echo -e ${K8S_PS1}
    fi
}

# enable_k8s_ps1 overwrite to k8s_ps1 state file true: K8S_PS1_ENABLED=true
# And re source custom dotfiles.
enable_k8s_ps1()
{
    echo "K8S_PS1_ENABLED=true" > ${DF_PS1_K8S_STATE_FILE}
    source ${DF_PS1_K8S_STATE_FILE}
    source ${DF_CUSTOMIZE_PARENT_BASH_FILE}
}

# disable_k8s_ps1 overwrite to k8s_ps1 state file true: K8S_PS1_ENABLED=false
# And re source custom dotfiles.
disable_k8s_ps1()
{
    echo "K8S_PS1_ENABLED=false" > ${DF_PS1_K8S_STATE_FILE}
    source ${DF_PS1_K8S_STATE_FILE}
    source ${DF_CUSTOMIZE_PARENT_BASH_FILE}
}
