#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

# Bash Histroy
PROMPT_COMMAND='history -a' # Immediately persist commands to .bash_history
HISTSIZE=100000 # Number of lines to keep for history command
HISTFILESIZE=100000000 # Number of lines to keep for ~/.bash_history

### Order is importent here
export DF_PATHES="${DF_HOME}/utils/global-variables/global-pathes.bash"
### Sourcing
# Global pathes sourcing
source ${DF_PATHES}
# Workaround to enable sourcing with variables
source "${DF_HOME}/customize.bash"
