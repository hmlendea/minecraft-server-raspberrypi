#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"

LOADED_PLAYERS_CACHE_JSON=""
LOADED_PLAYERS_CACHE_UUID=""

if [ ! -f "${PLAYERS_CACHE_FILE}" ]; then
    sudo touch "${PLAYERS_CACHE_FILE}"
    echo "{}" | sudo tee "${PLAYERS_CACHE_FILE}" &>/dev/null
fi

function get_playerscache_value() {
    local PLAYER_UUID="${1}"
    local PROPERTY="${2}"
    local KEY=$(echo ".${PLAYER_UUID}.${PROPERTY}" | sed -E 's/([^\.]+)/"\1"/g; s/\./\./g')
    local VALUE=""

    if [[ "${PLAYER_UUID}" != "${LOADED_PLAYERS_CACHE_UUID}" ]]; then
        LOADED_PLAYERS_CACHE_UUID="${PLAYER_UUID}"
        LOADED_PLAYERS_CACHE_JSON=$(cat "${PLAYERS_CACHE_FILE}")
    fi
    
    VALUE=$(jq "${KEY}" "${PLAYERS_CACHE_FILE}" <<< "${LOADED_PLAYERS_CACHE_JSON}")
    [ "${VALUE}" == "null" ] && VALUE=""

    echo "${VALUE}"
}

function set_playerscache_value() {
    local PLAYER_UUID="${1}"
    local PROPERTY="${2}"
    local VALUE="${3}"

    set_config_value "${PLAYERS_CACHE_FILE}" "${PLAYER_UUID}.${PROPERTY}" "${VALUE}" $>/dev/null
}

function get_playerdata_value() {
    local PLAYER_UUID="${1}"
    local PROPERTY="${2}"
    
    nbted -p "${WORLD_PLAYERDATA_DIR}/${PLAYER_UUID}.dat" | \
        grep "${PROPERTY}" | \
        sed 's/^.*\"'"${PROPERTY}"'\"\s*[\"]*\([^\"]*\).*/\1/g'
}

function get_player_username() {
    local PLAYER_UUID="${1}"
    local PLAYER_USERNAME=""
    local FOUND_IN_CACHE=false

    if [ -f "/usr/bin/jq" ]; then
        PLAYER_USERNAME=$(get_playerscache_value "${PLAYER_UUID}" "username" | sed 's/\"//g')
        [ -n "${PLAYER_USERNAME}" ] && FOUND_IN_CACHE=true
    
        if [ -z "${PLAYER_USERNAME}" ]; then
            PLAYER_USERNAME=$(get_config_value "${ESSENTIALS_USERDATA_DIR}/${PLAYER_UUID}.yml" "last-account-name")
        fi
        
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
            PLAYER_USERNAME=$(get_playerdata_value "${PLAYER_UUID}" "lastKnownName")
        fi
    fi
    if ! ${FOUND_IN_CACHE} && [ -n "${PLAYER_USERNAME}" ]; then
        set_playerscache_value "${PLAYER_UUID}" "username" "${PLAYER_USERNAME}"
    fi
    
    echo "${PLAYER_USERNAME}"
}

function get_player_ip() {
    local PLAYER_UUID="${1}"
    local PLAYER_IP=$(get_config_value "${ESSENTIALS_USERDATA_DIR}/${PLAYER_UUID}.yml" "ip-address")

    echo "${PLAYER_IP}"
}

function get_player_discord_id() {
    local PLAYER_UUID="${1}"
    local DISCORD_ID=""
    local FOUND_IN_CACHE=false

    if [ -z "${DISCORD_ID}" ]; then
        DISCORD_ID=$(get_playerscache_value "${PLAYER_UUID}" "discordId")
        [ -n "${DISCORD_ID}" ] && FOUND_IN_CACHE=true
    fi
    
    DISCORD_ID=$(jq -r "to_entries | map(select(.value == \"${PLAYER_UUID}\")) | .[0].key" < "${DISCORDSRV_DIR}/linkedaccounts.json")
    [[ "${DISCORD_ID}" == "null" ]] && DISCORD_ID=""

    if ! ${FOUND_IN_CACHE} && [ -n "${DISCORD_ID}" ]; then
        set_playerscache_value "${PLAYER_UUID}" "discordId" "${DISCORD_ID}"
    fi

    echo "${DISCORD_ID}"
}

