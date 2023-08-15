#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

CACHE_BASE_PATH="$HOME/dotfiles/resources"
CACHE_NAMESPACE_FILENAME="k8s-namespaces-list"
# Internal
###########

# Get namespace from cache pass context to get diffrent context namespaces
# Default current
__KGet_namespaces()
{
    local context=$1
    local context=${context:=$(kubectl config current-context)}
    cat "$CACHE_BASE_PATH/$CACHE_NAMESPACE_FILENAME" | \
        grep ${context} | \
        awk '{print $2 }' | fzf
}

# Cache namespaces from all clusters in kube config in local file.
__KCacheNamespacesList()
{
    echo "Running: __KCacheNamespacesList"
    date "+%d-%m-%Y %H-%M-%S" > "$CACHE_BASE_PATH/k8s-namespaces-list"

    echo "This update might take few minutes."
    # For each context in kube config 
    # Get all namespaces an print into a file with context prefix
    for context in $(kubectl config get-contexts -o name); do 
        kubectl get ns --context=${context} | awk -v context=$context  'NR>1 {print context": "$1}' \
            >> "$CACHE_BASE_PATH/$CACHE_NAMESPACE_FILENAME" || true
    done

}

__KGet_current_namespace()
{
    # kubectl config view --minify | grep --color=never namespace | awk -F':' '{ gsub(/ /,""); print $2}'
    kubectl config view --minify -o template='{{ (index .contexts 0).context.namespace }}'
}


__KComplete()
{
    # ${server:=localhost}
    local reg=${1:-""}
    local first=${2:-"get"}
    local second=${3:-"pods"}
    k __completeNoDesc ${first} ${second} "${reg}" | head -n -1 | fzf
    # echo "k __completeNoDesc ${first} ${second} ${reg}"
}

KNamespace_in_cluster()
{
    local cont="$(kubectl config get-contexts -o name | fzf)"
    local ns="$(__KGet_namespaces ${cont})"

    kubectl config use-context ${cont}
    kubectl config set-context --current --namespace ${ns}
}

KGet_current_context()
{
    kubectl config current-context
}

__KGet_contexts()
{
    kubectl config get-contexts -o name | fzf
}

__get_clusters_contexts_completions()
{
        # COMPREPLY=($(compgen -W "$(kubectl config view -o jsonpath='{.contexts[*].name}') | fzf " -- "${COMP_WORDS[1]}"))
        COMPREPLY=($(compgen -W "$( __KGet_contexts ) " -- "${COMP_WORDS[1]}"))
}
# Set a command to execute the complete function.
# complete -F [complete_function] [command]
complete -F __get_clusters_contexts_completions set_cluster
complete -F __get_clusters_contexts_completions cluster
# Set alias of kubectl command for changing clusters.
alias set_cluster='kubectl config use-context'
alias cluster='kubectl config use-context'



# Namespaces
# ###############################################################################################################
# switch namespace command.
# ###############################################################################################################
__get_namespaces_completions()
{
        COMPREPLY=($(compgen -W "$(__KGet_namespaces)" -- "${COMP_WORDS[1]}"))
}
complete -F __get_namespaces_completions set_namespace
complete -F __get_namespaces_completions namespace

#alias set_namespace='kubectl config set-context $(kubectl config current-context) --namespace='
alias set_namespace='kubectl config set-context --current --namespace'
alias namespace='kubectl config set-context --current --namespace'


# Pods
# ###############################################################################################################
# New switch namespace command.
# ###############################################################################################################
__get_pods_completions()
{
        COMPREPLY=($(compgen -W "$(__KComplete)" -- "${COMP_WORDS[1]}"))
}
# complete -F __get_namespaces_completions set_namespace
# complete -F __get_namespaces_completions namespace

#alias set_namespace='kubectl config set-context $(kubectl config current-context) --namespace='
# alias set_namespace='kubectl config set-context --current --namespace'
# alias namespace='kubectl config set-context --current --namespace'


__get_all_pods_in_context()
{
    local context=$(__KGet_contexts)

    kubectl get pods --context=${context} -o wide -A | awk 'NR > 1 {print}'
}

complete -F __start_kubectl k

# Logs
KLogs(){
    local current_ns=$(__KGet_current_namespace)
    local ns=$1
    local ns=${ns:=$current_ns}
    local ns="-n=${ns}"

    echo $ns
    kubectl get pods ${ns} | fzf | awk -v ns=${ns} '{print "kubectl logs " ns" "$1}' | sh
}
complete -F __get_namespaces_completions KLogs

