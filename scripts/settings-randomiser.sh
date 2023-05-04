#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"
source "${SERVER_SCRIPTS_DIR}/common/rand.sh"

RANDOMISE_PILLAGERS=false

function randomise_gamerule_bool() {
    local GAMERULE="${1}"
    local TRUE_CHANCE_PERCENTAGE=${2}
    local VALUE="false"

    if [ -z "${TRUE_CHANCE_PERCENTAGE}" ]; then
        echo "ERROR: Couldn't randomise gamerule '${GAMERULE}': Missing percentage argument"
        return
    fi

    VALUE=$(get_random_boolean ${TRUE_CHANCE_PERCENTAGE})

    set_gamerule "${GAMERULE}" "${VALUE}"
}

function randomise_difficulty() {
    local DIFFICULTY="normal"
    DIFFICULTY=$(get_random_element "easy" "normal" "hard")

    run_server_command difficulty "${DIFFICULTY}"
}

if ! ${IS_SERVER_RUNNING}; then
    echo "ERROR: The server is not running!"
    exit 1
fi

randomise_difficulty

randomise_gamerule_bool "doInsomnia" 15
randomise_gamerule_bool "doWeatherCycle" 50

if ${RANDOMISE_PILLAGERS}; then
    randomise_gamerule_bool "disableRaids" 33
    randomise_gamerule_bool "doPatrolSpawning" 66
fi

if [ -f "${CLEANMOTD_CONFIG_FILE}" ]; then
    CURRENT_DATE=$(date +%d%m)
    CURRENT_TIME=$(date +%H%M)
    CURRENT_YEAR=$(date +%Y)

    MAX_PLAYERS=$(get_random_element "112" "314" "420" "613" "666" "873" "911" "8897" "9999" ${CURRENT_DATE} ${CURRENT_TIME} ${CURRENT_YEAR} ${PLAYERS_MAX})
    
    set_config_value "${CLEANMOTD_CONFIG_FILE}" "maxplayers.maxplayers" "${MAX_PLAYERS}"
    reload_plugin "cleanmotd"
fi
