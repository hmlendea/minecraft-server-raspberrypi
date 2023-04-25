#!/bin/bash
VIEW_DISTANCE=8
VIEW_DISTANCE_TARGET=8 # The View Distancethe server was tested against when ${PLAYERS_TARGET} players were online
VIEW_DISTANCE_MIN=5
VIEW_DISTANCE_MAX=12

VIEW_DISTANCE_NETHER=5
VIEW_DISTANCE_NETHER_MIN=3
VIEW_DISTANCE_NETHER_MAX=5

VIEW_DISTANCE_END=12
VIEW_DISTANCE_END_MIN=8
VIEW_DISTANCE_END_MAX=16

SIMULATION_DISTANCE=5
SIMULATION_DISTANCE_TARGET=5 # The View Distancethe server was tested against when ${PLAYERS_TARGET} players were online
SIMULATION_DISTANCE_MIN=3 # Never ever go below 3!!!
SIMULATION_DISTANCE_MAX=10

PLAYERS_MAX=8
PLAYERS_TARGET=6 # The amount of players the server was tested against

KEEP_SPAWN_LOADED=false

LOCALE="en"

AUTOSAVE_MINS=20
AUTOSAVE_MINS_NETHER=30
AUTOSAVE_MINS_END=40

source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"

[ -z "${VIEW_DISTANCE}" ] && VIEW_DISTANCE=${SIMULATION_DISTANCE}
[ ${VIEW_DISTANCE} -gt ${VIEW_DISTANCE_MAX} ] && VIEW_DISTANCE=${VIEW_DISTANCE_MAX}
[ ${VIEW_DISTANCE} -lt ${VIEW_DISTANCE_MIN} ] && VIEW_DISTANCE=${VIEW_DISTANCE_MIN}
[ -z "${SIMULATION_DISTANCE}" ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -gt ${SIMULATION_DISTANCE_MAX} ] && SIMULATION_DISTANCE=${SIMULATION_DISTANCE_MAX}
[ ${SIMULATION_DISTANCE} -gt ${VIEW_DISTANCE} ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -lt ${SIMULATION_DISTANCE_MIN} ] && SIMULATION_DISTANCE=${SIMULATION_DISTANCE_MIN}
[ -z "${VIEW_DISTANCE}" ] && VIEW_DISTANCE=${SIMULATION_DISTANCE}

SIMULATION_CHUNKS_TARGET=$(( (2 * ${SIMULATION_DISTANCE} + 1) ** 2 * ${PLAYERS_MAX} ))
VIEW_CHUNKS_TARGET=$(( ((2 * ${VIEW_DISTANCE} + 1) ** 2 - (2 * ${SIMULATION_DISTANCE} + 1) ** 2) * PLAYERS_MAX))

MOB_SPAWN_RANGE=$((SIMULATION_DISTANCE-1))
[ ${MOB_SPAWN_RANGE} -lt 3 ] && MOB_SPAWN_RANGE=3
[ ${MOB_SPAWN_RANGE} -gt 6 ] && MOB_SPAWN_RANGE=6

MOB_DESPAWN_RANGE_HARD=$((MOB_SPAWN_RANGE*16))
[ ${MOB_DESPAWN_RANGE_HARD} -lt 32 ] && MOB_DESPAWN_RANGE_HARD=32

MOB_DESPAWN_RANGE_SOFT=$((MOB_SPAWN_RANGE*4))
[ ${MOB_DESPAWN_RANGE_SOFT} -lt 24 ] && MOB_DESPAWN_RANGE_SOFT=24

MOB_SPAWN_LIMIT_MONSTER=$((14*(MOB_SPAWN_RANGE-3)+7))
[ ${MOB_SPAWN_LIMIT_MONSTER} -lt 7 ] && MOB_SPAWN_LIMIT_MONSTER=7

