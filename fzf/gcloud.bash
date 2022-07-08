#!/bin/bash
# B"H

# Required
# - fzf
# - gcloud 
# - xclip



GCP_PROJECT_LIST_FILENAME="gcloud-project-list"
GCP_CLUSTERS_LIST_FILENAME="gcloud-clusters-list"
GCP_PROJECT_LIST_BASE_PATH="$HOME/dotfiles/resources"
GCP_PROJECT_LIST_PATH="$GCP_PROJECT_LIST_BASE_PATH/$GCP_PROJECT_LIST_FILENAME"

[ -d $GCP_PROJECT_LIST_BASE_PATH ] || mkdir -p $GCP_PROJECT_LIST_BASE_PATH

alias listvms='gcloud compute instances list --format="table[box,title=Instances](name:sort=1, zone:label=zone, status, networkInterfaces.networkIP)"'

__GCPConfigGetProject(){
    # echo "__GCPConfigGetProject"
    project=$(cat $GCP_PROJECT_LIST_PATH | awk ' NR > 1 {print}' | fzf | awk '{print $1}')
    echo ${project}
}


__GCPCacheProjectsList(){
    echo "Running: GCPUpdateProjectsList"
     date "+%d-%m-%Y %H-%M-%S" >  $GCP_PROJECT_LIST_PATH

    gcloud projects list >> $GCP_PROJECT_LIST_PATH
}

__GCPCacheClustersList(){
    echo "Running: __GCPCacheClustersList"
    date "+%d-%m-%Y %H-%M-%S" > "$GCP_PROJECT_LIST_BASE_PATH/$GCP_CLUSTERS_LIST_FILENAME"

    echo "This update might take few minutes."
    for proj in $(cat $GCP_PROJECT_LIST_PATH | awk 'NR>1 {print $1}'); 
        do gcloud container clusters list --project=${proj} 2> /dev/null | awk -v prj=$proj 'NR>1 {print prj": "$0}' >> "$GCP_PROJECT_LIST_BASE_PATH/$GCP_CLUSTERS_LIST_FILENAME"
    done
}

GCPReAuth()
{
    "Running: GCPReAuth"
    gcloud projects list > /dev/null
}

GCPConnectToGKECluster(){

    local region="us-central1"
    local project_flag=""
    local cluster_name=""
    local default="true"
    local debug="false"
    local project=""
    local namespace=""

    __GCPReAuth


    while [ "$#" -gt 0 ]; do
        case $1 in
            -c | --cluset-name ) shift
                cluster_name=$1
                ;;
            -p | --project ) shift
                project="--project=$1"
                ;;
            -n | --namespace ) shift
                namespace="--namespace=$1"
                ;;
            -d | --default ) shift
                default="false"
                ;;
            -r | --region ) shift
                region=$1
                ;;
            * )
                echo "Running .."
                ;;
        esac
        shift
    done

    [ "${debug}" == "true" ] && echo "Before ---- -region: ${region} \\n-project: ${project} \\n-cluster_name: ${cluster_name} \\n-defalut: ${defalut}"


    # [ "${defalut}" == "true" ] && gcloud container clusters get-credentials ${cluster_name} --region ${region} 
    [ "${default}" == "true" ] || [ "${project}" != "" ] || project="--project=$(__GCPConfigGetProject)" 
    echo "Exis: $?"

    [ "x${cluster_name}" == "x" ] && {
        cluster_name=$(gcloud container clusters list ${project} | awk 'NR > 1 {print}' | fzf | awk '{print $1}')
    }
    echo "namespace grep 01"
    
    if [ "${default}" != "true" ]; then 
        namespace="--namespace=$(__KGet_namespaces)"
    else
        namespace="--namespace=$(__Kget_current_namespace)"
    fi

    gcloud container clusters get-credentials ${cluster_name} ${project} --region ${region}
    echo "namespace grep 02"
    kubectl config view --minify | grep namespace
    # Rename GKE long context name to cluster name
    # Delete existing context with the cluster name if exist and then rename the new context to cluster name
    kubectl config delete-context ${cluster_name} || echo "context: ${cluster_name} not in config"
    kubectl config rename-context $(kubectl config current-context) ${cluster_name}
    # Set namespace for choosen cluster - use default if flag -d provided
    
    echo "namespace grep 03"
    echo "Debug namespace - ${namespace}"
    kubectl config view --minify | grep namespace

    # [ "x${namespace}" == "x" ] && [ "${default}" != "true" ] && echo "choose 1"
    # [ "x${namespace}" == "x" ] || [ "${default}" != "true" ] && echo "choose 2"
    # [ "x${namespace}" != "x" ] || echo "choose 3"

    # [ "${default}" != "true" ] && echo "choose 4"




    kubectl config set-context --current ${namespace} 
    
    echo "namespace grep 04"
    kubectl config view --minify | grep namespace


    # Debug
    [ "${debug}" == "true" ] && echo "-region: ${region} \n-project: ${project} \n-cluster_name: ${cluster_name} \n-defalut: ${defalut}"
}


GCPConfigSetProject(){
    echo "GCPConfigSetProject"
    project=$(__GCPConfigGetProject)
    gcloud config set project ${project}
}


GCPSearchInstance()
{
    project=$(__GCPConfigGetProject)
    echo "Project: $project"

    gcloud compute instances list --project="$project" --format="table[box,title=Instances](name:sort=1, zone:label=zone, status, networkInterfaces.networkIP)" | fzf
}


GCPSSHInstance()
{
    project=$(__GCPConfigGetProject)
    user={$1:-"shmuel"}
    echo "Project: $project"

    gcloud compute instances list --project="$project" --format="[box]" | fzf \
         | awk -v u=$user -F '│' '{gsub(/ /,""); print "ssh " u"@"$6 }' | xclip -r -sel clip

    echo "ssh command copied to clipboard "
}