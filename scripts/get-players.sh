#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"

function get_userdata_prop() {
    local FILE="${1}"
    local PROPERTY="${2}"
    local PROPERTY_ESC=$(echo "${PROPERTY}" | sed -E 's/([^.]+-[^\.\ ]+)(\.|$)/"\1"\2/g')

    yq -r ".${PROPERTY_ESC}" "${FILE}"
}

PLAYERS_COUNT=0
for PLAYERDATA_FILE in "${WORLD_PLAYERDATA_DIR}/"*.dat; do
    PLAYERS_COUNT=$((PLAYERS_COUNT + 1))
    UUID=$(basename "${PLAYERDATA_FILE}" .dat)
    USERNAME=$(get_player_username "${UUID}")
    IP_ADDRESS=$(get_player_ip "${UUID}")
    REGISTRATION_DATE=$(get_player_date_registration "${USERNAME}")
    DISCORD_ID=$(get_player_discord_id "${UUID}")
    
    echo "${PLAYERS_COUNT}: ${USERNAME}:"
    echo "   - UUID         : ${UUID}"
    echo "   - Discord ID   : ${DISCORD_ID}"
    echo "   - Registered on: ${REGISTRATION_DATE}"
    echo "   - Last IP      : ${IP_ADDRESS}"
done