KLogsf(){
    local current_ns=$(__KGet_current_namespace)
    local ns=$1
    local ns=${ns:=$current_ns}
    local ns="-n=${ns}"

    echo $ns
    kubectl get pods ${ns} | fzf | awk -v ns=${ns} '{print "kubectl logs -f " ns" "$1}' | sh
}
complete -F __get_namespaces_completions KLogsf

KPods(){

    local current_ns=$(__KGet_current_namespace)
    local ns=$1
    local ns=${ns:=$current_ns}
    local ns="-n=${ns}"

    FZF_DEFAULT_COMMAND="kubectl get pods ${ns}" \
        fzf --info=inline --layout=reverse --header-lines=1 \
            --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
            --header $'╱ Enter (kubectl exec) ╱ ctrl-e (edit pod in place) ╱ ctrl-r (reload) / ctrl-w (reload wide) ╱
/ ctrl-l (logs) / ctrl-d (describe) / ctrl-y (yaml) /
/ ctrl-t (top) / alt-d (copy delete command to clip) /\n\n\n' \
            --preview-window left:60%,follow \
            --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
            --bind "ctrl-w:reload:kubectl get pods ${ns} -owide" \
            --bind "ctrl-e:execute(kubectl edit pod ${ns} {1} )" \
            --bind "enter:execute:kubectl exec -it ${ns} {1} -- bash > /dev/tty" \
            --bind "ctrl-l:change-preview(kubectl logs ${ns} --follow --all-containers --tail=10000 {1} )" \
            --bind "ctrl-d:change-preview(bat --style=numbers --color=always -l yaml <(kubectl describe pod ${ns} {1}) )" \
            --bind "ctrl-y:change-preview(bat --style=numbers --color=always -l yaml <(kubectl get pod -o yaml ${ns} {1} ))" \
            --bind "ctrl-t:change-preview(kubectl top pod ${ns} {1} )" \
            --bind "alt-d:change-preview( echo 'kubectl delete pods --force --grace-period=0 ${ns} {1}' | xclip -r -sel clip )" \
            --preview "kubectl describe pod ${ns} {1}"
}
complete -F __get_namespaces_completions KStatus


KPodsA(){

    FZF_DEFAULT_COMMAND="kubectl get pods -A" \
        fzf --info=inline --layout=reverse --header-lines=1 \
            --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
            --header $'╱ Enter (kubectl exec) ╱ ctrl-e (edit pod in place) ╱ ctrl-r (reload) / ctrl-w (reload wide) ╱
/ ctrl-l (logs) / ctrl-d (describe) / ctrl-y (yaml) /
/ ctrl-t (top) / alt-d (copy delete command to clip) /\n\n\n' \
            --preview-window left:60%,follow \
            --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
            --bind "ctrl-w:reload:kubectl get pods -A -owide" \
            --bind "ctrl-e:execute(kubectl edit pod -n {1} {2})" \
            --bind "enter:execute:kubectl exec -it -n {1} {2} -- bash > /dev/tty" \
            --bind "ctrl-l:change-preview(kubectl logs -n {1} {2} --follow --all-containers --tail=10000 )" \
            --bind "ctrl-d:change-preview(bat --style=numbers --color=always -l yaml <(kubectl describe pod -n {1} {2}) )" \
            --bind "ctrl-y:change-preview(bat --style=numbers --color=always -l yaml <(kubectl get pod -o yaml -n {1} {2}) )" \
            --bind "ctrl-t:change-preview(kubectl top pod -n {1} {2} )" \
            --bind "alt-d:change-preview( echo 'kubectl delete pods --force --grace-period=0 -n {1} {2}' | xclip -r -sel clip )" \
            --preview "kubectl describe pod -n {1} {2}"
}


    # FZF_DEFAULT_COMMAND="kubectl get pods | awk 'NR > 1 {print}'" \
    #     fzf --info=inline --layout=reverse --header-lines=1 \
    #     --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
    #     --header $'╱ Enter (kubectl exec) ╱ CTRL-d (describe pod) ╱ CTRL-r (reload)  ╱ Lshift-? (toggle preview) ╱\n\n' \
    #     --bind 'ctrl-r:reload(kubectl get pods | awk "NR > 1 {print}")' \
    #     --bind 'enter:execute:kubectl exec -it {1} -- bash > /dev/tty' \
    #     --bind 'ctrl-d:execute:kubectl describe pod {1} > /dev/tty' \
    #     --preview-window up:follow \
    #     --preview "kubectl describe pod {1} > /dev/tty" "$@"
# }

Krmp(){
    kubectl get pods | fzf | awk '{print "kubectl delete pod --force --grace-period=0 " $1}' 
}

