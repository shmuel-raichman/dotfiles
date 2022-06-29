#!/bin/bash
# B"H

HOSTNAME_COLOR=$(__color_a ${GREEN_RANGE_84})
USER_COLOR=$(__color_a ${GREEN_RANGE_84})
AT_HOST_COLOR=$(__color_a 37)

TIME_COLOR=$(__color_bg_a ${BLUE_RANGE_30})

__prompt_time()
{
    local timestamp=$( date +"%Y-%m-%d %H:%M:%S,%3N" )
    [ "$SHOW_TIME" != "false" ] && TIME="${TIME_COLOR}${timestamp}${RESET_COLORS_A}" 
    echo -e "${TIME}" 
}

__prompt_hostname()
{
    [ "$SHOW_HOSTNAME" != "false" ] && { 
        HOSTNAME_COLORED="${HOSTNAME_COLOR}\h${RESET_COLORS_A}"
        USER_AT_COLORED="${AT_HOST_COLOR}@${RESET_COLORS_A}"
        USER_AT_HOST="${USER_AT_COLORED}${HOSTNAME_COLORED}"
    }
    echo -e "${USER_AT_HOST}"
}


__prompt_user()
{
    [ "$SHOW_USER" != "false" ] && {
        USER_COLORED="${USER_COLOR}\u${RESET_COLORS_A}"
    }
    echo -e "${USER_COLORED}"
}