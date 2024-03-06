#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

HOSTNAME_COLOR=$(__color_a ${GREEN_RANGE_84})
USER_COLOR=$(__color_a ${GREEN_RANGE_84})
AT_HOST_COLOR=$(__color_a 37)
CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"

# TIME_COLOR=$(__color_bg_a ${BLUE_RANGE_30})
TIME_COLOR=$(__color_a ${GREEN_RANGE_36})

__prompt_time()
{
    local timestamp=$( date +"%Y-%m-%d %H:%M:%S,%3N" )
    [ "$SHOW_TIME" != "false" ] && TIME="${TIME_COLOR}${timestamp}${DF_RESET_COLORS_A}" 
    echo -e "${TIME}" 
}


__exit_code()
{
    exit_code=${?}
    ERR_EXIT_COLOR=$(__color_a 196)
    GOOD_EXIT_COLOR=$(__color_a 46)
    EXIT_COLOR=""
    if [ "$exit_code" = "0" ]; then
        # EXIT_COLOR=$GOOD_EXIT_COLOR
        EXIT_COLOR=$CHECK_MARK
        colored_exit=${EXIT_COLOR}${DF_RESET_COLORS_A}
    else
        EXIT_COLOR=$ERR_EXIT_COLOR
        colored_exit=${EXIT_COLOR}${exit_code}${DF_RESET_COLORS_A}
    fi
    # colored_exit=${EXIT_COLOR}${exit_code}${DF_RESET_COLORS_A}
    echo -e [${colored_exit}]
}

__prompt_hostname()
{
    [ "$SHOW_HOSTNAME" != "false" ] && { 
        HOSTNAME_COLORED="${HOSTNAME_COLOR}\h${DF_RESET_COLORS}"
        USER_AT_COLORED="${AT_HOST_COLOR}@${DF_RESET_COLORS_A}"
        USER_AT_HOST="${USER_AT_COLORED}${HOSTNAME_COLORED}"
    }
    echo -e "${USER_AT_HOST}"
}


__prompt_user()
{
    [ "$SHOW_USER" != "false" ] && {
        USER_COLORED="${USER_COLOR}\u${DF_RESET_COLORS_A}"
    }
    echo -e "${USER_COLORED}"
}


__prompt_emoji()
{
    # [ "$SHOW_EMOJI" != "false" ] && {
        EMOJI="[$(cat $EMOJIS_PATH | head -n $(shuf -i1-869 -n1) | tail -n 1 | awk '{print $1}')]"
    # } || EMOJI=""
    echo -e "${EMOJI}${DF_RESET_COLORS_A}"
}


__prompt_first_line()
{
    local RIGHT=$1
    local LEFT=$2

    LINE=$(printf "%*s\r%s " "$(($(tput cols)+${COMPENSATE}))" "${LEFT}" "${RIGHT}")

    echo "HHHH$line"
}
# PS1_FIRST_LINE=$(printf "%*s\r%s " "$(($(tput cols)+${COMPENSATE}))" "${LEFT_PS1}" "${RIGHT_PS1}")

__prompt_distro()
{
    [ "$SHOW_DISTRO" != "false" ] && { 
        distro_release=$(lsb_release -r | awk '{print $2}')
        distro_name=$(lsb_release -i | awk '{print $3}')
        distro="${distro_name}:${distro_release}"
        DISTRO_COLORED="${HOSTNAME_COLOR}${distro}${DF_RESET_COLORS_A}"
        AT_COLORED="${AT_HOST_COLOR}@${DF_RESET_COLORS_A}"
        AT_DISTRO="${AT_COLORED}${DISTRO_COLORED}"
    }
    echo -e "${AT_DISTRO}"
}
