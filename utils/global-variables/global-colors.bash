#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

## Some Some sequences to keep
####################################################
## "\u001b[38;5;${ID}m
## Non printing characters esacpes
## BEGIN_NON_PRINTING_CHARS="\["
## END_NON_PRINTING_CHARS="\]"
## BEGIN_NON_PRINTING_CHARS_NUMERIC="\001"
## END_NON_PRINTING_CHARS_NUMERIC="\002"
##
## LIGTH_RED_COLOR="\001\033[91m\002"
## CAYN_COLOR="\001\033[36m\002"
## RESET_COLOR_K8S="\001\033[00m\002"
####################################################

# Reset sequences
export DF_RESET_COLORS="\u001b[0m"
export DF_RESET_COLOR="\[\033[00m\]"
export DF_RESET_COLORS_A="\001\033[00m\002"

# 
export DF_PS1_GIT_COLOR_CODE="36"
export DF_PS1_WD_COLOR_CODE="38"
# K8S Codes
export DF_PS1_K8S_CONTEXT_COLOR_CODE="91"
export DF_PS1_K8S_NS_COLOR_CODE="33"
export DF_PS1_K8S_RESET_COLOR=$RESET_COLORS_A


## colors
export GREEN_RANGE_84="84"
export GREEN_RANGE_71="71"
export GREEN_RANGE_36="36"
# 
export PINK_RANGE_200="200"

## Background colors
export BLUE_RANGE_31="31"
export BLUE_RANGE_30="30"