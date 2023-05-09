#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"

LOG=$(cat "${CURRENT_LOG_FILE}")

function get_joins() {
    while read LINE_RAW; do
        if [[ "${LINE_RAW}" != *"joined the game"* && "${LINE_RAW}" != *"left the game"* ]]; then
            continue
        fi
    
        LINE=$(sed 's/^.*Server thread\/INFO\]:\s*//g' <<< "${LINE_RAW}")
        echo "${LINE}"
    done <<< "${LOG}"
}

function get_players_today() {
    get_joins | awk -F" " '{print $1}' | sort | uniq
}

for PLAYER in $(get_players_today); do
    LAST_CONNECTION_LOG_LINE=$(grep "${PLAYER} \(joined\|left\) the game" <<< "${LOG}" | tail -n 1)

    if [[ "${LAST_CONNECTION_LOG_LINE}" == *"joined the game" ]]; then
        echo "${PLAYER}"
    fi
done
