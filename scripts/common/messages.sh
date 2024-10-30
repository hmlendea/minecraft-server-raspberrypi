#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

export BULLETPOINT_LIST_MARKER="${COLOUR_RESET} ${COLOUR_RESET} ${COLOUR_MESSAGE}• "
INCLUDE_HANDLE_SIGN_IN_PLAYER_NAMES=false

function normalise_message() {
    local MESSAGE_COLOUR="${1}" && shift
    local MESSAGE_SUFFIX="${1}" && shift
    local MESSAGE="${*}"
    local LAST_CHAR="${MESSAGE: -1}"
    local MESSAGE_NORMALISED=""

    if [[ "${LAST_CHAR}" =~ [[:punct:]] ]]; then
        MESSAGE_NORMALISED="${MESSAGE}"
    else
        MESSAGE_NORMALISED="${MESSAGE}${MESSAGE_COLOUR}${MESSAGE_SUFFIX}"
    fi

    MESSAGE_NORMALISED=$(echo "${MESSAGE_NORMALISED}" | sed 's/'"'"'{\([a-zA-Z0-9]*\)}'"'"'/{\1}/g')
    MESSAGE_NORMALISED=$(echo "${MESSAGE_NORMALISED}" | sed 's/'"'"'/\\\\'"'"'/g')

    echo "${MESSAGE_NORMALISED}"
}

function match_category_to_symbol() {
    if  echo "${1}" | grep -q "${2}"; then
        echo "${3}"
    fi
}

