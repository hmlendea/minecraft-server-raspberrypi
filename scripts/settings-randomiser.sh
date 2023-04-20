#!/bin/bash

RANDOMISE_PILLAGERS=false

function get_random_boolean() {
  local TRUE_CHANCE_PERCENTAGE=${1}
  
  if (( RANDOM % 100 < TRUE_CHANCE_PERCENTAGE )); then
    echo "true"
  else
    echo "false"
  fi
}

function get_random_element() {
    local ARGS_COUNT=${#}
    local RANDOM_ARG_INDEX=$(( RANDOM % ARGS_COUNT + 1 ))

    echo "${!RANDOM_ARG_INDEX}"
}

function run_server_command() {
    echo " > Running command: /"$*
    papermc command $* &> /dev/null
}

function set_gamerule() {
    local GAMERULE="${1}"
    local VALUE="${2}"

    #echo " > Setting gamerule '${GAMERULE}' to '${VALUE}'..."
    run_server_command gamerule "${GAMERULE}" "${VALUE}"
}

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

randomise_gamerule_bool "doInsomnia" 15
randomise_gamerule_bool "doWeatherCycle" 50

if ${RANDOMISE_PILLAGERS}; then
    randomise_gamerule_bool "disableRaids" 33
    randomise_gamerule_bool "doPatrolSpawning" 66
fi

if papermc status | sed -e 's/\x1b\[[0-9;]*m//g' | grep -q "Status: running"; then
    randomise_difficulty
else
    echo "ERROR: The server is not running!"
    exit 1
fi
