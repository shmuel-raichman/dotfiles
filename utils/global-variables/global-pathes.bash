#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

export DF_HOME="$HOME/dotfiles"
export DF_CUSTOMIZE_PARENT_BASH_FILE="$DF_HOME/customize.bash"

# State files
export DF_STATE_FILE="$DF_HOME/utils/state-files/shell-state.bash"
export DF_PS1_STATE_FILE="$DF_HOME/utils/state-files/prompt-state.bash"
export DF_PS1_K8S_STATE_FILE="$DF_HOME/utils/state-files/k8s-prompt-state.bash"
# K8S
export DF_K8S_COMP_RELATED_FILE="$DF_HOME/programs/k8s/k8s-related-completion.bash"
export DF_K8S_ALIASES_FILE="$DF_HOME/programs/k8s/k8s-aliases.bash"
export DF_PS1_K8S_PROMPT_FILE="$DF_HOME/programs/k8s/prompt-k8s.bash"
export DF_K8S_AWS_LOGIN="$DF_HOME/programs/aws/aws-kube-profiles.bash"
# Prompt
export DF_PS1_PROMPT_FILE="${DF_HOME}/prompt.bash"
# Utils
export DF_PS1_UTILS_FILE="${DF_HOME}/utils/shell-functions/prompt-utils.bash"
# Colors
export DF_COLORS_CODES_FILE="${DF_HOME}/utils/global-variables/global-colors.bash"
export DF_COLORS_UTILS_FILE="${DF_HOME}/utils/colors/colors-utils.bash"
# Custom configs
export DF_CONFIGS_STARSHIP_FILE="${DF_HOME}/config/starship/defalut.toml"
# Resources
export DF_EMOJIS_PATH_FILE="${DF_HOME}/resources/emojis-list.txt"
# FZF
DF_FZF_BASE_DIR="${DF_HOME}/menus/fzf"
export DF_FZF_DEFAULTS_FILE="${DF_FZF_BASE_DIR}/fzf.bash"
export DF_FZF_FS_FILE="${DF_FZF_BASE_DIR}/fs.bash"
export DF_FZF_SOURCE_COMP_FILE="${DF_FZF_BASE_DIR}/source/completion.bash"
export DF_FZF_SOURCE__KEY_BINDING_FILE="${DF_FZF_BASE_DIR}/source/key-bindings.bash"
export DF_FZF_SOURCE_GIT_FILE="${DF_FZF_BASE_DIR}/source/forgit.bash"
export DF_FZF_GCLOUD_FILE="${DF_FZF_BASE_DIR}/programs/gcloud.bash"
export DF_FZF_K8S_FILE="${DF_FZF_BASE_DIR}/programs/kube.bash"

# Completion scripts
export DF_AZ_COMPLETION="${DF_HOME}/programs/az/az-completion.bash"
