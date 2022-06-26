#!/bin/bash
# B"H

# Remote indicator
REMOTE_INDICATOR_TEXT=""
REMOTE_INDICATOR=""
REMOTE_INDICATOR_COLOR="\[\033[01;46m\]"
# Colors
RESET_COLOR="\[\033[00m\]"
BOLD_BLUE="\[\033[01;34m\]"
GREEN="\[\033[32m\]"
BOLD_GREEN="\[\033[01;32m\]"
SOMEWHAT_YELLOW="\[\033[33;1m\]"
DEFAULT_HOSTANDUSER_COLOR=$GREEN
# Non printing characters esacpes
## BEGIN_NON_PRINTING_CHARS="\["
## END_NON_PRINTING_CHARS="\]"
## BEGIN_NON_PRINTING_CHARS_NUMERIC="\001"
## END_NON_PRINTING_CHARS_NUMERIC="\002"


# Save orginal PS1 before colors apresented as vars
#PS1="\$(k8s_ps1) \[\033[01;34m\]\w\[\033[00m\] \[\033[32m\]$(__git_ps1)\[\033[00m\]\n$REMOTE_INDICATOR ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:$(k8s_ps1)$ "
#PS1 With variables and commands content.
## [LIGTH_BLUE]{Working_diractry}[RESET_COLOR] [GREEN] {GIT_PS1}[RESET_COLOR]
## [WITHE_TEXT_LIGHT_BLUE_BACKGROUND]{REMOTE_INDICATOR} [BOLD_GREEN]{USER}{@}{HOSTNAME}[RESET_COLOR]{:(}[RED]{K8S_CONTEXT}{:}[CAYN]{K8S-NAMESPACE}[RESET_COLOR]{)$ }
#PS1_FIRST_LINE="\$(k8s_ps1)     $BOLD_BLUE\w$RESET_COLOR $GREEN\$(__git_ps1)$RESET_COLOR"
#PS1_SECOND_LINE="$REMOTE_INDICATOR ${debian_chroot:+($debian_chroot)}$DEFAULT_HOSTANDUSER_COLOR\u@\h$RESET_COLOR:$ "

PS1_FIRST_LINE="\$(__k8s_ps1) $BOLD_BLUE\w$RESET_COLOR $GREEN\$(__git_ps1)$RESET_COLOR"
PS1_SECOND_LINE="$REMOTE_INDICATOR ${debian_chroot:+($debian_chroot)}$DEFAULT_HOSTANDUSER_COLOR\u@\h$RESET_COLOR:$ "

PS1="$PS1_FIRST_LINE\n$PS1_SECOND_LINE"
# Prompt
# Green
# PS1='\[\033[01;34m\]\w\[\033[00m\] \[\033[32m\]$(__git_ps1)\[\033[00m\]\n${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:$(k8s_ps1)$ '
# Somewhat yellow, not sure how to call this collor.
# PS1='\[\033[01;34m\]\w\[\033[00m\] \[\033[32m\]$(__git_ps1)\[\033[0;32m\]\n${debian_chroot:+($debian_chroot)}\[\033[33;1m\]\u@\h\[\033[00m\]:$(k8s_ps1)$ '