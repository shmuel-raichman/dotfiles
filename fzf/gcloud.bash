#!/bin/bash
# B"H

# Required
# - fzf
# - gcloud 
# - xclip

GCP_PROJECT_LIST_FILENAME="gcloud-project-list"
GCP_PROJECT_LIST_BASE_PATH="$HOME/dotfiles/resources"
GCP_PROJECT_LIST_PATH="$GCP_PROJECT_LIST_BASE_PATH/$GCP_PROJECT_LIST_FILENAME"

[ -d $GCP_PROJECT_LIST_BASE_PATH ] || mkdir -p $GCP_PROJECT_LIST_BASE_PATH

alias listvms='gcloud compute instances list --format="table[box,title=Instances](name:sort=1, zone:label=zone, status, networkInterfaces.networkIP)"'

__GCPConfigGetProject(){
    # echo "__GCPConfigGetProject"
    project=$(cat $GCP_PROJECT_LIST_PATH | awk ' NR > 1 {print}' | fzf | awk '{print $1}')
    echo ${project}
}


__GCPUpdateProjectsList(){
    echo "GCPUpdateProjectsList"
    gcloud projects list > $GCP_PROJECT_LIST_PATH
}


GCPConnectToGKECluster(){
    region=${1:-us-central1}
    project="$(__GCPConfigGetProject)"
    cluster_name=$(gcloud container clusters list --project=${project} | awk 'NR > 1 {print}' | fzf | awk '{print $1}')

    gcloud container clusters get-credentials ${cluster_name} --region ${region} --project ${project} 
    kubectl config set-context --current --namespace $(__KGet_namespaces)
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