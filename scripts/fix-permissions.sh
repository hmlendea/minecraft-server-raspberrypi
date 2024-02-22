#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

function setown() {
    for ITEM in "$@"; do
        sudo chown papermc:papermc -R "${ITEM}"
    done
}

function setexe() {
    for FILE in "$@"; do
        [ -h "${FILE}" ] && continue

        sudo chmod +x -R "${FILE}"
    done
}

function setmod() {
    local MOD="${1}" && shift

    for FILE in "$@"; do
        [ -h "${FILE}" ] && continue

        sudo chmod ${MOD} "${FILE}"
    done
}

setown "${SERVER_ROOT_DIR}/"*.jar
setown "${SERVER_ROOT_DIR}/"*.yml
setown "${SERVER_ROOT_DIR}/config"
setown "${SERVER_ROOT_DIR}/${WORLD_NAME}"
setown "${SERVER_ROOT_DIR}/${WORLD_NETHER_NAME}"
setown "${SERVER_ROOT_DIR}/${WORLD_END_NAME}"
setown "${SERVER_PLUGINS_DIR}"
[ -f "${WEBMAP_DIR}/pl3xmap.js" ] && setown "${WEBMAP_DIR}"

setexe "${SERVER_ROOT_DIR}/"*.jar
setexe "${SERVER_PLUGINS_DIR}/"*.jar

setmod 644 "${WORLD_ADVANCEMENTS_DIR}/"*.json
setmod 644 "${WORLD_PLAYERDATA_DIR}/"*.dat
setmod 644 "${WORLD_PLAYERDATA_DIR}/"*.dat_old
setmod 644 "${WORLD_STATS_DIR}/"*.json
