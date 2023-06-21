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

setown "${SERVER_ROOT_DIR}/"*.jar
setown "${SERVER_ROOT_DIR}/"*.yml
setown "${SERVER_ROOT_DIR}/config"
setown "${SERVER_ROOT_DIR}/${WORLD_NAME}"
setown "${SERVER_ROOT_DIR}/${WORLD_NETHER_NAME}"
setown "${SERVER_ROOT_DIR}/${WORLD_END_NAME}"
setown "${SERVER_PLUGINS_DIR}"
[ -f "/srv/http/pl3xmap.js" ] && setown "/srv/http"

setexe "${SERVER_ROOT_DIR}/"*.jar
setexe "${SERVER_PLUGINS_DIR}/"*.jar
