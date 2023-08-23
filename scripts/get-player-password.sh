#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/crypto.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"

function get_player_password() {
    local PLAYER_USERNAME="${1}"
    local PLAYER_UUID=$(get_player_uuid "${PLAYER_USERNAME}")
    local PLAYER_PASSWORD=""
    local FOUND_IN_CACHE=false

    if [ -z "${DISCORD_ID}" ]; then
        PLAYER_PASSWORD=$(get_playerscache_value "${PLAYER_UUID}" "password" | sed 's/\"//g')
        [ -n "${PLAYER_PASSWORD}" ] && FOUND_IN_CACHE=true
    fi
    
    [ -z "${PLAYER_PASSWORD}" ] && PLAYER_PASSWORD=$(decrypt_authme_password "${PLAYER_UUID}")
    
    if ! ${FOUND_IN_CACHE} && [ -n "${PLAYER_PASSWORD}" ]; then
        set_playerscache_value "${PLAYER_UUID}" "password" "${PLAYER_PASSWORD}"
    fi

    echo "${PLAYER_PASSWORD}"
}

get_player_password "${1}"
