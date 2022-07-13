#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

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
# Make all kubectl completion use fzf if exist
[ "$KUBECTL_FZF_COMP" != "false" ] && command -v fzf >/dev/null 2>&1 && { 
	source <(kubectl completion bash | sed 's#"${requestComp}" 2>/dev/null#"${requestComp}" 2>/dev/null | head -n -1 | fzf --multi=0 #g')
}
alias k=kubectl
complete -F __start_kubectl k

# Helmfile 
command -v helmfile >/dev/null 2>&1 && { 
    # FROM helmfile source repo
    _helmfile_bash_autocomplete() {
    if [[ "${COMP_WORDS[0]}" != "source" ]]; then
        local cur opts base
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        if [[ "$cur" == "-"* ]]; then
        opts=$( ${COMP_WORDS[@]:0:$COMP_CWORD} ${cur} --generate-bash-completion )
        else
        opts=$( ${COMP_WORDS[@]:0:$COMP_CWORD} --generate-bash-completion )
        fi
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
    }

    complete -o bashdefault -o default -o nospace -F _helmfile_bash_autocomplete helmfile
}