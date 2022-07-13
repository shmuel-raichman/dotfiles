#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

### Order is importent here
export DF_PATHES="${DF_HOME}/utils/global-variables/global-pathes.bash"
### Sourcing
# Global pathes sourcing
source ${DF_PATHES}
# Workaround to enable sourcing with variables
source "${DF_HOME}/customize.bash"