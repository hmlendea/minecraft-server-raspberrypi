#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
[ -z "${WORLDGUARD_DIR}" ] && source "${SERVER_SCRIPTS_COMMON_DIR}/worldguard.sh"

if [ -f "${PLAYERS_CACHE_FILE}" ]; then
	LOADED_PLAYERS_CACHE_JSON=$(cat "${PLAYERS_CACHE_FILE}")
fi

if [ ! -f "${PLAYERS_CACHE_FILE}" ]; then
    sudo touch "${PLAYERS_CACHE_FILE}"
    echo "{}" | sudo tee "${PLAYERS_CACHE_FILE}" &>/dev/null
fi

function get_essentials_userdata_value() {
    local PLAYER_UUID="${1}"
    local PROPERTY="${2}"

    if [ -f "${ESSENTIALS_USERDATA_DIR}/${PLAYER_UUID}.yml" ]; then
        get_config_value "${ESSENTIALS_USERDATA_DIR}/${PLAYER_UUID}.yml" "${PROPERTY}"
    else
        echo ''
    fi
}

function get_playerscache_value() {
    local PLAYER_UUID="${1}"
    local PROPERTY="${2}"
    local KEY=$(echo ".${PLAYER_UUID}.${PROPERTY}" | sed -E 's/([^\.]+)/"\1"/g; s/\./\./g')
    local VALUE=""

    [ -z "${LOADED_PLAYERS_CACHE_JSON}" ] && LOADED_PLAYERS_CACHE_JSON=$(cat "${PLAYERS_CACHE_FILE}")
    
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
    local PLAYER_DATA_FILE="${WORLD_PLAYERDATA_DIR}/${PLAYER_UUID}.dat"

    [ ! -f "${PLAYER_DATA_FILE}" ] && return
    
    sudo nbted -p "${PLAYER_DATA_FILE}" | \
        grep "${PROPERTY}" | \
        sed 's/^.*\"'"${PROPERTY}"'\"\s*[\"]*\([^\"]*\).*/\1/g'
}

function get_player_uuid() {
    local PLAYER_USERNAME="${1}"
    local PLAYER_UUID=""
    local FOUND_IN_CACHE=false

    [ -z "${LOADED_PLAYERS_CACHE_JSON}" ] && LOADED_PLAYERS_CACHE_JSON=$(cat "${PLAYERS_CACHE_FILE}")

    PLAYER_UUID=$(jq -r 'to_entries[] | select(.value.username == "'"${PLAYER_USERNAME}"'") | .key' <<< "${LOADED_PLAYERS_CACHE_JSON}" | head -n 1)
    [ "${PLAYER_UUID}" == "null" ] && PLAYER_UUID=""
    [ -n "${PLAYER_UUID}" ] && FOUND_IN_CACHE=true

    [ -z "${PLAYER_UUID}" ] && PLAYER_UUID=$(jq -r --arg username "${PLAYER_USERNAME}" '.[] | select(.name == $username) | .uuid' "${SERVER_USERCACHE_FILE}" | head -n 1)
    [ -z "${PLAYER_UUID}" ] && PLAYER_UUID=$(jq -r --arg username "${PLAYER_USERNAME}" '.[] | select(.name == $username) | .uuid' "${SERVER_WHITELIST_FILE}" | head -n 1)
    [ -z "${PLAYER_UUID}" ] && PLAYER_UUID=$(jq -r --arg username "${PLAYER_USERNAME}" '.[] | select(.name == $username) | .uuid' "${SERVER_OPS_FILE}" | head -n 1)

    if [ -z "${PLAYER_UUID}" ]; then
        local INPUT="OfflinePlayer:${PLAYER_USERNAME}"
        local HASH=$(echo -n "${INPUT}" | md5sum | awk '{print $1}')
        local BYTE_ARRAY=""

        for ((I = 0; I < 32; I+=2)); do
            BYTE_ARRAY+="${HASH:$I:2}"
        done
    
        BYTE6=$((0x${BYTE_ARRAY:6:2} & 0x0f | 0x30))
        BYTE8=$((0x${BYTE_ARRAY:8:2} & 0x3f | 0x80))
        BYTE_ARRAY="${BYTE_ARRAY:0:6}$(printf "%02x" "${BYTE6}")${BYTE_ARRAY:8:2}$(printf "%02x" "${BYTE8}")${BYTE_ARRAY:10}"
        PLAYER_UUID="${BYTE_ARRAY:0:8}-${BYTE_ARRAY:8:4}-${BYTE_ARRAY:12:4}-${BYTE_ARRAY:16:4}-${BYTE_ARRAY:20}"
    fi
    
    echo "${PLAYER_UUID}"
}

