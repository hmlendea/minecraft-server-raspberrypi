#!/bin/bash

# Directories
export SERVER_ROOT_DIR="/srv/papermc"
export SERVER_PLUGINS_DIR="${SERVER_ROOT_DIR}/plugins"
export SERVER_SCRIPTS_DIR="${SERVER_ROOT_DIR}/scripts"

# World
export WORLD_NAME="world"
export WORLD_END_NAME="${WORLD_NAME}_the_end"
export WORLD_NETHER_NAME="${WORLD_NAME}_nether"
export WORLD_DIR="${SERVER_ROOT_DIR}/${WORLD_NAME}"
export WORLD_END_DIR="${SERVER_ROOT_DIR}/${WORLD_END_NAME}"
export WORLD_NETHER_DIR="${SERVER_ROOT_DIR}/${WORLD_NETHER_NAME}"

# Server configs
export SERVER_PROPERTIES_FILE="${SERVER_ROOT_DIR}/server.properties"
export BUKKIT_CONFIG_FILE="${SERVER_ROOT_DIR}/bukkit.yml"
export SPIGOT_CONFIG_FILE="${SERVER_ROOT_DIR}/spigot.yml"
export PAPER_WORLD_DEFAULT_CONFIG_FILE="${SERVER_ROOT_DIR}/config/paper-world-defaults.yml"
export PAPER_WORLD_CONFIG_FILE="${WORLD_DIR}/paper-world.yml"
export PAPER_WORLD_END_CONFIG_FILE="${WORLD_END_DIR}/paper-world.yml"
export PAPER_WORLD_NETHER_CONFIG_FILE="${WORLD_NETHER_DIR}/paper-world.yml"

# Plugin directories
export AUTHME_DIR="${SERVER_PLUGINS_DIR}/AuthMe"
export CLEANMOTD_DIR="${SERVER_PLUGINS_DIR}/CleanMOTD"
export DISCORDSRV_DIR="${SERVER_PLUGINS_DIR}/DiscordSRV"
export ESSENTIALS_DIR="${SERVER_PLUGINS_DIR}/Essentials"
export PLEXMAP_DIR="${SERVER_PLUGINS_DIR}/Pl3xMap"
export TREEASSIST_DIR="${SERVER_PLUGINS_DIR}/TreeAssist"
export VDT_DIR="${SERVER_PLUGINS_DIR}/ViewDistanceTweaks"
export WORLDGUARD_DIR="${SERVER_PLUGINS_DIR}/WorldGuard"

# Plugin configs
export AUTHME_CONFIG_FILE="${AUTHME_DIR}/config.yml"
export CLEANMOTD_CONFIG_FILE="${CLEANMOTD_DIR}/config.yml"
export DISCORDSRV_CONFIG_FILE="${DISCORDSRV_DIR}/config.yml"
export ESSENTIALS_CONFIG_FILE="${ESSENTIALS_DIR}/config.yml"
export PLEXMAP_CONFIG_FILE="${PLEXMAP_DIR}/config.yml"
export PLEXMAP_CONFIG_ADVANCED_FILE="${PLEXMAP_DIR}/advanced.yml"
export TREEASSIST_CONFIG_FILE="${TREEASSIST_DIR}/config.yml"
export VDT_CONFIG_FILE="${VDT_DIR}/config.yml"
export WORLDGUARD_CONFIG_FILE="${WORLDGUARD_DIR}/config.yml"
export WORLDGUARD_WORLD_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/regions.yml"
export WORLDGUARD_WORLD_END_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_END_NAME}/regions.yml"
export WORLDGUARD_WORLD_NETHER_REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NETHER_NAME}/regions.yml"
