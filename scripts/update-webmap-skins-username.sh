#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"

if [ ! -d "${WORLD_WEBMAP_SKINS_2D_UUID_DIR}" ]; then
    echo "ERROR: The '${WORLD_WEBMAP_SKINS_2D_UUID_DIR}' directory does not exist!"
    exit 1
fi

if [ ! -d "${WORLD_WEBMAP_SKINS_2D_USERNAME_DIR}" ]; then
    echo "Creating the '${WORLD_WEBMAP_SKINS_2D_USERNAME_DIR}' directory..."
    mkdir "${WORLD_WEBMAP_SKINS_2D_USERNAME_DIR}"
    chown papermc:papermc "${WORLD_WEBMAP_SKINS_2D_USERNAME_DIR}" -R
fi

for SKIN_UUID_FILE in $(ls "${WORLD_WEBMAP_SKINS_2D_UUID_DIR}"); do
    PLAYER_UUID=$(basename "${SKIN_UUID_FILE}")
    PLAYER_UUID="${PLAYER_UUID%.*}"
    PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")

    SKIN_UUID_FILE="${WORLD_WEBMAP_SKINS_2D_UUID_DIR}/${PLAYER_UUID}.png"
    SKIN_USERNAME_FILE="${WORLD_WEBMAP_SKINS_2D_USERNAME_DIR}/${PLAYER_USERNAME}.png"

    echo "Updating ${PLAYER_USERNAME} (${PLAYER_UUID})..."
    [ -f "${SKIN_USERNAME_FILE}" ] && rm "${SKIN_USERNAME_FILE}"
    ln -s "${SKIN_UUID_FILE}" "${SKIN_USERNAME_FILE}"
    chown papermc:papermc "${SKIN_USERNAME_FILE}"
done
