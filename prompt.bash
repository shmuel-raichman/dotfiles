#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

# Colors
GIT_BRANCH_COLOR=$(__color ${DF_PS1_GIT_COLOR_CODE})
WD_COLOR=$(__color_a ${DF_PS1_WD_COLOR_CODE})


# Prompt Colored Data
command -v __git_ps1 >/dev/null 2>&1 || SHOW_GIT_BRANCH=false
[ "$SHOW_GIT_BRANCH" != "false" ] && GIT_BRANCH_COLORED="${GIT_BRANCH_COLOR}\$(__git_ps1)${DF_RESET_COLOR}" || GIT_BRANCH_COLORED=""
# Include prompt special character
USER_AND_COLORED="$(__prompt_user)$(__prompt_hostname)"

WORKDIR="${WD_COLOR}\w${DF_RESET_COLORS_A}"

PS1_FIRST_LINE="\$(__exit_code)\$(__k8s_ps1) ${WORKDIR}  ${GIT_BRANCH_COLORED} "
PS1_SECOND_LINE="\$(__prompt_time) ${USER_AND_COLORED}:$ "

# Final prompt
PS1="${PS1_FIRST_LINE}\n${PS1_SECOND_LINE}"

# Extra aliases for cleaner prompt
alias clean='PS1="> "'
alias Clean_k8s='PS1="\$(__k8s_ps1)\n> "'
alias Clean_git='PS1="${GIT_BRANCH_COLORED}\n> "'
alias Clean_wd='PS1="\w\n> "'
alias Clean_wd_colored='PS1="${WORKDIR}\n> "'