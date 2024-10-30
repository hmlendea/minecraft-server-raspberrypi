#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

OLD_USERNAME="${1}"
NEW_USERNAME="${2}"

if [ -z "${OLD_USERNAME}" ]; then
    echo "The old username cannot be empty!"
    return
elif [ -z "${NEW_USERNAME}" ]; then
    echo "The new username cannot be empty!"
    return
fi

OLD_USERNAME_LOWERCASE=$(echo "${OLD_USERNAME}" | tr '[:upper:]' '[:lower:]')
NEW_USERNAME_LOWERCASE=$(echo "${NEW_USERNAME}" | tr '[:upper:]' '[:lower:]')
    
OLD_UUID=$(get_player_uuid "${OLD_USERNAME}")
NEW_UUID=$(get_player_uuid "${NEW_USERNAME}")

if [ -z "${OLD_UUID}" ]; then
    echo "The old UUID cannot be empty!"
    return
elif [ -z "${NEW_UUID}" ]; then
    echo "The new UUID cannot be empty!"
    return
fi

if [ -f "${ESSENTIALS_USERDATA_DIR}/${NEW_UUID}.yml" ] \
|| [ -f "${SKINSRESTORER_CACHE_DIR}/${NEW_USERNAME}.mojangcache" ] \
|| [ -f "${SKINSRESTORER_DIR}/legacy/players/${NEW_USERNAME_LOWERCASE}.legacyplayer" ] \
|| [ -f "${SKINSRESTORER_DIR}/legacy/skins/${NEW_USERNAME_LOWERCASE}.legacyskin" ] \
|| [ -f "${SKINSRESTORER_DIR}/players/${NEW_UUID}.player" ] \
|| [ -f "${SKINSRESTORER_DIR}/skins/ ${NEW_USERNAME_LOWERCASE}.customskin" ] \
|| [ -f "${TRADESHOP_PLAYER_DATA_DIR}/${NEW_UUID}.json" ] \
|| [ -f "${WORLD_ADVANCEMENTS_DIR}/${NEW_UUID}.json" ] \
|| [ -f "${WORLD_PLAYERDATA_DIR}/${NEW_UUID}.dat" ] \
|| [ -f "${WORLD_PLAYERDATA_DIR}/${NEW_UUID}.dat_old" ] \
|| [ -f "${WORLD_STATS_DIR}/${NEW_UUID}.json" ]; then
    echo "The new UUID/Username already exists"
    return
fi

echo "Changing ${OLD_USERNAME} (${OLD_UUID}) to ${NEW_USERNAME} (${NEW_UUID})..."

sudo sed -i 's/'"${OLD_UUID}"'/'"${NEW_UUID}"'/g' "${DISCORDSRV_ACCOUNTS_FILE}"
reload_plugin "discordsrv"

move_file "${ESSENTIALS_USERDATA_DIR}/${OLD_UUID}.yml" "${ESSENTIALS_USERDATA_DIR}/${NEW_UUID}.yml"
reload_plugin "essentials"

move_file "${SKINSRESTORER_CACHE_DIR}/${OLD_USERNAME}.mojangcache" "${SKINSRESTORER_CACHE_DIR}/${NEW_USERNAME}.mojangcache"
move_file "${SKINSRESTORER_DIR}/legacy/players/${OLD_USERNAME_LOWERCASE}.legacyplayer" "${SKINSRESTORER_DIR}/legacy/players/${NEW_USERNAME_LOWERCASE}.legacyplayer"
move_file "${SKINSRESTORER_DIR}/legacy/skins/${OLD_USERNAME_LOWERCASE}.legacyskin" "${SKINSRESTORER_DIR}/legacy/skins/${NEW_USERNAME_LOWERCASE}.legacyskin"
move_file "${SKINSRESTORER_DIR}/players/${OLD_UUID}.player" "${SKINSRESTORER_DIR}/players/${NEW_UUID}.player"
move_file "${SKINSRESTORER_DIR}/skins/ ${OLD_USERNAME_LOWERCASE}.customskin" "${SKINSRESTORER_DIR}/skins/ ${NEW_USERNAME_LOWERCASE}.customskin"
reload_plugin "skinsrestorer"

move_file "${TRADESHOP_PLAYER_DATA_DIR}/${OLD_UUID}.json" "${TRADESHOP_PLAYER_DATA_DIR}/${NEW_UUID}.json"
reload_plugin "tradeshop"

sudo sed -i 's/'"${OLD_UUID}"'/'"${NEW_UUID}"'/g' "${WORLDGUARD_WORLD_REGIONS_FILE}"
reload_plugin "worldguard"

move_file "${WORLD_ADVANCEMENTS_DIR}/${OLD_UUID}.json" "${WORLD_ADVANCEMENTS_DIR}/${NEW_UUID}.json"
move_file "${WORLD_PLAYERDATA_DIR}/${OLD_UUID}.dat" "${WORLD_PLAYERDATA_DIR}/${NEW_UUID}.dat"
move_file "${WORLD_PLAYERDATA_DIR}/${OLD_UUID}.dat_old" "${WORLD_PLAYERDATA_DIR}/${NEW_UUID}.dat_old"
move_file "${WORLD_STATS_DIR}/${OLD_UUID}.json" "${WORLD_PLAYERDATA_DIR}/${NEW_UUID}.json"

sudo sed -i 's/\"'"${OLD_UUID}"'\"/\"'"${NEW_UUID}"'\"/g' "${SERVER_WHITELIST_FILE}"
sudo sed -i 's/\"'"${OLD_USERNAME}"'\"/\"'"${NEW_USERNAME}"'\"/g' "${SERVER_WHITELIST_FILE}"

${SHELL} "${SERVER_SCRIPTS_DIR}/fix-permissions.sh"