function get_player_username() {
    local PLAYER_UUID="${1}"
    local PLAYER_USERNAME=""
    local FOUND_IN_CACHE=false

    if [ -f "/usr/bin/jq" ]; then
        PLAYER_USERNAME=$(get_playerscache_value "${PLAYER_UUID}" "username" | sed 's/\"//g')
        [ -n "${PLAYER_USERNAME}" ] && FOUND_IN_CACHE=true
    
        [ -z "${PLAYER_USERNAME}" ] && PLAYER_USERNAME=$(get_essentials_userdata_value "${PLAYER_UUID}" 'last-account-name')
        [ -z "${PLAYER_USERNAME}" ] && PLAYER_USERNAME=$(jq -r --arg uuid "${PLAYER_UUID}" '.[] | select(.uuid == $uuid) | .name' "${SERVER_USERCACHE_FILE}")
        [ -z "${PLAYER_USERNAME}" ] && PLAYER_USERNAME=$(jq -r --arg uuid "${PLAYER_UUID}" '.[] | select(.uuid == $uuid) | .name' "${SERVER_WHITELIST_FILE}")
        [ -z "${PLAYER_USERNAME}" ] && PLAYER_USERNAME=$(jq -r --arg uuid "${PLAYER_UUID}" '.[] | select(.uuid == $uuid) | .name' "${SERVER_OPS_FILE}")
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
    local PLAYER_IP=$(get_essentials_userdata_value "${PLAYER_UUID}" 'ip-address')

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
    
    if [ -z "${DISCORD_ID}" ] && [ -f "${DISCORDSRV_ACCOUNTS_FILE}" ]; then
        DISCORD_ID=$(sudo grep "${PLAYER_UUID}" "${DISCORDSRV_ACCOUNTS_FILE}" | awk '{print $1}')
    fi
    
    if [ -z "${DISCORD_ID}" ] && [ -f "${DISCORDSRV_DIR}/linkedaccounts.json" ]; then
        DISCORD_ID=$(jq -r "to_entries | map(select(.value == \"${PLAYER_UUID}\")) | .[0].key" < "${DISCORDSRV_DIR}/linkedaccounts.json")
        [[ "${DISCORD_ID}" == "null" ]] && DISCORD_ID=""
    fi
    
    if ! ${FOUND_IN_CACHE} && [ -n "${DISCORD_ID}" ]; then
        set_playerscache_value "${PLAYER_UUID}" "discordId" "${DISCORD_ID}"
    fi

    echo "${DISCORD_ID}"
}

