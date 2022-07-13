#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

# "\u001b[38;5;${ID}m
# Non printing characters esacpes
## BEGIN_NON_PRINTING_CHARS="\["
## END_NON_PRINTING_CHARS="\]"
## BEGIN_NON_PRINTING_CHARS_NUMERIC="\001"
## END_NON_PRINTING_CHARS_NUMERIC="\002"

# RESET_COLORS="\u001b[0m"
# RESET_COLOR="\[\033[00m\]"
# RESET_COLORS_A="\001\033[00m\002"


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