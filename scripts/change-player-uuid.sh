#!/bin/bash
OLD_UUID="${1}"
NEW_UUID="${2}"

SERVER_ROOT_DIR="/srv/papermc"
SERVER_WORLD_DIR="${SERVER_ROOT_DIR}/world"
SERVER_PLUGINS_DIR="${SERVER_ROOT_DIR}/plugins"
SERVER_SCRIPTS_DIR="${SERVER_ROOT_DIR}/scripts"

if [ -z "${OLD_UUID}" ]; then
    echo "Please proide the old UUID!"
    exit 1
fi

if [ -z "${NEW_UUID}" ]; then
    echo "Please proide the new UUID!"
    exit 2
fi

function move-file() {
    local OLD_FILE="${1}"
    local NEW_FILE="${2}"

    if [ ! -f "${OLD_FILE}" ]; then
        echo "There is no such file '${OLD_FILE}'!"
        return
    fi

    if [ -f "${NEW_FILE}" ]; then
        echo "The file '${NEW_FILE}' already exists!"
        return
    fi

    sudo mv "${OLD_FILE}" "${NEW_FILE}"
}

move-file "${SERVER_WORLD_DIR}/advancements/${OLD_UUID}.json" "${SERVER_ROOT_DIR}/world/advancements/${NEW_UUID}.json"
move-file "${SERVER_WORLD_DIR}/playerdata/${OLD_UUID}.dat" "${SERVER_ROOT_DIR}/world/playerdata/${NEW_UUID}.dat"
move-file "${SERVER_WORLD_DIR}/playerdata/${OLD_UUID}.dat_old" "${SERVER_ROOT_DIR}/world/playerdata/${NEW_UUID}.dat_old"
move-file "${SERVER_WORLD_DIR}/stats/${OLD_UUID}.json" "${SERVER_ROOT_DIR}/world/stats/${NEW_UUID}.json"
move-file "${SERVER_PLUGINS_DIR}/Essentials/userdata/${OLD_UUID}.yml" "${SERVER_ROOT_DIR}/plugins/Essentials/userdata/${NEW_UUID}.yml"

${SHELL} "${SERVER_SCRIPTS_DIR}/fix-permissions.sh"
