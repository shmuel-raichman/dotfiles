#!/bin/bash
# B"H



command -v velero >/dev/null 2>&1 && { 
	source <(velero completion bash) # setup autocomplete for velero
}

command -v helm >/dev/null 2>&1 && { 
    source <(helm completion bash) # setup autocomplete for helm
}

command -v kind >/dev/null 2>&1 && { 
	source <(kind completion bash) # setup autocomplete for kind
}

command -v istioctl >/dev/null 2>&1 && { 
	source <(istioctl completion bash) # setup autocomplete for istioctl
}


source <(kubectl completion bash) # setup autocomplete for kubectl
alias k=kubectl
complete -F __start_kubectl k


alias getCluster='kubectl config current-context'
alias getClusters='kubectl config get-contexts'

alias setCurrentCluster='kubectl config use-context'

# Switch cluster
# ###########################################################################################################################
# New switch cluster command.
# ###########################################################################################################################

_clusters()
{
    kubectl config view -o jsonpath='{.contexts[*].name}' | awk -v OFS='\n' '{$1=$1}1' | fzf
}


## 
command -v fzf >/dev/null 2>&1 || { 

    echo "Setting kube functions to non FZF."

    _get_clusters_contexts_completions()
    {
            # COMPREPLY=($(compgen -W "$(kubectl config view -o jsonpath='{.contexts[*].name}') | fzf " -- "${COMP_WORDS[1]}"))
            COMPREPLY=($(compgen -W "$( kubectl config get-contexts -o name ) " -- "${COMP_WORDS[1]}"))
    }
    # Set a command to execute the complete function.
    # complete -F [complete_function] [command]
    complete -F _get_clusters_contexts_completions set_cluster
    complete -F _get_clusters_contexts_completions cluster
    # Set alias of kubectl command for changing clusters.
    alias set_cluster='kubectl config use-context'
    alias cluster='kubectl config use-context'



    # Namespaces
    # ###############################################################################################################
    # New switch namespace command.
    # ###############################################################################################################
    # See line 21 for explenation.
    _get_namespaces_completions()
    {
            COMPREPLY=($(compgen -W "$(kubectl get ns | awk ' NR> 1 {print $1}' )" -- "${COMP_WORDS[1]}"))
    }
    complete -F _get_namespaces_completions set_namespace
    complete -F _get_namespaces_completions namespace

    #alias set_namespace='kubectl config set-context $(kubectl config current-context) --namespace='
    alias set_namespace='kubectl config set-context --current --namespace'
    alias namespace='kubectl config set-context --current --namespace'
}