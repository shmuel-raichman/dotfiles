#!/bin/bash
# B"H

# "\u001b[38;5;${ID}m
# Non printing characters esacpes
## BEGIN_NON_PRINTING_CHARS="\["
## END_NON_PRINTING_CHARS="\]"
## BEGIN_NON_PRINTING_CHARS_NUMERIC="\001"
## END_NON_PRINTING_CHARS_NUMERIC="\002"

RESET_COLORS="\u001b[0m"
RESET_COLOR="\[\033[00m\]"
RESET_COLORS_A="\001\033[00m\002"

# LIGTH_RED_COLOR="\001\033[91m\002"
# CAYN_COLOR="\001\033[36m\002"
# RESET_COLOR_K8S="\001\033[00m\002"

## Text colors
GREEN_RANGE_84="84"
GREEN_RANGE_71="71"
GREEN_RANGE_36="36"
#
PINK_RANGE_200="200"

## Background colors
BLUE_RANGE_31="31"
BLUE_RANGE_30="30"



__color()
{
    ID=$1
    # local color="\u001b[38;5;${ID}m"
    local color="\[\033[38;5;${ID}m\]"
    # local color="\001\033[38;5;${ID}m\002"
    printf ${color}
}


__color_a()
{
    ID=$1
    # local color="\u001b[38;5;${ID}m"
    # local color="\[\033[38;5;${ID}m\]"
    local color="\001\033[38;5;${ID}m\002"
    printf ${color}
}


__color_bg()
{
    ID=$1
    local colorbg="\[\033[48;5;${ID}m\]"
    # local colorbg="\001\033[48;5;${ID}m\002"
    # local colorbg="\u001b[48;5;${ID}m"
    printf ${colorbg}
}


__color_bg_a()
{
    ID=$1
    # local colorbg="\[\033[48;5;${ID}m\]"
    local colorbg="\001\033[48;5;${ID}m\002"
    # local colorbg="\u001b[48;5;${ID}m"
    printf ${colorbg}
}