set_config_value "${SERVER_PROPERTIES_FILE}"            "max-players"                                   "${PLAYERS_MAX}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "view-distance"                                 "${VIEW_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "simulation-distance"                           "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.view-distance"          "${VIEW_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.world_nether.view-distance"     "${VIEW_DISTANCE_NETHER}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.world_the_end.view-distance"    "${VIEW_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "simulation-distance"                           "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "mob-spawn-range"                               "${MOB_SPAWN_RANGE}"
set_config_value "${BUKKIT_CONFIG_FILE}"                "monsters"                                      "${MOB_SPAWN_LIMIT_MONSTER}"

set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "hard"                                          "${MOB_DESPAWN_RANGE_HARD}"
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "soft"                                          "${MOB_DESPAWN_RANGE_SOFT}"
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "spawn.keep-spawn-loaded"                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "spawn.keep-spawn-loaded-range"                 "${VIEW_DISTANCE}"

set_config_value "${PAPER_WORLD_CONFIG_FILE}"           "chunks.auto-save-interval"                     $((AUTOSAVE_MINS * 20 * 60))
set_config_value "${PAPER_WORLD_CONFIG_FILE}"           "spawn.keep-spawn-loaded"                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_CONFIG_FILE}"           "spawn.keep-spawn-loaded-range"                 "${VIEW_DISTANCE}"

set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       "chunks.auto-save-interval"                     $((AUTOSAVE_MINS_END * 20 * 60))
set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       "spawn.keep-spawn-loaded"                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       "spawn.keep-spawn-loaded-range"                 "${VIEW_DISTANCE_END}"

set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    "chunks.auto-save-interval"                     $((AUTOSAVE_MINS_NETHER * 20 * 60))
set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    "spawn.keep-spawn-loaded"                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    "spawn.keep-spawn-loaded-range"                 "${VIEW_DISTANCE_NETHER}"

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
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Falling Blocks"        false # Causes lag on low end devices
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Falling Blocks Fancy"  false # Looks a bit odd, may cause lag

    # Telemetry
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "bStats.Active"         false

    # Integrations
    [ -f "${WORLDGUARD_CONFIG_FILE}" ] && set_config_value "${TREEASSIST_CONFIG_FILE}" "Plugins.WorldGuard" true

    reload_plugin "treeassist"
fi

if [ -f "${VDT_CONFIG_FILE}" ]; then
    set_config_values "${VDT_CONFIG_FILE}" \
        "enabled" true \
        "proactive-mode-settings.global-ticking-chunk-count-target" "${SIMULATION_CHUNKS_TARGET}" \
        "proactive-mode-settings.global-non-ticking-chunk-count-taget" "${VIEW_CHUNKS_TARGET}" \
        "world-settings.default.simulation-distance.exclude" true \
        "world-settings.default.simulation-distance.maximum-simulation-distance" "${SIMULATION_DISTANCE_MAX}" \
        "world-settings.default.simulation-distance.minimum-simulation-distance" "${SIMULATION_DISTANCE_MIN}" \
        "world-settings.default.view-distance.exclude" false \
        "world-settings.default.view-distance.maximum-view-distance" "${VIEW_DISTANCE_MAX}" \
        "world-settings.default.view-distance.minimum-view-distance" "${VIEW_DISTANCE_MIN}" \
        "world-settings.default.chunk-weight" "1" \
        "world-settings.world_nether.simulation-distance.exclude" true \
        "world-settings.world_nether.view-distance.exclude" false \
        "world-settings.world_nether.view-distance.maximum-view-distance" "${VIEW_DISTANCE_NETHER_MAX}" \
        "world-settings.world_nether.view-distance.minimum-view-distance" "${VIEW_DISTANCE_NETHER_MIN}" \
        "world-settings.world_nether.chunk-weight" "0.75" \
        "world-settings.world_the_end.simulation-distance.exclude" true \
        "world-settings.world_the_end.view-distance.exclude" false \
        "world-settings.world_the_end.view-distance.maximum-view-distance" "${VIEW_DISTANCE_END_MAX}" \
        "world-settings.world_the_end.view-distance.minimum-view-distance" "${VIEW_DISTANCE_END_MIN}" \
        "world-settings.world_the_end.chunk-weight" "0.5"
    reload_plugin "viewdistancetweaks"
fi