Krmpa(){
    kubectl get pods -A | fzf | awk '{print "kubectl delete pod --force --grace-period=0 -n "$1" "$2}' 
}

Ktop_all_list()
{

    local context=$( kubectl config view -o jsonpath='{.contexts[*].name}' | awk -v OFS='\n' '{$1=$1}1' | fzf )

    
    FZF_DEFAULT_COMMAND="kubectl get pods --context=${context} -o wide -A | awk 'NR > 1 {print}'" \
        fzf --bind "enter:execute:kubectl exec -it -n {1} --context ${context} {2} -- bash > /dev/tty" \
            --bind "ctrl-r:reload:kubectl get pods --context=${context} -o wide -A | awk 'NR > 1 {print}'" \
            --preview-window down,2,border-horizontal \
            --preview "kubectl top pod --context ${context} --namespace {1} {2}" "$@" \
            --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'
}


# Ktop_all_list()
# {

#     FZF_DEFAULT_COMMAND="__get_all_pods_current_ns_in_context" \
#         fzf --preview-window down,2,border-horizontal \
#             --preview "kubectl top pod --context ${context} --namespace {1} {2}" "$@" \
#             --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
#             --bind "enter:execute:kubectl exec -it -n {1} --context ${context} {2} -- bash > /dev/tty" \
#             --bind 'ctrl-r:reload:($FZF_DEFAULT_COMMAND)'
# }



# Kpodsa() {
# FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
#     fzf --info=inline --layout=reverse --header-lines=1 \
#         --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
#         --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
#         --preview-window up:follow \
#         --bind 'ctrl-l:change-preview-window(20%|40%|60%|80%)' \
#         --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
#         --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
#         --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
#         --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
# }


# Kpods() {
# FZF_DEFAULT_COMMAND="kubectl get pods" \
#     fzf --info=inline --layout=reverse --header-lines=1 \
#         --prompt "$(kubectl config current-context | sed 's/-context$//'):$(kubectl config view --minify | grep namespace | awk '{print $2}')> " \
#         --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
#         --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
#         --bind 'enter:execute:kubectl exec -it {1} -- bash > /dev/tty' \
#         --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers {1}) > /dev/tty' \
#         --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
#         --preview-window up:follow \
#         --preview 'kubectl logs --follow --all-containers --tail=10000 {1}' "$@"
# }

# KPods() {
# FZF_DEFAULT_COMMAND="kubectl get pods" \
#     fzf --info=inline --layout=reverse --header-lines=1 \
#         --prompt "$(kubectl config current-context | sed 's/-context$//'):$(kubectl config view --minify | grep namespace | awk '{print $2}')> " \
#         --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
#         --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
#         --bind 'enter:execute:kubectl exec -it {1} -- bash > /dev/tty' \
#         --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers {1}) > /dev/tty' \
#         --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
#         --preview-window up:follow \
#         --preview 'kubectl logs --follow --all-containers --tail=10000 {1}' "$@"
# }



# Klogs_in_cluster_in_ns() {

#     local context=$( kubectl config view -o jsonpath='{.contexts[*].name}' | awk -v OFS='\n' '{$1=$1}1' | fzf )
#     local ns=$(__KGet_namespaces ${context})
#     local extra_print=""
#     [ $(kubectl get pods -n ${ns} --context=${context} | wc -l ) = "0" ] && extra_print="No pods found in namespace ${ns}"
#     # namespace

#     FZF_DEFAULT_COMMAND="kubectl get pods -n ${ns} --context=${context}" \
#     fzf --info=inline --layout=reverse --header-lines=1 \
#         --prompt "${context}:${ns}> " \
#         --header $'\n╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
#         --bind '?:change-preview-window(80%,border-bottom|hidden|)' \
#         --bind "enter:execute:kubectl exec -it -n ${ns} --context ${context} {1} -- bash > /dev/tty" \
#         --bind "ctrl-o:execute:${EDITOR:-vim} <(kubectl logs -n ${ns} --context ${context} --all-containers {1}) > /dev/tty" \
#         --bind "ctrl-r:reload:kubectl get pods -n ${ns} --context=${context}" \
#         --bind '?:toggle-preview' \
#         --preview-window up:follow \
#         --preview "kubectl logs --follow -n ${ns} --context ${context} --all-containers --tail=10000 {1}" "$@"
# }





# Klogs_in_cluster_in_ns() {

#     local context=$( kubectl config view -o jsonpath='{.contexts[*].name}' | awk -v OFS='\n' '{$1=$1}1' | fzf )
#     local ns=$(__KGet_namespaces ${context})
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
