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
    get_player_info "${UUID}"
done
