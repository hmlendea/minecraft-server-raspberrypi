#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"

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

export VIEW_DISTANCE=8
export VIEW_DISTANCE_TARGET=7 # The View Distance that the server was tested against when ${PLAYERS_TARGET} players were online
export VIEW_DISTANCE_MIN=5
export VIEW_DISTANCE_MAX=10

export VIEW_DISTANCE_NETHER=5
export VIEW_DISTANCE_NETHER_MIN=3
export VIEW_DISTANCE_NETHER_MAX=5

export VIEW_DISTANCE_END=12
export VIEW_DISTANCE_END_MIN=8
export VIEW_DISTANCE_END_MAX=16

export SIMULATION_DISTANCE=5
export SIMULATION_DISTANCE_TARGET=5 # The Simulation Distance that the server was tested against when ${PLAYERS_TARGET} players were online
export SIMULATION_DISTANCE_MIN=3 # Never ever go below 3!!!
export SIMULATION_DISTANCE_MAX=10

export KEEP_SPAWN_LOADED=false

export DESPAWN_RATE_ITEMS_RARE_HOURS=1
export DESPAWN_RATE_ITEMS_DEFAULT_MINUTES=20
export DESPAWN_RATE_ITEMS_MEDIUM_MINUTES=5
export DESPAWN_RATE_ITEMS_FAST_MINUTES=1
export DESPAWN_RATE_ITEMS_INSTANT_SECONDS=30

export LOCALE="en"
export LOCALE_FALLBACK="en"

export AUTOSAVE_MINS=20
export AUTOSAVE_MINS_NETHER=30
export AUTOSAVE_MINS_END=40

[ -z "${VIEW_DISTANCE}" ] && VIEW_DISTANCE=${SIMULATION_DISTANCE}
[ ${VIEW_DISTANCE} -gt ${VIEW_DISTANCE_MAX} ] && VIEW_DISTANCE=${VIEW_DISTANCE_MAX}
[ ${VIEW_DISTANCE} -lt ${VIEW_DISTANCE_MIN} ] && VIEW_DISTANCE=${VIEW_DISTANCE_MIN}
[ -z "${SIMULATION_DISTANCE}" ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -gt ${SIMULATION_DISTANCE_MAX} ] && SIMULATION_DISTANCE=${SIMULATION_DISTANCE_MAX}
[ ${SIMULATION_DISTANCE} -gt ${VIEW_DISTANCE} ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -lt ${SIMULATION_DISTANCE_MIN} ] && SIMULATION_DISTANCE=${SIMULATION_DISTANCE_MIN}
[ -z "${VIEW_DISTANCE}" ] && VIEW_DISTANCE=${SIMULATION_DISTANCE}
[ -z "${SIMULATION_DISTANCE_END}" ] && SIMULATION_DISTANCE_END=${SIMULATION_DISTANCE}
[ -z "${SIMULATION_DISTANCE_NETHER}" ] && SIMULATION_DISTANCE_NETHER=${SIMULATION_DISTANCE}

export SIMULATION_CHUNKS_TARGET=$(( (2 * ${SIMULATION_DISTANCE} + 1) ** 2 * ${PLAYERS_MAX} ))
export VIEW_CHUNKS_TARGET=$(( ((2 * ${VIEW_DISTANCE} + 1) ** 2 - (2 * ${SIMULATION_DISTANCE} + 1) ** 2) * PLAYERS_MAX))

export MOB_SPAWN_RANGE=$((SIMULATION_DISTANCE-1))
[ ${MOB_SPAWN_RANGE} -lt 3 ] && MOB_SPAWN_RANGE=3
[ ${MOB_SPAWN_RANGE} -gt 6 ] && MOB_SPAWN_RANGE=6

export MOB_DESPAWN_RANGE_HARD=$((MOB_SPAWN_RANGE*16))
[ ${MOB_DESPAWN_RANGE_HARD} -lt 32 ] && MOB_DESPAWN_RANGE_HARD=32

export MOB_DESPAWN_RANGE_SOFT=$((MOB_SPAWN_RANGE*4))
[ ${MOB_DESPAWN_RANGE_SOFT} -lt 24 ] && MOB_DESPAWN_RANGE_SOFT=24

export MOB_SPAWN_LIMIT_MONSTER=$((14*(MOB_SPAWN_RANGE-3)+7))
[ ${MOB_SPAWN_LIMIT_MONSTER} -lt 7 ] && MOB_SPAWN_LIMIT_MONSTER=7
