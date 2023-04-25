#!/bin/bash

# Directories
export SERVER_ROOT_DIR="/srv/papermc"
export SERVER_PLUGINS_DIR="${SERVER_ROOT_DIR}/plugins"
export SERVER_SCRIPTS_DIR="${SERVER_ROOT_DIR}/scripts"

# World
export WORLD_DIR="${SERVER_ROOT_DIR}/world"
export WORLD_END_DIR="${SERVER_ROOT_DIR}/world_the_end"
export WORLD_NETHER_DIR="${SERVER_ROOT_DIR}/world_nether"

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
export ESSENTIALS_DIR="${SERVER_PLUGINS_DIR}/Essentials"
export TREEASSIST_DIR="${SERVER_PLUGINS_DIR}/TreeAssist"
export VDT_DIR="${SERVER_PLUGINS_DIR}/ViewDistanceTweaks"
export WORLDGUARD_DIR="${SERVER_PLUGINS_DIR}/TreeAssist"

# Plugin configs
export AUTHME_CONFIG_FILE="${AUTHME_DIR}/config.yml"
export CLEANMOTD_CONFIG_FILE="${CLEANMOTD_DIR}/config.yml"
export ESSENTIALS_CONFIG_FILE="${ESSENTIALS_DIR}/config.yml"
export TREEASSIST_CONFIG_FILE="${TREEASSIST_DIR}/config.yml"
export VDT_CONFIG_FILE="${VDT_DIR}/config.yml"
export WORLDGUARD_CONFIG_FILE="${WORLDGUARD_DIR}/config.yml"
