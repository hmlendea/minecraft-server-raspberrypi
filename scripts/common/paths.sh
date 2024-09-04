#!/bin/bash

# Main directories
export SERVER_ROOT_DIR="/srv/papermc"
export SERVER_CACHE_DIR="${SERVER_ROOT_DIR}/cache"
export SERVER_LOGS_DIR="${SERVER_ROOT_DIR}/logs"
export SERVER_PLUGINS_DIR="${SERVER_ROOT_DIR}/plugins"
export SERVER_SCRIPTS_DIR="${SERVER_ROOT_DIR}/scripts"
export SERVER_SCRIPTS_COMMON_DIR="${SERVER_SCRIPTS_DIR}/common"

# Server configs - Server
export SERVER_OPS_FILE="${SERVER_ROOT_DIR}/ops.json"
export SERVER_PROPERTIES_FILE="${SERVER_ROOT_DIR}/server.properties"
export SERVER_USERCACHE_FILE="${SERVER_ROOT_DIR}/usercache.json"
export SERVER_WHITELIST_FILE="${SERVER_ROOT_DIR}/whitelist.json"
export BUKKIT_CONFIG_FILE="${SERVER_ROOT_DIR}/bukkit.yml"
export PAPER_GLOBAL_CONFIG_FILE="${SERVER_ROOT_DIR}/config/paper-global.yml"
export PAPER_WORLD_DEFAULT_CONFIG_FILE="${SERVER_ROOT_DIR}/config/paper-world-defaults.yml"
export PAPER_WORLD_CONFIG_FILE="${WORLD_DIR}/paper-world.yml"
export PAPER_WORLD_END_CONFIG_FILE="${WORLD_END_DIR}/paper-world.yml"
export PAPER_WORLD_NETHER_CONFIG_FILE="${WORLD_NETHER_DIR}/paper-world.yml"
export PUFFERFISH_CONFIG_FILE="${SERVER_ROOT_DIR}/pufferfish.yml"
export PURPUR_CONFIG_FILE="${SERVER_ROOT_DIR}/purpur.yml"
export SPIGOT_CONFIG_FILE="${SERVER_ROOT_DIR}/spigot.yml"

# World
[ -z "${WORLD_NAME}" ] && source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"
export WORLD_DIR="${SERVER_ROOT_DIR}/${WORLD_NAME}"
export WORLD_ADVANCEMENTS_DIR="${WORLD_DIR}/advancements"
export WORLD_PLAYERDATA_DIR="${WORLD_DIR}/playerdata"
export WORLD_STATS_DIR="${WORLD_DIR}/stats"
export WORLD_END_DIR="${SERVER_ROOT_DIR}/${WORLD_END_NAME}"
export WORLD_END_PLAYERDATA_DIR="${WORLD_END_DIR}/playerdata"
export WORLD_NETHER_DIR="${SERVER_ROOT_DIR}/${WORLD_NETHER_NAME}"
export WORLD_NETHER_PLAYERDATA_DIR="${WORLD_NETHER_DIR}/playerdata"

export SERVER_DATAPACKS_DIR="${WORLD_DIR}/datapacks"

# World Webmap
export WEBMAP_DIR="${SERVER_ROOT_DIR}/webmap"
export WEBMAP_SKINS_DIR="${WEBMAP_DIR}/images/skins"
export WEBMAP_SKINS_2D_UUID_DIR="${WEBMAP_SKINS_DIR}/2D"
export WEBMAP_SKINS_2D_USERNAME_DIR="${WEBMAP_SKINS_DIR}/2D-ByUsername"
export WEBMAP_TILES_DIR="${WEBMAP_DIR}/tiles"
export WEBMAP_ICON_FILE="${WEBMAP_DIR}/favicon.ico"
export WEBMAP_INDEX_FILE="${WEBMAP_DIR}/index.html"

# Resources
export PASSWORDS_DICTIONARY_FILE="${SERVER_CACHE_DIR}/passwords.lst"
export PLAYERS_CACHE_FILE="${SERVER_CACHE_DIR}/players.json"
export SERVER_IMAGE_FILE="${SERVER_ROOT_DIR}/server-image.png"
export CURRENT_LOG_FILE="${SERVER_LOGS_DIR}/latest.log"

# Plugin directories
export DISCORDSRV_DIR="${SERVER_PLUGINS_DIR}/DiscordSRV"
export ESSENTIALS_DIR="${SERVER_PLUGINS_DIR}/Essentials"
export ESSENTIALS_USERDATA_DIR="${ESSENTIALS_DIR}/userdata"
export LUCKPERMS_DIR="${SERVER_PLUGINS_DIR}/LuckPerms"
export MINIMOTD_DIR="${SERVER_PLUGINS_DIR}/MiniMOTD"
export PAPERTWEAKS_DIR="${SERVER_PLUGINS_DIR}/PaperTweaks"
export PAPERTWEAKS_MODULES_DIR="${SERVER_PLUGINS_DIR}/PaperTweaks/modules"
export PLEXMAP_DIR="${SERVER_PLUGINS_DIR}/Pl3xMap"
export PLEXMAP_CLAIMS_DIR="${PLEXMAP_DIR}-Claims"
export SKINSRESTORER_DIR="${SERVER_PLUGINS_DIR}/SkinsRestorer"
export SKINSRESTORER_CACHE_DIR="${SKINSRESTORER_DIR}/cache"
export TRADESHOP_DIR="${SERVER_PLUGINS_DIR}/TradeShop"
export TRADESHOP_DATA_DIR="${TRADESHOP_DIR}/Data"
export TRADESHOP_PLAYER_DATA_DIR="${TRADESHOP_DATA_DIR}/Players"
export WORLDGUARD_DIR="${SERVER_PLUGINS_DIR}/WorldGuard"

# Plugin files
export DISCORDSRV_ACCOUNTS_FILE="${DISCORDSRV_DIR}/accounts.aof"
export PAPERTWEAKS_MODULES_FILE="${PAPERTWEAKS_DIR}/modules.yml"
export PLEXMAP_CONFIG_FILE="${PLEXMAP_DIR}/config.yml"
export PLEXMAP_CONFIG_COLOURS_FILE="${PLEXMAP_DIR}/colors.yml"
export PLEXMAP_CLAIMS_WORLDGUARD_CONFIG_FILE="${PLEXMAP_CLAIMS_DIR}/worldguard.yml"
export WORLDGUARD_WORLD_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/regions.yml"
export WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/regions.tmp.yml"
