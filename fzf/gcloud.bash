#!/bin/bash
# B"H

# Required
# - fzf
# - gcloud 
# - xclip

GCP_PROJECT_LIST_FILENAME="gcloud-project-list"
GCP_PROJECT_LIST_BASE_PATH="$HOME/dotfiles/resources"
GCP_PROJECT_LIST_PATH="$GCP_PROJECT_LIST_BASE_PATH/$GCP_PROJECT_LIST_FILENAME"

mkdir $GCP_PROJECT_LIST_BASE_PATH

alias listvms='gcloud compute instances list --format="table[box,title=Instances](name:sort=1, zone:label=zone, status, networkInterfaces.networkIP)"'

GCPUpdateProjectsList(){
    echo "GCPUpdateProjectsList"
    gcloud projects list > $GCP_PROJECT_LIST_PATH
}

GCPConfigSetProject(){
    echo "GCPConfigSetProject"
    project=$(cat $GCP_PROJECT_LIST_PATH | awk ' NR > 1 {print}' | fzf | awk '{print $1}')
    gcloud config set project $project
}

GCPSearchInstance()
{
    project=$(cat $GCP_PROJECT_LIST_PATH | awk ' NR > 1 {print}' | fzf | awk '{print $1}')
    echo "Project: $project"

    gcloud compute instances list --project="$project" --format="table[box,title=Instances](name:sort=1, zone:label=zone, status, networkInterfaces.networkIP)" | fzf
}

GCPSSHInstance()
{
    project=$(cat $GCP_PROJECT_LIST_PATH | awk ' NR > 1 {print}' | awk ' NR > 1 {print}' | fzf | awk '{print $1}')
    user={$1:-"shmuel"}
    echo "Project: $project"

    gcloud compute instances list --project="$project" --format="[box]" | fzf \
         | awk -v u=$user -F '│' '{gsub(/ /,""); print "ssh " u"@"$6 }' | xclip -r -sel clip

    echo "ssh command copied to clipboard "
}