function get_symbol_by_category() {
    local STATUS="${1}" && shift
    local CATEGORY="${1}"
    local SYMBOL=""

    local DEFAULT_SYMBOL="⏺"
    local ERROR_SYMBOL="✘"
    local SUCCESS_SYMBOL="✔"

    [[ "${STATUS}" == "error" ]] && DEFAULT_SYMBOL="${ERROR_SYMBOL}" 
    [[ "${STATUS}" == "success" ]] && DEFAULT_SYMBOL="${SUCCESS_SYMBOL}" 

    local ANTICHEAT_SYMBOL='⌀'
    local AUTHENTICATION_SYMBOL="🔑"
    local AXE_SYMBOL='🪓'
    local COMBAT_SYMBOL="🗡"
    local DEFENCE_SYMBOL="⛨"
    local DOCK_SYMBOL='⚓'
    local ECONOMY_SYMBOL="💰" # "₦"
    local EDIT_SYMBOL='✎'
    local FARM_SYMBOL="🚜"
    local FLAG_SYMBOL='⚐'
    local GAMEMODE_SYMBOL="◎"
    local HEALTH_SYMBOL="✚"
    local HELP_SYMBOL='ⓘ'
    local HOME_SYMBOL="🛏"
    local INSPECT_SYMBOL="🔍"
    local INVENTORY_SYMBOL="🎒"
    local LIGHT_SYMBOL="💡"
    local MESSAGE_SYMBOL="✉"
    local MILITARY_SYMBOL="⚔"
    local MINE_SYMBOL="⛏"
    local MOUNT_SYMBOL="🐎"
    local MOVEMENT_SYMBOL="≈"
    local PLAYER_SYMBOL="☻"
    local SETTLEMENT_SYMBOL="🏙"
    local SKIN_SYMBOL='👕'
    local TELEPORT_SYMBOL='➜'
    local TIME_SYMBOL='⌚'
    local VOTE_SYMBOL='❤'
    local WEATHER_SYMBOL='☂'

    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'anticheat' "${ANTICHEAT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "auth.*" "${AUTHENTICATION_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "border_.*" "${DEFENCE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "break_block" "${MINE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "combat" "${COMBAT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'consulate' "${FLAG_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "default" "${DEFAULT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "defence_.*" "${DEFENCE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "denied" "${ERROR_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'dock' "${DOCK_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'edit' "${DIT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "error" "${ERROR_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "farm.*" "${FARM_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "fail.*" "${ERROR_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'gamemode' "${GAMEMODE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'health' "${HEALTH_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'help' "${HELP_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'home' "${HOME_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'hospital' "${HEALTH_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "inspect" "${INSPECT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "inventory" "${INVENTORY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'light' "${LIGHT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "message" "${MESSAGE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "military_base" "${MILITARY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'mine' "${MINE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'money' "${ECONOMY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'mount' "${MOUNT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'movement' "${MOVEMENT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'name' "${DIT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'office_post' "${OFFICE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "other" "${DEFAULT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "player" "${PLAYER_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "player_.*" "${HOME_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "settlement_.*" "${SETTLEMENT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'skin' "${SKIN_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'teleport' "${TELEPORT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'time' "${TIME_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'trade' "${ECONOMY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'voivodeship' "${FLAG_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'vote' "${VOTE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'warehouse' "${INVENTORY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'warp' "${TELEPORT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'weather' "${WEATHER_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'woodcutting' "${AXE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'worldedit' "${AXE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" 'zone' "${FLAG_SYMBOL}")

    [ -z "${SYMBOL}" ] && SYMBOL="${DEFAULT_SYMBOL}"
    echo "${SYMBOL}"
}

function get_formatted_message() {
    local STATUS="${1}" && shift
    local CATEGORY="${1}" && shift
    local CATEGORY_COLOUR="${COLOUR_ACTION}"
    local SYMBOL=$(get_symbol_by_category "${STATUS}" "${CATEGORY}")
    local MESSAGE="$(normalise_message ${COLOUR_MESSAGE} . ${*})"

    [[ "${STATUS}" == "info" ]] && CATEGORY_COLOUR="${COLOUR_ACTION}"
    [[ "${STATUS}" == "success" ]] && CATEGORY_COLOUR="${COLOUR_SUCCESS}"
    [[ "${STATUS}" == "error" ]] && CATEGORY_COLOUR="${COLOUR_ERROR}"
    
    echo "${CATEGORY_COLOUR}${SYMBOL} ${COLOUR_MESSAGE}${MESSAGE}"
}

function get_formatted_message_minimessage() {
    local LEGACY_MESSAGE="$(get_formatted_message ${@})"
    convert_message_to_minimessage "${LEGACY_MESSAGE}"
}

function get_reload_message() {
    local PLUGIN_NAME="${1}"
    local PLUGIN_VERSION="${2}"

    if [ "${LOCALE}" = 'ro' ]; then
        if [ -z "${PLUGIN_VERSION}" ]; then
            get_formatted_message success plugin "S-a reîncărcat $(get_plugin_mention ${PLUGIN_NAME})"
        else
            get_formatted_message success plugin "S-a reîncărcat $(get_plugin_mention ${PLUGIN_NAME}), versiunea $(get_highlighted_message ${PLUGIN_VERSION})"
        fi
    else
        if [ -z "${PLUGIN_VERSION}" ]; then
            get_formatted_message success plugin "Reloaded $(get_plugin_mention ${PLUGIN_NAME})"
        else
            get_formatted_message success plugin "Reloaded $(get_plugin_mention ${PLUGIN_NAME}), version $(get_highlighted_message ${PLUGIN_VERSION})"
        fi
    fi
}

function get_reloading_message() {
    local PLUGIN_NAME="${1}"

    if [ "${LOCALE}" = 'ro' ]; then
        get_formatted_message info plugin "Se reîncarcă $(get_coloured_message ${COLOUR_PLUGIN} ${PLUGIN_NAME})"
    else
        get_formatted_message info plugin "Reloading $(get_coloured_message ${COLOUR_PLUGIN} ${PLUGIN_NAME})..."
    fi
}

function get_reload_message_minimessage() {
    local PLUGIN_NAME="${1}"
    local PLUGIN_VERSION="${2}"

    echo $(convert_message_to_minimessage $(get_reload_message "${PLUGIN_NAME}" "${PLUGIN_VERSION}"))
}

function get_reloading_message_minimessage() {
    local PLUGIN_NAME="${1}"

    echo $(convert_message_to_minimessage $(get_reloading_message "${PLUGIN_NAME}"))
}

function get_plugin_enablement_message() {
    local PLUGIN_NAME="${1}"
    local STATUS="${2}"

    if [ "${LOCALE}" = 'ro' ]; then
        if [[ "${STATUS}" == disab* ]]; then
            get_formatted_message success plugin "$(get_plugin_mention ${PLUGIN_NAME}) a fost $(get_enablement_message dezactivat)"
        elif [[ "${STATUS}" == enab* ]]; then
            get_formatted_message success plugin "$(get_plugin_mention ${PLUGIN_NAME}) a fost $(get_enablement_message activat)"
        fi
    else
        if [[ "${STATUS}" == disab* ]]; then
            get_formatted_message success plugin "$(get_plugin_mention ${PLUGIN_NAME}) was $(get_enablement_message disabled)"
        elif [[ "${STATUS}" == enab* ]]; then
            get_formatted_message success plugin "$(get_plugin_mention ${PLUGIN_NAME}) was $(get_enablement_message enabled)"
        fi
    fi
}

function get_plugin_enablement_minimessage() {
    local PLUGIN_NAME="${1}"
    local STATUS="${2}"

    echo $(convert_message_to_minimessage $(get_plugin_enablement_message "${PLUGIN_NAME}" "${STATUS}"))
}

function get_plugin_linked_message() {
    local PLUGIN1_NAME="${1}"
    local PLUGIN2_NAME="${2}"

    if [ "${LOCALE}" = 'ro' ]; then
        get_formatted_message success plugin "$(get_plugin_mention ${PLUGIN1_NAME}) s-a conectat cu $(get_plugin_mention ${PLUGIN2_NAME})"
    else
        get_formatted_message success plugin "$(get_plugin_mention ${PLUGIN1_NAME}) connected with $(get_plugin_mention ${PLUGIN2_NAME})"
    fi
}

function get_plugin_linked_minimessage() {
    local PLUGIN1_NAME="${1}"
    local PLUGIN2_NAME="${2}"

    echo $(convert_message_to_minimessage $(get_plugin_linked_message "${PLUGIN1_NAME}" "${PLUGIN2_NAME}"))
}

function get_info_message() {
    echo $(get_formatted_message 'info' 'info' "${*}")
}

function get_info_minimessage() {
    echo $(get_formatted_message_minimessage 'info' 'info' "${*}")
}

function get_action_message() {
    local PLAYER_NAME="${1}" && shift
    local MESSAGE="$(normalise_message ${COLOUR_ACTION} ! ${*})"
    echo "${COLOUR_PLAYER}${PLAYER_NAME} ${COLOUR_ACTION}${MESSAGE}"
}

function get_action_message_minimessage() {
    convert_message_to_minimessage "$(get_action_message ${*})"
}

function get_announcement_message() {
    local MESSAGE="$(normalise_message ${COLOUR_ANNOUNCEMENT} !!! ${*})"
    echo "${COLOUR_YELLOW}☀ ${COLOUR_ANNOUNCEMENT}${MESSAGE}"
}

function get_announcement_message_minimessage() {
    local MESSAGE="$(normalise_message ${COLOUR_ANNOUNCEMENT_MINIMESSAGE} !!! ${*})"
    echo "${COLOUR_YELLOW_MINIMESSAGE}☀ ${COLOUR_ANNOUNCEMENT_MINIMESSAGE}${MESSAGE}"
}

function get_death_by_mob_message() {
    local PLAYER_NAME="${1}" && shift
    local MOB_NAME="${2}" && shift
    get_action_message "${PLAYER_NAME}" "was killed by ${COLOUR_HIGHLIGHT}${MOB_NAME}" 
}

function get_itemlore_message() {
    local MESSAGE="${*}"
    echo "$(convert_message_to_ampersand $(get_coloured_message ${COLOUR_ITEMLORE} ${MESSAGE}))"
}

function get_coloured_message() {
    local COLOUR="${1}" && shift
    local MESSAGE="${*}"

    echo "${COLOUR}${MESSAGE}${COLOUR_MESSAGE}"
}

function get_highlighted_message() {
    local MESSAGE="${*}"

    echo $(get_coloured_message "${COLOUR_HIGHLIGHT}" "${MESSAGE}")
}

function get_obscured_message() {
    local MESSAGE="${*}"

    echo $(get_coloured_message "${COLOUR_OBSCURE}" "${MESSAGE}")
}

function get_enablement_message() {
    local COLOUR="${COLOUR_HIGHLIGHT}"
    local STATUS="${*}"

    if [[ "${STATUS}" == dezact* ]] \
    || [[ "${STATUS}" == disabl* ]] \
    || [[ "${STATUS}" == Disabl* ]] \
    || [[ "${STATUS}" == opri* ]]; then
        COLOUR="${COLOUR_ERROR}"
    elif [[ "${STATUS}" == activ* ]] \
      || [[ "${STATUS}" == enabl* ]] \
      || [[ "${STATUS}" == Enabl* ]] \
      || [[ "${STATUS}" == porni* ]]; then
        COLOUR="${COLOUR_SUCCESS}"
    fi

    echo $(get_coloured_message "${COLOUR}" "${STATUS}")
}

function get_enablement_minimessage() {
    convert_message_to_minimessage $(get_enablement_message ${@})
}

function get_player_mention() {
    local PLAYER_NAME="${1}"
    local TEXT=''

    TEXT=$(get_coloured_message "${COLOUR_PLAYER}" "${PLAYER_NAME}")

    if ${INCLUDE_HANDLE_SIGN_IN_PLAYER_NAMES}; then
        TEXT="${COLOUR_HIGHLIGHT}@${TEXT}"
    fi

    echo "${TEXT}"
}

function get_plugin_mention() {
    local PLUGIN_NAME="${1}"

    echo $(get_coloured_message "${COLOUR_PLUGIN}" "${PLUGIN_NAME}")
}

function get_location_mention() {
    local LOCATION_NAME="${*}"
    local TEXT=''

    TEXT=$(get_coloured_message "${COLOUR_SETTLEMENT}" "${LOCATION_NAME}")

    echo "${TEXT}"
}

function get_command_mention() {
    local MESSAGE="${*}"
    
    echo $(get_coloured_message "${COLOUR_COMMAND}" "${MESSAGE}")
}

function convert_message_to_minimessage() {
    local MESSAGE="${@}"
    echo "${MESSAGE}" | sed \
        -e 's/'"${COLOUR_AQUA}"'/'"${COLOUR_AQUA_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_GREEN_DARK}"'/'"${COLOUR_GREEN_DARK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_GREEN_LIGHT}"'/'"${COLOUR_GREEN_LIGHT_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_GREY}"'/'"${COLOUR_GREY_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_GREY_DARK}"'/'"${COLOUR_GREY_DARK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_ORANGE}"'/'"${COLOUR_ORANGE_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_PINK}"'/'"${COLOUR_PINK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_PURPLE_DARK}"'/'"${COLOUR_PURPLE_DARK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_RED}"'/'"${COLOUR_RED_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_RED_DARK}"'/'"${COLOUR_RED_DARK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_WHITE}"'/'"${COLOUR_WHITE_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_YELLOW}"'/'"${COLOUR_YELLOW_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_RESET}"'/'"${COLOUR_RESET_MINIMESSAGE}"'/g'
}

function convert_message_to_ampersand() {
    local MESSAGE="${@}"
    echo "${MESSAGE}" | sed 's/§/\&/g'
}
