#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

export BULLETPOINT_LIST_MARKER="${COLOUR_RESET} ${COLOUR_RESET} ${COLOUR_RESET} ${COLOUR_MESSAGE}• "
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

    local AUTHENTICATION_SYMBOL="🔑"
    local COMBAT_SYMBOL="🗡"
    local DEFENCE_SYMBOL="⛨"
    local ECONOMY_SYMBOL="💰" # "₦"
    local FARM_SYMBOL="🚜"
    local GAMEMODE_SYMBOL="◎"
    local HOME_SYMBOL="🛏"
    local INSPECT_SYMBOL="🔍"
    local INVENTORY_SYMBOL="🎒"
    local MESSAGE_SYMBOL="✉"
    local MILITARY_SYMBOL="⚔"
    local MINE_SYMBOL="⛏"
    local MOUNT_SYMBOL="🐎"
    local PLAYER_SYMBOL="☻"
    local SETTLEMENT_SYMBOL="🏙"
    local SKIN_SYMBOL="👕"
    local TELEPORT_SYMBOL="➜"
    local VOTE_SYMBOL="❤"
    local WORLDEDIT_SYMBOL="🪓"

    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "auth.*" "${AUTHENTICATION_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "border_.*" "${DEFENCE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "break_block" "${MINE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "combat" "${COMBAT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "default" "${DEFAULT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "defence_.*" "${DEFENCE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "denied" "${ERROR_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "error" "${ERROR_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "farm.*" "${FARM_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "fail.*" "${ERROR_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "gamemode" "${GAMEMODE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "home" "${HOME_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "inspect" "${INSPECT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "inventory" "${INVENTORY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "message" "${MESSAGE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "military_base" "${MILITARY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "mount" "${MOUNT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "other" "${DEFAULT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "player" "${PLAYER_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "player_.*" "${HOME_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "settlement_.*" "${SETTLEMENT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "skin" "${SKIN_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "teleport" "${TELEPORT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "trade" "${ECONOMY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "vote" "${VOTE_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "warehouse" "${INVENTORY_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "warp" "${TELEPORT_SYMBOL}")
    [ -z "${SYMBOL}" ] && SYMBOL=$(match_category_to_symbol "${CATEGORY}" "worldedit" "${WORLDEDIT_SYMBOL}")

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

    if [ "${LOCALE}" == "ro" ]; then
        if [ -z "${PLUGIN_VERSION}" ]; then
            get_formatted_message success plugin "S-a reîncărcat ${COLOUR_PLUGIN}${PLUGIN_NAME}${COLOUR_MESSAGE}"
        else
            get_formatted_message success plugin "S-a reîncărcat ${COLOUR_PLUGIN}${PLUGIN_NAME}${COLOUR_MESSAGE}, versiunea ${COLOUR_HIGHLIGHT}${PLUGIN_VERSION}"
        fi
    else
        if [ -z "${PLUGIN_VERSION}" ]; then
            get_formatted_message success plugin "Reloaded ${COLOUR_PLUGIN}${PLUGIN_NAME}${COLOUR_MESSAGE}"
        else
            get_formatted_message success plugin "Reloaded ${COLOUR_PLUGIN}${PLUGIN_NAME}${COLOUR_MESSAGE}, version ${COLOUR_HIGHLIGHT}${PLUGIN_VERSION}"
        fi
    fi
}

function get_reload_message_minimessage() {
    local PLUGIN_NAME="${1}"
    local PLUGIN_VERSION="${2}"

    if [ "${LOCALE}" == "ro" ]; then
        if [ -z "${PLUGIN_VERSION}" ]; then
            get_formatted_message_minimessage success plugin "S-a reîncărcat ${COLOUR_PLUGIN_MINIMESSAGE}${PLUGIN_NAME}${COLOUR_MESSAGE_MINIMESSAGE}"
        else
            get_formatted_message_minimessage success plugin "S-a reîncărcat ${COLOUR_PLUGIN_MINIMESSAGE}${PLUGIN_NAME}${COLOUR_MESSAGE_MINIMESSAGE}, versiunea ${COLOUR_HIGHLIGHT_MINIMESSAGE}${PLUGIN_VERSION}"
        fi
    else
        if [ -z "${PLUGIN_VERSION}" ]; then
            get_formatted_message_minimessage success plugin "Reloaded ${COLOUR_PLUGIN_MINIMESSAGE}${PLUGIN_NAME}${COLOUR_MESSAGE_MINIMESSAGE}"
        else
            get_formatted_message_minimessage success plugin "Reloaded ${COLOUR_PLUGIN_MINIMESSAGE}${PLUGIN_NAME}${COLOUR_MESSAGE_MINIMESSAGE}, version ${COLOUR_HIGHLIGHT_MINIMESSAGE}${PLUGIN_VERSION}"
        fi
    fi
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

function get_player_mention() {
    local PLAYER_NAME="${1}"
    local TEXT=""

    if ${INCLUDE_HANDLE_SIGN_IN_PLAYER_NAMES}; then
        TEXT="${COLOUR_HIGHLIGHT}@"
    fi

    TEXT="${TEXT}${COLOUR_PLAYER}${PLAYER_NAME}${COLOUR_MESSAGE}"

    echo "${TEXT}"
}

function convert_message_to_minimessage() {
    local MESSAGE="${@}"
    echo "${MESSAGE}" | sed \
        -e 's/'"${COLOUR_AQUA}"'/'"${COLOUR_AQUA_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_GREEN_DARK}"'/'"${COLOUR_GREEN_DARK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_GREEN_LIGHT}"'/'"${COLOUR_GREEN_LIGHT_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_GREY}"'/'"${COLOUR_GREY_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_ORANGE}"'/'"${COLOUR_ORANGE_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_PINK}"'/'"${COLOUR_PINK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_PURPLE_DARK}"'/'"${COLOUR_PURPLE_DARK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_RED}"'/'"${COLOUR_RED_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_RED_DARK}"'/'"${COLOUR_RED_DARK_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_WHITE}"'/'"${COLOUR_WHITE_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_YELLOW}"'/'"${COLOUR_YELLOW_MINIMESSAGE}"'/g' \
        -e 's/'"${COLOUR_RESET}"'/'"${COLOUR_RESET_MINIMESSAGE}"'/g'
}
