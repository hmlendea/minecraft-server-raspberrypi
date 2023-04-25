#!/bin/bash

# Directories
export SERVER_ROOT_DIR="/srv/papermc"
export SERVER_PLUGINS_DIR="${SERVER_ROOT_DIR}/plugins"
export SERVER_SCRIPTS_DIR="${SERVER_ROOT_DIR}/scripts"

# Server configs
export SERVER_PROPERTIES_FILE="${SERVER_ROOT_DIR}/server.properties"
export BUKKIT_CONFIG_FILE="${SERVER_ROOT_DIR}/bukkit.yml"
export SPIGOT_CONFIG_FILE="${SERVER_ROOT_DIR}/spigot.yml"
export PAPER_WORLD_CONFIG_FILE="${SERVER_ROOT_DIR}/config/paper-world-defaults.yml"

# Plugin configs
export AUTHME_CONFIG_FILE="${SERVER_PLUGINS_DIR}/AuthMe/config.yml"
export CLEANMOTD_CONFIG_FILE="${SERVER_PLUGINS_DIR}/CleanMOTD/config.yml"
export ESSENTIALS_CONFIG_FILE="${SERVER_PLUGINS_DIR}/Essentials/config.yml"
export TREEASSIST_CONFIG_FILE="${SERVER_PLUGINS_DIR}/TreeAssist/config.yml"
export VDT_CONFIG_FILE="${SERVER_PLUGINS_DIR}/ViewDistanceTweaks/config.yml"
export WORLDGUARD_CONFIG_FILE="${SERVER_PLUGINS_DIR}/TreeAssist/config.yml"