function get_player_date_seen_first() {
    local PLAYER_UUID="${1}"
    local PLAYER_DATE_REGISTRATION=""
    local FOUND_IN_CACHE=false
    local AUTHME_LOG_FILE="$(get_plugin_dir AuthMe)/authme.log"

    PLAYER_DATE_REGISTRATION=$(get_playerscache_value "${PLAYER_UUID}" "joinTimestamp")
    [ -n "${PLAYER_DATE_REGISTRATION}" ] && FOUND_IN_CACHE=true

    if [ -z "${PLAYER_DATE_REGISTRATION}" ]; then
        PLAYER_DATE_REGISTRATION=$(get_playerdata_value "${PLAYER_UUID}" "firstPlayed")

        if [ -n "${PLAYER_DATE_REGISTRATION}" ]; then
            PLAYER_DATE_REGISTRATION=$((PLAYER_DATE_REGISTRATION / 1000))
        fi
    fi
    
    if [ -z "${PLAYER_DATE_REGISTRATION}" ]; then
        local PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")
        PLAYER_DATE_REGISTRATION=$(sudo grep -a " ${PLAYER_USERNAME} registered" "${AUTHME_LOG_FILE}" | head -n 1 | awk -F"]" '{print $1}' | sed 's/^\[//g')

#        [ -n "${PLAYER_DATE_REGISTRATION}" ] && PLAYER_DATE_REGISTRATION=$(date +"%F %T" -d "$(date +%Y)-${PLAYER_DATE_REGISTRATION}")
    fi

    if ! ${FOUND_IN_CACHE} && [ -n "${PLAYER_DATE_REGISTRATION}" ]; then
        set_playerscache_value "${PLAYER_UUID}" "joinTimestamp" "${PLAYER_DATE_REGISTRATION}"
    fi

    [ -z "${PLAYER_DATE_REGISTRATION}" ] && return

    date -d @"${PLAYER_DATE_REGISTRATION}" +"%Y/%m/%d %H:%M:%S (%z)"
}


function get_player_date_seen_last() {
    local PLAYER_UUID="${1}"
    local PLAYER_DATE_LASTSEEN=$(get_playerdata_value "${PLAYER_UUID}" "lastPlayed")

    if [ -n "${PLAYER_DATE_LASTSEEN}" ]; then
        PLAYER_DATE_LASTSEEN=$((PLAYER_DATE_LASTSEEN / 1000))
    fi

    [ -z "${PLAYER_DATE_LASTSEEN}" ] && return

    date -d @"${PLAYER_DATE_LASTSEEN}" +"%Y/%m/%d %H:%M:%S (%z)"
}

function get_player_location() {
    local PLAYER_UUID="${1}"
    local PLAYER_DATA_FILE="${WORLD_PLAYERDATA_DIR}/${PLAYER_UUID}.dat"

    [ ! -f "${PLAYER_DATA_FILE}" ] && return
    
    local POS_ALL=$(sudo nbted -p "${PLAYER_DATA_FILE}" | grep -A3 "List \"Pos\"")
    local POS_X_FULL=$(sed -n 2p <<< "${POS_ALL}" | sed 's/\s//g')
    local POS_Y_FULL=$(sed -n 3p <<< "${POS_ALL}" | sed 's/\s//g')
    local POS_Z_FULL=$(sed -n 4p <<< "${POS_ALL}" | sed 's/\s//g')

    local POS_X=$(echo "${POS_X_FULL}" | awk -F"." '{print $1}')
    local POS_Y=$(echo "${POS_Y_FULL}" | awk -F"." '{print $1}')
    local POS_Z=$(echo "${POS_Z_FULL}" | awk -F"." '{print $1}')

    echo "${POS_X} ${POS_Y} ${POS_Z}"
}

function get_player_spawn() {
    local PLAYER_UUID="${1}"
    local PLAYER_DATA_FILE="${WORLD_PLAYERDATA_DIR}/${PLAYER_UUID}.dat"

    [ ! -f "${PLAYER_DATA_FILE}" ] && return

    local SPAWN_X=$(sudo nbted -p "${PLAYER_DATA_FILE}" | grep "SpawnX" | awk -F"\"" '{print $3}' | sed 's/^\s*\(.*\)\s*$/\1/g')

    [ -z "${SPAWN_X}" ] && return

    local SPAWN_Y=$(sudo nbted -p "${PLAYER_DATA_FILE}" | grep "SpawnY" | awk -F"\"" '{print $3}' | sed 's/^\s*\(.*\)\s*$/\1/g')
    local SPAWN_Z=$(sudo nbted -p "${PLAYER_DATA_FILE}" | grep "SpawnZ" | awk -F"\"" '{print $3}' | sed 's/^\s*\(.*\)\s*$/\1/g')

    echo "${SPAWN_X} ${SPAWN_Y} ${SPAWN_Z}"
}

