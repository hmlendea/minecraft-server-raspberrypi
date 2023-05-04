#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"

function get_player_username() {
    local PLAYER_UUID="${1}"
    local PLAYER_USERNAME=$(get_config_value "${ESSENTIALS_USERDATA_DIR}/${PLAYER_UUID}.yml" "last-account-name")

    if [ -f "/usr/bin/jq" ]; then
        if [ -z "${PLAYER_USERNAME}" ]; then
            PLAYER_USERNAME=$(jq -r --arg uuid "${PLAYER_UUID}" '.[] | select(.uuid == $uuid) | .name' "${SERVER_USERCACHE_FILE}")
        fi
    
        if [ -z "${PLAYER_USERNAME}" ]; then
            PLAYER_USERNAME=$(jq -r --arg uuid "${PLAYER_UUID}" '.[] | select(.uuid == $uuid) | .name' "${SERVER_WHITELIST_FILE}")
        fi
    
        if [ -z "${PLAYER_USERNAME}" ]; then
            PLAYER_USERNAME=$(jq -r --arg uuid "${PLAYER_UUID}" '.[] | select(.uuid == $uuid) | .name' "${SERVER_OPS_FILE}")
        fi
    fi

    if [ -f "/usr/bin/nbted" ]; then
        if [ -z "${PLAYER_USERNAME}" ]; then
            PLAYER_USERNAME=$(nbted -p "${WORLD_PLAYERDATA_DIR}/${PLAYER_UUID}.dat" | grep "lastKnownName" | sed 's/^\s*String\s*\"lastKnownName\"\s*\"\([^\"]*\).*/\1/g')
        fi
    fi
    
    echo "${PLAYER_USERNAME}"
}

function get_player_ip() {
    local PLAYER_UUID="${1}"
    local PLAYER_IP=$(get_config_value "${ESSENTIALS_USERDATA_DIR}/${PLAYER_UUID}.yml" "ip-address")

    echo "${PLAYER_IP}"
}
