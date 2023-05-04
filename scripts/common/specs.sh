#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"

function get_server_property() {
    local KEY="${1}"
    local FALLBACK_VALUE="${2}"
    
    local VALUE=$(cat "${SERVER_PROPERTIES_FILE}" | \
        grep "^${KEY}\s*=" | \
        awk -F"=" '{print $2}')

    [ -z "${VALUE}" ] && VALUE="${FALLBACK_VALUE}"
    echo "${VALUE}"
}

export WORLD_NAME=$(get_server_property "level-name" "world")

export WORLD_END_NAME="${WORLD_NAME}_the_end"
export WORLD_NETHER_NAME="${WORLD_NAME}_nether"
export SERVER_NAME=$(get_server_property "server-name" "MineCraft Server")

export PLAYERS_MAX=10
export PLAYERS_TARGET=6 # The amount of players the server was tested against
