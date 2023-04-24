#!/bin/bash
VIEW_DISTANCE=8
VIEW_DISTANCE_NETHER=5
VIEW_DISTANCE_END=12
SIMULATION_DISTANCE=5
LOCALE="en"

source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"

[ -z "${SIMULATION_DISTANCE}" ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -gt ${VIEW_DISTANCE} ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -lt 3 ] && SIMULATION_DISTANCE=3
[ -z "${VIEW_DISTANCE}" ] && VIEW_DISTANCE=${SIMULATION_DISTANCE}

MOB_SPAWN_RANGE=$((SIMULATION_DISTANCE-1))
[ ${MOB_SPAWN_RANGE} -lt 3 ] && MOB_SPAWN_RANGE=3
[ ${MOB_SPAWN_RANGE} -gt 6 ] && MOB_SPAWN_RANGE=6

MOB_DESPAWN_RANGE_HARD=$((MOB_SPAWN_RANGE*16))
[ ${MOB_DESPAWN_RANGE_HARD} -lt 32 ] && MOB_DESPAWN_RANGE_HARD=32

MOB_DESPAWN_RANGE_SOFT=$((MOB_SPAWN_RANGE*4))
[ ${MOB_DESPAWN_RANGE_SOFT} -lt 24 ] && MOB_DESPAWN_RANGE_SOFT=24

MOB_SPAWN_LIMIT_MONSTER=$((14*(MOB_SPAWN_RANGE-3)+7))
[ ${MOB_SPAWN_LIMIT_MONSTER} -lt 7 ] && MOB_SPAWN_LIMIT_MONSTER=7

set_config_value "${SERVER_PROPERTIES_FILE}"    "view-distance"                                 "${VIEW_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"    "simulation-distance"                           "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"        "world-settings.default.view-distance"          "${VIEW_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"        "world-settings.world_nether.view-distance"     "${VIEW_DISTANCE_NETHER}"
set_config_value "${SPIGOT_CONFIG_FILE}"        "world-settings.world_the_end.view-distance"    "${VIEW_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"        "simulation-distance"                           "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"        "mob-spawn-range"                               "${MOB_SPAWN_RANGE}"
set_config_value "${PAPER_WORLD_CONFIG_FILE}"   "hard"                                          "${MOB_DESPAWN_RANGE_HARD}"
set_config_value "${PAPER_WORLD_CONFIG_FILE}"   "soft"                                          "${MOB_DESPAWN_RANGE_SOFT}"
set_config_value "${BUKKIT_CONFIG_FILE}"        "monsters"                                      "${MOB_SPAWN_LIMIT_MONSTER}"

if [ -f "${AUTHME_CONFIG_FILE}" ]; then
    set_config_value "${AUTHME_CONFIG_FILE}"    "messagesLanguage"  "${LOCALE}"
    reload_plugin "authme"
fi

if [ -f "${ESSENTIALS_CONFIG_FILE}" ]; then
    set_config_value "${ESSENTIALS_CONFIG_FILE}"    "ops-name-color"    "\"none\""
    set_config_value "${ESSENTIALS_CONFIG_FILE}"    "locale"            "${LOCALE}"
    reload_plugin "essentials"
fi

if [ -f "${TREEASSIST_CONFIG_FILE}" ]; then
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Toggle Remember"       false
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Use Permissions"       true

    # Visuals
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Falling Blocks"        true
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Falling Blocks Fancy"  false # Looks a bit odd, may cause lag

    # Telemetry
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "bStats.Active"         false

    # Integrations
    [ -f "${WORLDGUARD_CONFIG_FILE}" ] && set_config_value "${TREEASSIST_CONFIG_FILE}" "Plugins.WorldGuard" true

    reload_plugin "treeassist"
fi
