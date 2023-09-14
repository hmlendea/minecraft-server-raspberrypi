#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

OLD_UUID="${1}"
NEW_UUID="${2}"

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

sudo sed -i "${WORLDGUARD_WORLD_REGIONS_FILE}" 's/'"${OLD_UUID}"'/'"${NEW_UUID}"'/g'
reload_plugin "worldguard"

move-file "${WORLD_ADVANCEMENTS_DIR}/${OLD_UUID}.json" "${WORLD_ADVANCEMENTS_DIR}/${NEW_UUID}.json"
move-file "${WORLD_PLAYERDATA_DIR}/${OLD_UUID}.dat" "${WORLD_PLAYERDATA_DIR}/${NEW_UUID}.dat"
move-file "${WORLD_PLAYERDATA_DIR}/${OLD_UUID}.dat_old" "${WORLD_PLAYERDATA_DIR}/${NEW_UUID}.dat_old"
move-file "${WORLD_STATS_DIR}/${OLD_UUID}.json" "${WORLD_STATS_DIR}/${NEW_UUID}.json"
move-file "${ESSENTIALS_DIR}/userdata/${OLD_UUID}.yml" "${ESSENTIALS_DIR}/userdata/${NEW_UUID}.yml"

${SHELL} "${SERVER_SCRIPTS_DIR}/fix-permissions.sh"
