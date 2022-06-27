#!/bin/bash
# B"H

# Remote indicator
REMOTE_INDICATOR_TEXT=""
REMOTE_INDICATOR=""
REMOTE_INDICATOR_COLOR="\[\033[01;46m\]"
# Colors
RESET_COLOR="\[\033[00m\]"
RESET_COLOR_EXTRA="\u001b[0m"
BOLD_BLUE="\[\033[01;34m\]"
GREEN="\[\033[32m\]"
# SOFT_GREEN_
BOLD_GREEN="\[\033[01;32m\]"
SOMEWHAT_YELLOW="\[\033[33;1m\]"

GIT_BRANCH_COLOR=$(__color ${GREEN_RANGE_36})


# Prompt Colored Data
[ "$SHOW_GIT_BRANCH" != "false" ] && GIT_BRANCH_COLORED="${GIT_BRANCH_COLOR}\$(__git_ps1)${RESET_COLOR}"
# Include prompt special character
USER_AND_COLORED="$(__prompt_user)$(__prompt_hostname)"


PS1_FIRST_LINE="\$(__k8s_ps1) ${BOLD_BLUE}\w${RESET_COLOR} ${GIT_BRANCH_COLORED} "
PS1_SECOND_LINE="\$(__prompt_time) ${USER_AND_COLORED}:$ "

# Final prompt
PS1="${PS1_FIRST_LINE}\n${PS1_SECOND_LINE}"