function get_player_password() {
    local PLAYER_UUID="${1}"

    [ ! -f "${ESSENTIALS_USERDATA_DIR}/${PLAYER_UUID}.yml" ] && return

    local PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")
    local PLAYER_PASSWORD=""
    local FOUND_IN_CACHE=false

    if [ -z "${PLAYER_PASSWORD}" ]; then
        PLAYER_PASSWORD=$(get_playerscache_value "${PLAYER_UUID}" "password" | sed 's/\"//g')
        [ -n "${PLAYER_PASSWORD}" ] && FOUND_IN_CACHE=true
    fi

    [ -z "${PLAYER_PASSWORD}" ] && PLAYER_PASSWORD=$(find_in_logs "${PLAYER_USERNAME}" | grep "/\(auth\|l\|log\|login\) " | tail -n 1 | sed 's/^.*\/\(auth\|l\|log\|login\) \(.*\w\).*/\2/g')
    
    if ! ${FOUND_IN_CACHE} && [ -n "${PLAYER_PASSWORD}" ]; then
        set_playerscache_value "${PLAYER_UUID}" "password" "${PLAYER_PASSWORD}"
    fi

    echo "${PLAYER_PASSWORD}"
}

function get_player_playtime() {
    local PLAYER_UUID="${1}"
    local PLAYER_STATS_FILE="${WORLD_STATS_DIR}/${PLAYER_UUID}.json"

    if [ ! -f "${PLAYER_STATS_FILE}" ]; then
        echo "Unknown"
        return
    fi

    jq ".stats.\"minecraft:custom\".\"minecraft:play_time\"" "${PLAYER_STATS_FILE}"
}

function get_player_wealth() {
    local PLAYER_UUID="${1}"
    local PLAYER_WEALTH=$(get_essentials_userdata_value "${PLAYER_UUID}" 'money')

    [ -z "${PLAYER_WEALTH}" ] && PLAYER_WEALTH=0

    echo "${PLAYER_WEALTH}"
}

function get_player_info() {
    local UUID="${1}"
    
    echo $(get_player_username "${UUID}")":"
    echo "   - UUID       : ${UUID}"
    echo "   - Discord ID : "$(get_player_discord_id "${UUID}")
    echo "   - Seen first : "$(get_player_date_seen_first "${UUID}")
    echo "   - Seen last  : "$(get_player_date_seen_last "${UUID}")
    echo "   - Play time  : "$(convert_ticks_to_duration $(get_player_playtime "${UUID}"))
    echo "   - Last IP    : "$(get_player_ip "${UUID}")
    echo "   - Location   : "$(get_player_location "${UUID}")
    echo "   - Spawn      : "$(get_player_spawn "${UUID}")
    echo "   - Wealth     : "$(get_player_wealth "${UUID}")

    local PLAYER_PASSWORD=$(get_player_password "${UUID}")
    [ -n "${PLAYER_PASSWORD}" ] && echo "   - Password   : ${PLAYER_PASSWORD}"
}

function get_players_uuids() {
    for PLAYERDATA_FILE in "${WORLD_PLAYERDATA_DIR}/"*.dat; do
        basename "${PLAYERDATA_FILE}" ".dat"
    done
}

function get_players_usernames() {
    for PLAYER_UUID in $(get_players_uuids); do
        get_player_username "${PLAYER_UUID}"
    done
}

function get_players_usernames_that_own_regions() {
    [ -n "${1}" ] && local WORLD_NAME="${1}" 
    local WORLDGUARD_WORLD_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/regions.yml"
    local PLAYER_WORLDGUARD_ID=''

    for PLAYER_USERNAME in $(get_players_usernames); do
        PLAYER_WORLDGUARD_ID="$(region_name_to_id ${PLAYER_USERNAME})"
        grep -q ".*_player_${PLAYER_WORLDGUARD_ID}[:_]" "${WORLDGUARD_WORLD_REGIONS_FILE}" && echo "${PLAYER_USERNAME}"
    done
}
