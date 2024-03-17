#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"

ensure_plugin_is_installed "Dynmap"

SKINS_BYNAME_DIR="${WEBMAP_DIR}/tiles/faces/32x32"
SKINS_BYUUID_DIR="${WEBMAP_DIR}/tiles/faces/uuid"

[ ! -d "${SKINS_BYUUID_DIR}" ] && mkdir -p "${SKINS_BYUUID_DIR}"

for FILE_PATH in "${SKINS_BYNAME_DIR}"/*; do
    FILE_NAME=$(basename -- "${FILE_PATH}")
    PLAYER_NAME="${FILE_NAME%.*}"
    PLAYER_UUID="$(get_player_uuid ${PLAYER_NAME})"

    if [ ! -e "${SKINS_BYUUID_DIR}/${PLAYER_UUID}.png" ]; then
        echo "Linking skin for ${PLAYER_NAME} (${PLAYER_UUID})..."
        ln -s "${SKINS_BYNAME_DIR}/${PLAYER_NAME}.png" "${SKINS_BYUUID_DIR}/${PLAYER_UUID}.png"
    fi
done