function get_player_date_seen_first() {
    local PLAYER_UUID="${1}"
    local PLAYER_DATE_REGISTRATION=""
    local FOUND_IN_CACHE=false

    PLAYER_DATE_REGISTRATION=$(get_playerscache_value "${PLAYER_UUID}" "joinTimestamp")
    [ -n "${PLAYER_DATE_REGISTRATION}" ] && FOUND_IN_CACHE=true

    [ -z "${PLAYER_DATE_REGISTRATION}" ] && PLAYER_DATE_REGISTRATION=$(get_playerdata_value "${PLAYER_UUID}" "firstPlayed")

    if [ -n "${PLAYER_DATE_REGISTRATION}" ]; then
        PLAYER_DATE_REGISTRATION=$((PLAYER_DATE_REGISTRATION / 1000))
    fi

    if [ -z "${PLAYER_DATE_REGISTRATION}" ]; then
        local PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")
        PLAYER_DATE_REGISTRATION=$(grep -a " ${PLAYER_USERNAME} registered" "${AUTHME_LOG_FILE}" | head -n 1 | awk -F"]" '{print $1}' | sed 's/^\[//g')

#        [ -n "${PLAYER_DATE_REGISTRATION}" ] && PLAYER_DATE_REGISTRATION=$(date +"%F %T" -d "$(date +%Y)-${PLAYER_DATE_REGISTRATION}")
    fi

    if ! ${FOUND_IN_CACHE} && [ -n "${PLAYER_DATE_REGISTRATION}" ]; then
        set_playerscache_value "${PLAYER_UUID}" "joinTimestamp" "${PLAYER_DATE_REGISTRATION}"
    fi

    date -d @"${PLAYER_DATE_REGISTRATION}"
}


function get_player_date_seen_last() {
    local PLAYER_UUID="${1}"
    local PLAYER_DATE_LASTSEEN=$(get_playerdata_value "${PLAYER_UUID}" "lastPlayed")

    if [ -n "${PLAYER_DATE_LASTSEEN}" ]; then
        PLAYER_DATE_LASTSEEN=$((PLAYER_DATE_LASTSEEN / 1000))
        PLAYER_DATE_LASTSEEN=$(date -d @"${PLAYER_DATE_LASTSEEN}")
    fi

    echo "${PLAYER_DATE_LASTSEEN}"
}

function get_player_location() {
    local PLAYER_UUID="${1}"
    
    local POS_ALL=$(nbted -p "${WORLD_PLAYERDATA_DIR}/${PLAYER_UUID}.dat" | grep -A3 "List \"Pos\"")
    local POS_X_FULL=$(sed -n 2p <<< "${POS_ALL}" | sed 's/\s//g')
    local POS_Y_FULL=$(sed -n 3p <<< "${POS_ALL}" | sed 's/\s//g')
    local POS_Z_FULL=$(sed -n 4p <<< "${POS_ALL}" | sed 's/\s//g')

    local POS_X=$(echo "${POS_X_FULL}" | awk -F"." '{print $1}')
    local POS_Y=$(echo "${POS_Y_FULL}" | awk -F"." '{print $1}')
    local POS_Z=$(echo "${POS_Z_FULL}" | awk -F"." '{print $1}')

    echo "${POS_X} ${POS_Y} ${POS_Z}"
}

function get_player_info() {
    local UUID="${1}"
    local USERNAME=$(get_player_username "${UUID}")
    local IP_ADDRESS=$(get_player_ip "${UUID}")
    local LOCATION=$(get_player_location "${UUID}")
    
    echo "${PLAYERS_COUNT}: "$(get_player_username "${UUID}")":"
    echo "   - UUID       : ${UUID}"
    echo "   - Discord ID : "$(get_player_discord_id "${UUID}")
    echo "   - Seen first : "$(get_player_date_seen_first "${UUID}")
    echo "   - Seen last  : "$(get_player_date_seen_last "${UUID}")
    echo "   - Last IP    : "$(get_player_ip "${UUID}")
    echo "   - Location   : "$(get_player_location "${UUID}")
}
