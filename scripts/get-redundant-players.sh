#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

RECENT_MAX_SEEN_LAST=$(( $(date -d "3 months ago" +%s) * 1000 ))
RECENT_MIN_PLAYTIME_MINS=40
OLD_MAX_SEEN_LAST=$(( $(date -d "9 months ago" +%s) * 1000 ))
OLD_MIN_PLAYTIME_HOURS=8

RECENT_MIN_PLAYTIME_TICKS=$(( RECENT_MIN_PLAYTIME_MINS * 60 * 20 ))
OLD_MIN_PLAYTIME_TICKS=$(( OLD_MIN_PLAYTIME_HOURS * 60 * 60 * 20 ))

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
#for PLAYER_UUID in /srv/papermc/plugins/Essentials/userdata/*; do
#    PLAYER_UUID=$(basename "${PLAYER_UUID}" | cut -f 1 -d '.')

    PLAYER_WEALTH=$(get_player_wealth "${PLAYER_UUID}")
    [[ ${#PLAYER_WEALTH} -gt 1 ]] && continue

    PLAYER_SEEN_LAST=$(get_playerdata_value "${PLAYER_UUID}" 'lastPlayed')
    # If the player was seen recently, skip
    [ -n "${PLAYER_SEEN_LAST}" ] && [ ${PLAYER_SEEN_LAST} -gt ${RECENT_MAX_SEEN_LAST} ] && continue

    PLAYER_PLAYTIME_TICKS=$(get_player_playtime "${PLAYER_UUID}")
    [ "${PLAYER_PLAYTIME_TICKS}" = 'Unknown' ] && continue

    # If the player was not seen since a long time
    if [ -n "${PLAYER_SEEN_LAST}" ]; then
        if [ ${PLAYER_SEEN_LAST} -gt ${OLD_MAX_SEEN_LAST} ]; then
            [ ${RECENT_MIN_PLAYTIME_TICKS} -lt ${PLAYER_PLAYTIME_TICKS} ] && continue
        else
            [ ${OLD_MIN_PLAYTIME_TICKS} -lt ${PLAYER_PLAYTIME_TICKS} ] && continue
        fi
    fi

    PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")

    PLAYERS_COUNT=$((PLAYERS_COUNT + 1))
    echo -n "(${PLAYERS_COUNT}) " && get_player_info "${PLAYER_UUID}"
#    sudo rm "/srv/papermc/plugins/Essentials/userdata/${PLAYER_UUID}.yml"
#    run_server_command "authme unregister ${PLAYER_USERNAME}"
done
