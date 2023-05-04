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
    PLAYER_UUID=$(basename "${PLAYERDATA_FILE}" .dat)
    PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")
    PLAYER_IP=$(get_player_ip "${PLAYER_UUID}")
    
    echo "${PLAYERS_COUNT}: ${PLAYER_USERNAME}:"
    echo "   - UUID:      ${PLAYER_UUID}"
    echo "   - Last IP:   ${PLAYER_IP}"
done
