#!/bin/bash

# Directories
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
# Server configs - Bukkit
export BUKKIT_CONFIG_FILE="${SERVER_ROOT_DIR}/bukkit.yml"
# Server configs - Spigot
export SPIGOT_CONFIG_FILE="${SERVER_ROOT_DIR}/spigot.yml"
# Server configs - Paper
export PAPER_WORLD_DEFAULT_CONFIG_FILE="${SERVER_ROOT_DIR}/config/paper-world-defaults.yml"
export PAPER_WORLD_CONFIG_FILE="${WORLD_DIR}/paper-world.yml"
export PAPER_WORLD_END_CONFIG_FILE="${WORLD_END_DIR}/paper-world.yml"
export PAPER_WORLD_NETHER_CONFIG_FILE="${WORLD_NETHER_DIR}/paper-world.yml"

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

# World Webmap
export WEBMAP_DIR="${SERVER_ROOT_DIR}/webmap"
export WEBMAP_SKINS_DIR="${WEBMAP_DIR}/images/skins"
export WEBMAP_SKINS_2D_UUID_DIR="${WEBMAP_SKINS_DIR}/2D"
export WEBMAP_SKINS_2D_USERNAME_DIR="${WEBMAP_SKINS_DIR}/2D-ByUsername"
export WEBMAP_ICON_FILE="${WEBMAP_DIR}/favicon.ico"
export WEBMAP_INDEX_FILE="${WEBMAP_DIR}/index.html"

# Resources
export PASSWORDS_DICTIONARY_FILE="${SERVER_CACHE_DIR}/passwords.lst"
export PLAYERS_CACHE_FILE="${SERVER_CACHE_DIR}/players.json"
export SERVER_IMAGE_FILE="${SERVER_ROOT_DIR}/server-image.png"
export CURRENT_LOG_FILE="${SERVER_LOGS_DIR}/latest.log"

# Plugin directories
export AUTHME_DIR="${SERVER_PLUGINS_DIR}/AuthMe"
export CLEANMOTD_DIR="${SERVER_PLUGINS_DIR}/CleanMOTD"
export DISCORDSRV_DIR="${SERVER_PLUGINS_DIR}/DiscordSRV"
export ESSENTIALS_DIR="${SERVER_PLUGINS_DIR}/Essentials"
export ESSENTIALS_USERDATA_DIR="${ESSENTIALS_DIR}/userdata"
export GSIT_DIR="${SERVER_PLUGINS_DIR}/GSit"
export INVSEE_DIR="${SERVER_PLUGINS_DIR}/InvSeePlusPlus"
export LUCKPERMS_DIR="${SERVER_PLUGINS_DIR}/LuckPerms"
export MINIMOTD_DIR="${SERVER_PLUGINS_DIR}/MiniMOTD"
export PLEXMAP_DIR="${SERVER_PLUGINS_DIR}/Pl3xMap"
export PLEXMAP_CLAIMS_DIR="${PLEXMAP_DIR}-Claims"
export SKINSRESTORER_DIR="${SERVER_PLUGINS_DIR}/SkinsRestorer"
export SPARK_DIR="${SERVER_PLUGINS_DIR}/spark"
export STACKABLEITEMS_DIR="${SERVER_PLUGINS_DIR}/StackableItems"
export TREEASSIST_DIR="${SERVER_PLUGINS_DIR}/TreeAssist"
export VIAVERSION_DIR="${SERVER_PLUGINS_DIR}/ViaVersion"
export VIEWDISTANCETWEAKS_DIR="${SERVER_PLUGINS_DIR}/ViewDistanceTweaks"
export WANDERINGTRADES_DIR="${SERVER_PLUGINS_DIR}/WanderingTrades"
export WORLDEDIT_DIR="${SERVER_PLUGINS_DIR}/FastAsyncWorldEdit"
export WORLDGUARD_DIR="${SERVER_PLUGINS_DIR}/WorldGuard"

# Plugin files
export AUTHME_CONFIG_FILE="${AUTHME_DIR}/config.yml"
export AUTHME_DATABASE_FILE="${AUTHME_DIR}/authme.db"
export AUTHME_LOG_FILE="${AUTHME_DIR}/authme.log"
export CLEANMOTD_CONFIG_FILE="${CLEANMOTD_DIR}/config.yml"
export DISCORDSRV_CONFIG_FILE="${DISCORDSRV_DIR}/config.yml"
export ESSENTIALS_CONFIG_FILE="${ESSENTIALS_DIR}/config.yml"
export GSIT_CONFIG_FILE="${GSIT_DIR}/config.yml"
export INVSEE_CONFIG_FILE="${INVSEE_DIR}/config.yml"
export LUCKPERMS_CONFIG_FILE="${LUCKPERMS_DIR}/config.yml"
export PLEXMAP_CONFIG_FILE="${PLEXMAP_DIR}/config.yml"
export PLEXMAP_CONFIG_COLOURS_FILE="${PLEXMAP_DIR}/colors.yml"
export PLEXMAP_CLAIMS_WORLDGUARD_CONFIG_FILE="${PLEXMAP_CLAIMS_DIR}/worldguard.yml"
export SKINSRESTORER_CONFIG_FILE="${SKINSRESTORER_DIR}/config.yml"
export SPARK_CONFIG_FILE="${SPARK_DIR}/config.json"
export STACKABLEITEMS_CONFIG_FILE="${STACKABLEITEMS_DIR}/options.yml"
export TREEASSIST_CONFIG_FILE="${TREEASSIST_DIR}/config.yml"
export VIAVERSION_CONFIG_FILE="${VIAVERSION_DIR}/config.yml"
export VIEWDISTANCETWEAKS_CONFIG_FILE="${VIEWDISTANCETWEAKS_DIR}/config.yml"
export WANDERINGTRADES_CONFIG_FILE="${WANDERINGTRADES_DIR}/config.yml"
export WORLDEDIT_CONFIG_FILE="${WORLDEDIT_DIR}/config.yml"
export WORLDGUARD_CONFIG_FILE="${WORLDGUARD_DIR}/config.yml"
export WORLDGUARD_WORLD_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/regions.yml"
export WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/regions.tmp.yml"
export WORLDGUARD_WORLD_END_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_END_NAME}/regions.yml"
export WORLDGUARD_WORLD_NETHER_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NETHER_NAME}/regions.yml"
