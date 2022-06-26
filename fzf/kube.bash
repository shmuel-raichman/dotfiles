#!/bin/bash
# B"H

# Config
# 
function Knamespace_in_cluster()
{
    local cont="$(kubectl config get-contexts -o name | fzf)"
    local ns="$(kubectl get ns --context=${cont} | awk ' NR> 1 {print $1}' | fzf)"

    kubectl config use-context ${cont}
    kubectl config set-context --current --namespace $ns
}

_get_clusters_contexts_completions()
{
        # COMPREPLY=($(compgen -W "$(kubectl config view -o jsonpath='{.contexts[*].name}') | fzf " -- "${COMP_WORDS[1]}"))
        COMPREPLY=($(compgen -W "$( kubectl config get-contexts -o name | fzf ) " -- "${COMP_WORDS[1]}"))
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
        COMPREPLY=($(compgen -W "$(kubectl get ns | awk ' NR> 1 {print $1}' | fzf )" -- "${COMP_WORDS[1]}"))
}
complete -F _get_namespaces_completions set_namespace
complete -F _get_namespaces_completions namespace

#alias set_namespace='kubectl config set-context $(kubectl config current-context) --namespace='
alias set_namespace='kubectl config set-context --current --namespace'
alias namespace='kubectl config set-context --current --namespace'


# Pods
Klogp(){
    kubectl get pods | fzf | awk '{print "kubectl logs " $1}' | sh 
}

Klogpf(){
    kubectl get pods | fzf | awk '{print "kubectl logs -f " $1}' | sh 
}

Kstatusp(){
    FZF_DEFAULT_COMMAND="kubectl get pods | awk 'NR > 1 {print}'" \
        fzf --bind 'ctrl-r:reload(kubectl get pods | awk "NR > 1 {print}")' \
        --bind 'enter:execute:kubectl exec -it {1} -- bash > /dev/tty' \
        --bind 'ctrl-d:execute:kubectl describe pod {1} > /dev/tty'
}

Krmp(){
    kubectl get pods | fzf | awk '{print "kubectl delete pod --force --grace-period=0 " $1}' 
}

Krmpa(){
    kubectl get pods -A | fzf | awk '{print "kubectl delete pod --force --grace-period=0 -n "$1" "$2}' 
}

Ktop_all_list()
{
    local context=$( kubectl config view -o jsonpath='{.contexts[*].name}' | awk -v OFS='\n' '{$1=$1}1' | fzf )

    FZF_DEFAULT_COMMAND="kubectl get pods -o wide -A | awk 'NR > 1 {print}'"
        fzf --preview-window down,1,border-horizontal 
            --preview "kubectl top pod --context ${context} --namespace {1} {2}" "$@" \
            --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
            --bind "enter:execute:kubectl exec -it -n {1} --context ${context} {2} -- bash > /dev/tty" \
            --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND'
}



Kpods() {
FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
    fzf --info=inline --layout=reverse --header-lines=1 \
        --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
        --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
        --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
        --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
        --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
        --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
        --preview-window up:follow \
        --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
}


Kpodsn() {
FZF_DEFAULT_COMMAND="kubectl get pods" \
    fzf --info=inline --layout=reverse --header-lines=1 \
        --prompt "$(kubectl config current-context | sed 's/-context$//'):$(kubectl config view --minify | grep namespace | awk '{print $2}')> " \
        --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
        --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
        --bind 'enter:execute:kubectl exec -it {1} -- bash > /dev/tty' \
        --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers {1}) > /dev/tty' \
        --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
        --preview-window up:follow \
        --preview 'kubectl logs --follow --all-containers --tail=10000 {1}' "$@"
}


Klogs_in_cluster_in_ns() {

    local context=$( kubectl config view -o jsonpath='{.contexts[*].name}' | awk -v OFS='\n' '{$1=$1}1' | fzf )
    local ns=$(kubectl get ns --context ${context} | awk ' NR> 1 {print $1}' | fzf)
    local extra_print=""
    [ $(kubectl get pods -n ${ns} --context=${context} | wc -l ) = "0" ] && extra_print="No pods found in namespace ${ns}"
    # namespace

    FZF_DEFAULT_COMMAND="kubectl get pods -n ${ns} --context=${context}" \
    fzf --info=inline --layout=reverse --header-lines=1 \
        --prompt "${context}:${ns}> " \
        --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
        --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
        --bind "enter:execute:kubectl exec -it -n ${ns} --context ${context} {1} -- bash > /dev/tty" \
        --bind "ctrl-o:execute:${EDITOR:-vim} <(kubectl logs -n ${ns} --context ${context} --all-containers {1}) > /dev/tty" \
        --bind "ctrl-r:reload:kubectl get pods -n ${ns} --context=${context}" \
        --preview-window up:follow \
        --preview "kubectl logs --follow -n ${ns} --context ${context} --all-containers --tail=10000 {1}" "$@"
}


# Klogs_in_cluster_in_ns() {

#     local context=$( kubectl config view -o jsonpath='{.contexts[*].name}' | awk -v OFS='\n' '{$1=$1}1' | fzf )
#     local ns=$(kubectl get ns --context ${context} | awk ' NR> 1 {print $1}' | fzf)
#     local extra_print=""
#     [ $(kubectl get pods -n ${ns} --context=${context} | wc -l ) = "0" ] && extra_print="No pods found in namespace ${ns}"
#     # namespace

#     FZF_DEFAULT_COMMAND="kubectl get pods -n ${ns} --context=${context}" \
#     fzf --info=inline --layout=reverse --header-lines=1 \
#         --prompt "${context}:${ns}> " \
#         --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
#         --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
#         --bind "enter:execute:kubectl exec -it -n ${ns} --context ${context} {1} -- bash > /dev/tty" \
#         --bind "ctrl-o:execute:${EDITOR:-vim} <(kubectl top -n ${ns} --context ${context} --all-containers {1}) > /dev/tty" \
#         --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
#         --preview-window up:follow \
#         --preview "kubectl logs --follow -n ${ns} --context ${context} --all-containers --tail=10000 {1}" "$@"
# }
