#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

MIN_PLAYTIME_MINS=5
MIN_PLAYTIME_TICKS=$((MIN_PLAYTIME_MINS*60*20))

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
    PLAYER_PLAYTIME_TICKS=$(get_player_playtime "${PLAYER_UUID}")
    PLAYER_REGISTRATION_YEAR=$(get_player_date_seen_first "${PLAYER_UUID}" | awk -F"/" '{print $1}')
    PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")
    PLAYER_WEALTH=$(get_player_wealth "${PLAYER_UUID}")

    [ "${PLAYER_PLAYTIME_TICKS}" = 'Unknown' ] && continue
    [ ${MIN_PLAYTIME_TICKS} -lt ${PLAYER_PLAYTIME_TICKS} ] && continue
    [ ${PLAYER_REGISTRATION_YEAR} -lt 2023 ] && continue
    [ ${PLAYER_WEALTH} -gt 0 ] && continue

    echo -n "(${PLAYERS_COUNT}) " && get_player_info "${PLAYER_UUID}"
#    sudo rm "/srv/papermc/plugins/Essentials/userdata/${PLAYER_UUID}.yml"
#    run_server_command "authme unregister ${PLAYER_USERNAME}"
done
