#!/bin/env bash
# B"H

AWS_CONFIG_PATH="$HOME/.aws/config"


# Add all eks clusters in all accounts that exist in my aws config file.
__EKS_Clusters_config_update(){
    for account in $(cat ${AWS_CONFIG_PATH} | grep profile | grep -v "bash\|terraform" | awk '{print $2}' | sed 's/.$//'); do 
        regions="eu-west-1 eu-central-1"; 
        for region in ${regions}; do 
            for cluster in $(aws eks list-clusters --region=${region} --profile ${account} | jq -r .clusters[]); do
                aws eks update-kubeconfig --name ${cluster} --profile ${account} --region ${region} --alias "${account}:${cluster}"
            done
        done; 
    done
}

alias ssoaws='aws sso login --sso-session general'



# Example of aws conf file
# [profile general-dev]
# sso_session = general
# sso_account_id = sso_account_id
# sso_role_name = AdministratorAccess
# [profile general-prod]
# sso_session = general
# sso_account_id = sso_account_id
# sso_role_name = AdministratorAccess
# [profile general-comp]
# sso_session = general
# sso_account_id = sso_account_id
# sso_role_name = AdministratorAccess
# # for programs
# [profile bashdev--sso_account_id]
# sso_session = general
# sso_account_id = sso_account_id
# sso_role_name = AdministratorAccess
# [profile bashprod--sso_account_id]
# sso_session = general
# sso_account_id = sso_account_id
# sso_role_name = AdministratorAccess
# [profile bashcomp--sso_account_id]
# sso_session = general
# sso_account_id = sso_account_id
# sso_role_name = AdministratorAccess



# [sso-session general]
# sso_start_url = sso_start_url
# sso_region = sso_region
# sso_registration_scopes = sso