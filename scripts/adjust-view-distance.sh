#!/bin/bash
VIEW_DISTANCE="${1}"
SIMULATION_DISTANCE=5

SERVER_ROOT_DIR="/srv/papermc"
SERVER_PROPERTIES_FILE="${SERVER_ROOT_DIR}/server.properties"
BUKKIT_CONFIG_FILE="${SERVER_ROOT_DIR}/bukkit.yml"
SPIGOT_CONFIG_FILE="${SERVER_ROOT_DIR}/spigot.yml"
PAPER_WORLD_CONFIG_FILE="${SERVER_ROOT_DIR}/config/paper-world-defaults.yml"

if [ -z "${VIEW_DISTANCE}" ]; then
    echo "ERROR: Invalid view distance!"
    exit 1
fi

function change_value() {
    local FILE="${1}"
    local SETTING="${2}"
    local VALUE="${3}"

    echo "${FILE}: ${SETTING}=${VALUE}"
    sudo sed -i 's/^\(\s*\)\('"${SETTING}"'\)\(\s*[=:]\s*\).*$/\1\2\3'"${VALUE}"'/g' "${FILE}"
}

[ ${SIMULATION_DISTANCE} -gt ${VIEW_DISTANCE} ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}


MOB_SPAWN_RANGE=$((SIMULATION_DISTANCE-1))
[ ${MOB_SPAWN_RANGE} -lt 3 ] && MOB_SPAWN_RANGE=3
[ ${MOB_SPAWN_RANGE} -gt 6 ] && MOB_SPAWN_RANGE=6

MOB_DESPAWN_RANGE_HARD=$((MOB_SPAWN_RANGE*16))
[ ${MOB_DESPAWN_RANGE_HARD} -lt 32 ] && MOB_DESPAWN_RANGE_HARD=32

MOB_SPAWN_LIMIT_MONSTER=$((14*(MOB_SPAWN_RANGE-3)+7))
[ ${MOB_SPAWN_LIMIT_MONSTER} -lt 7 ] && MOB_SPAWN_LIMIT_MONSTER=7

change_value "${SERVER_PROPERTIES_FILE}"    "view-distance"         "${VIEW_DISTANCE}"
change_value "${SERVER_PROPERTIES_FILE}"    "simulation-distance"   "${SIMULATION_DISTANCE}"
change_value "${SPIGOT_CONFIG_FILE}"        "view-distance"         "${VIEW_DISTANCE}"
change_value "${SPIGOT_CONFIG_FILE}"        "simulation-distance"   "${SIMULATION_DISTANCE}"
change_value "${SPIGOT_CONFIG_FILE}"        "mob-spawn-range"       "${MOB_SPAWN_RANGE}"
change_value "${PAPER_WORLD_CONFIG_FILE}"   "hard"                  "${MOB_DESPAWN_RANGE_HARD}"
change_value "${BUKKIT_CONFIG_FILE}"        "monsters"              "${MOB_SPAWN_LIMIT_MONSTER}"
