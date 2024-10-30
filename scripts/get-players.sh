#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"

function get_userdata_prop() {
    local FILE="${1}"
    local PROPERTY="${2}"
    local PROPERTY_ESC=$(echo "${PROPERTY}" | sed -E 's/([^.]+-[^\.\ ]+)(\.|$)/"\1"\2/g')

    yq -r ".${PROPERTY_ESC}" "${FILE}"
}

sudo echo 'SU prigileges granted!'

PLAYERS_COUNT=0
for PLAYER_UUID in $(get_players_uuids); do
    PLAYERS_COUNT=$((PLAYERS_COUNT + 1))
    echo -n "(${PLAYERS_COUNT}) " && get_player_info "${PLAYER_UUID}"
done
