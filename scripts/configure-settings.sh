#!/bin/bash
VIEW_DISTANCE=8
VIEW_DISTANCE_TARGET=8 # The View Distance that the server was tested against when ${PLAYERS_TARGET} players were online
VIEW_DISTANCE_MIN=5
VIEW_DISTANCE_MAX=12

VIEW_DISTANCE_NETHER=5
VIEW_DISTANCE_NETHER_MIN=3
VIEW_DISTANCE_NETHER_MAX=5

VIEW_DISTANCE_END=12
VIEW_DISTANCE_END_MIN=8
VIEW_DISTANCE_END_MAX=16

SIMULATION_DISTANCE=5
SIMULATION_DISTANCE_TARGET=5 # The Simulation Distance that the server was tested against when ${PLAYERS_TARGET} players were online
SIMULATION_DISTANCE_MIN=3 # Never ever go below 3!!!
SIMULATION_DISTANCE_MAX=10

KEEP_SPAWN_LOADED=false

LOCALE="en"
LOCALE_FALLBACK="en"

AUTOSAVE_MINS=20
AUTOSAVE_MINS_NETHER=30
AUTOSAVE_MINS_END=40

source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"
source "${SERVER_SCRIPTS_DIR}/common/specs.sh"

[ -z "${VIEW_DISTANCE}" ] && VIEW_DISTANCE=${SIMULATION_DISTANCE}
[ ${VIEW_DISTANCE} -gt ${VIEW_DISTANCE_MAX} ] && VIEW_DISTANCE=${VIEW_DISTANCE_MAX}
[ ${VIEW_DISTANCE} -lt ${VIEW_DISTANCE_MIN} ] && VIEW_DISTANCE=${VIEW_DISTANCE_MIN}
[ -z "${SIMULATION_DISTANCE}" ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -gt ${SIMULATION_DISTANCE_MAX} ] && SIMULATION_DISTANCE=${SIMULATION_DISTANCE_MAX}
[ ${SIMULATION_DISTANCE} -gt ${VIEW_DISTANCE} ] && SIMULATION_DISTANCE=${VIEW_DISTANCE}
[ ${SIMULATION_DISTANCE} -lt ${SIMULATION_DISTANCE_MIN} ] && SIMULATION_DISTANCE=${SIMULATION_DISTANCE_MIN}
[ -z "${VIEW_DISTANCE}" ] && VIEW_DISTANCE=${SIMULATION_DISTANCE}
[ -z "${SIMULATION_DISTANCE_END}" ] && SIMULATION_DISTANCE_END=${SIMULATION_DISTANCE}
[ -z "${SIMULATION_DISTANCE_NETHER}" ] && SIMULATION_DISTANCE_NETHER=${SIMULATION_DISTANCE}

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

set_config_value "${SERVER_PROPERTIES_FILE}"            "max-players"                                               "${PLAYERS_MAX}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "view-distance"                                             "${VIEW_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "simulation-distance"                                       "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.mob-spawn-range"                    "${MOB_SPAWN_RANGE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.simulation-distance"                "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.view-distance"                      "${VIEW_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.simulation-distance"      "${SIMULATION_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.view-distance"            "${VIEW_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.simulation-distance"   "${SIMULATION_DISTANCE_NETHER}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.view-distance"         "${VIEW_DISTANCE_NETHER}"
set_config_value "${BUKKIT_CONFIG_FILE}"                "spawn-limits.monsters"                                     "${MOB_SPAWN_LIMIT_MONSTER}"

for CREATURE_TYPE in "ambient" "axolotls" "creature" "misc" "monster" "underground_water_creature" "water_ambient" "water_creature"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.hard"    "${MOB_DESPAWN_RANGE_HARD}"
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.soft"    "${MOB_DESPAWN_RANGE_SOFT}"
done
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

if [ -s "${AUTHME_DIR}" ]; then
    set_config_values "${AUTHME_CONFIG_FILE}" \
        "settings.serverName" "${SERVER_NAME}" \
        "settings.sessions.enabled" true \
        "settings.sessions.timeout" 960 \
        "settings.messagesLanguage" "${LOCALE}"
    
    reload_plugin "authme"
fi

if [ -f "${DISCORDSRV_CONFIG_FILE}" ]; then
    set_config_value "${DISCORDSRV_CONFIG_FILE}"    "ServerWatchdogEnabled" false

    reload_plugin "discordsrv"
fi

if [ -f "${ESSENTIALS_CONFIG_FILE}" ]; then
    set_config_value "${ESSENTIALS_CONFIG_FILE}"    "auto-afk"          300
    set_config_value "${ESSENTIALS_CONFIG_FILE}"    "ops-name-color"    "none"
    set_config_value "${ESSENTIALS_CONFIG_FILE}"    "locale"            "${LOCALE}"
    
    reload_plugin "essentials"
fi

if [ -d "${LUCKPERMS_DIR}" ]; then
    set_config_value "${LUCKPERMS_CONFIG_FILE}" "use-server-uuid-cache" true
    set_config_value "${LUCKPERMS_CONFIG_FILE}" "watch-files"           false

    reload_plugin luckperms
fi

if [ -d "${PLEXMAP_DIR}" ]; then
    # Removed in beta:
    # - orld-settings.default.render.background.interval
    # - world-settings.default.render.background.max-chunks-per-interval

    set_config_values "${PLEXMAP_CONFIG_FILE}" \
        "settings.web-directory.path" "/srv/http" \
        "settings.internal-webserver.enabled" false \
        "world-settings.default.enabled" true \
        "world-settings.default.render.background.interval" 450 \
        "world-settings.default.render.background.max-chunks-per-interval" 5 \
        "world-settings.default.markers.spawn.enabled" true \
        "world-settings.default.markers.worldborder.enabled" false \
        "world-settings.default.zoom.max-out" 2 \
        "world-settings.default.zoom.max-in" 2 \
        "world-settings.${WORLD_NAME}.enabled" true \
        "world-settings.${WORLD_NAME}.ui.display-name" "The Overworld" \
        "world-settings.${WORLD_NAME}.zoom.max-out" 3 \
        "world-settings.${WORLD_END_NAME}.enabled" true \
        "world-settings.${WORLD_END_NAME}.render.biome-blend" 0 \
        "world-settings.${WORLD_END_NAME}.render.translucent-fluids" false \
        "world-settings.${WORLD_END_NAME}.ui.display-name" "The End" \
        "world-settings.${WORLD_NETHER_NAME}.enabled" true \
        "world-settings.${WORLD_NETHER_NAME}.render.biome-blend" 0 \
        "world-settings.${WORLD_NETHER_NAME}.render.translucent-fluids" false \
        "world-settings.${WORLD_NETHER_NAME}.ui.display-name" "The Nether" \
        "world-settings.${WORLD_NETHER_NAME}.zoom.max-out" 2

    if [ -f "${PLEXMAP_CONFIG_COLOURS_FILE}" ]; then
        set_config_values "${PLEXMAP_CONFIG_COLOURS_FILE}" \
            "blocks.colors.minecraft:torch"             "#000000" \
            "blocks.colors.minecraft:wall_torch"        "#000000" \
            "blocks.colors.minecraft:soul_torch"        "#000000" \
            "blocks.colors.minecraft:soul_wall_torch"   "#000000"
    fi
    
    if [ -f "${PLEXMAP_CONFIG_ADVANCED_FILE}" ]; then        
        set_config_values "${PLEXMAP_CONFIG_ADVANCED_FILE}" \
            "event-listeners.BlockGrowEvent"            false \
            "event-listeners.BlockSpreadEvent"          false \
            "event-listeners.EntityBlockFormEvent"      false \
            "event-listeners.EntityChangeBlockEvent"    false \
            "event-listeners.EntityExplodeEvent"        false \
            "event-listeners.EntityLevelChangeEvent"    false \
            "blocks.colors.minecraft:torch"             "#000000" \
            "blocks.colors.minecraft:wall_torch"        "#000000" \
            "blocks.colors.minecraft:soul_torch"        "#000000" \
            "blocks.colors.minecraft:soul_wall_torch"   "#000000"
    fi

    PLEXMAP_PAGE_TITLE="${SERVER_NAME} World Map"
    PLEXMAP_PLAYERS_LABEL="<online> Players"
    PLEXMAP_LOCALE="${LOCALE_FALLBACK}"

    if [ "${LOCALE}" == "ro" ]; then
        PLEXMAP_PAGE_TITLE="Harta ${SERVER_NAME}"
        PLEXMAP_PLAYERS_LABEL="<online> Jucători"
    fi
    if [ -f "${PLEXMAP_DIR}/locale/lang-${LOCALE}.yml" ]; then
        PLEXMAP_LOCALE="${LOCALE}"
    fi

    set_config_values "${PLEXMAP_DIR}/locale/lang-${PLEXMAP_LOCALE}.yml" \
        "ui.title"              "${PLEXMAP_PAGE_TITLE}" \
        "ui.players.label"      "${PLEXMAP_PLAYERS_LABEL}" \
        "ui.blockinfo.value"    "${SERVER_NAME}<br />Powered by Raspberry Pi 4" \
        "ui.coords.value"       "<x>, <z>"
    set_config_value "${PLEXMAP_CONFIG_FILE}" "settings.language-file" "lang-${PLEXMAP_LOCALE}.yml"

    if cmp -s "${SERVER_IMAGE_FILE}" "${WEBMAP_ICON_FILE}"; then
        echo "Copying '${SERVER_IMAGE_FILE}' to '${WEBMAP_ICON_FILE}'..."
        sudo cp "${SERVER_IMAGE_FILE}" "${WEBMAP_ICON_FILE}"
    fi
    
    reload_plugin "pl3xmap"
fi

if [ -d "${SKINSRESTORER_DIR}" ]; then
    set_config_value "${SKINSRESTORER_CONFIG_FILE}" "SkinExpiresAfter" 180
fi

if [ -d "${SPARK_DIR}" ]; then
    set_config_value "${SPARK_CONFIG_FILE}" "backgroundProfiler" false
fi

if [ -d "${STACKABLEITEMS_DIR}" ]; then
    set_config_value "${STACKABLEITEMS_CONFIG_FILE}" "update-check.enabled" false

    reload_plugin "stackableitems"
fi

if [ -d "${TREEASSIST_DIR}" ]; then
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "General.Toggle Remember"   false
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "General.Use Permissions"   true

    # Visuals
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Destruction.Falling Blocks"        false # Causes lag on low end devices
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Destruction.Falling Blocks Fancy"  false # Looks a bit odd, may cause lag

    # Telemetry
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "bStats.Active" false

    # Integrations
    [ -f "${WORLDGUARD_CONFIG_FILE}" ] && set_config_value "${TREEASSIST_CONFIG_FILE}" "Plugins.WorldGuard" true

    reload_plugin "treeassist"
fi

if [ -d "${VIAVERSION_CONFIG_FILE}" ]; then
    set_config_value "${VIAVERSION_CONFIG_FILE}" "checkforupdates" false

    reload_plugin "viaversion"
fi

if [ -d "${VIEWDISTANCETWEAKS_DIR}" ]; then
    set_config_values "${VIEWDISTANCETWEAKS_CONFIG_FILE}" \
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
        "world-settings.${WORLD_END_NAME}.simulation-distance.exclude" true \
        "world-settings.${WORLD_END_NAME}.view-distance.exclude" false \
        "world-settings.${WORLD_END_NAME}.view-distance.maximum-view-distance" "${VIEW_DISTANCE_END_MAX}" \
        "world-settings.${WORLD_END_NAME}.view-distance.minimum-view-distance" "${VIEW_DISTANCE_END_MIN}" \
        "world-settings.${WORLD_END_NAME}.chunk-weight" "0.5" \
        "world-settings.${WORLD_NETHER_NAME}.simulation-distance.exclude" true \
        "world-settings.${WORLD_NETHER_NAME}.view-distance.exclude" false \
        "world-settings.${WORLD_NETHER_NAME}.view-distance.maximum-view-distance" "${VIEW_DISTANCE_NETHER_MAX}" \
        "world-settings.${WORLD_NETHER_NAME}.view-distance.minimum-view-distance" "${VIEW_DISTANCE_NETHER_MIN}" \
        "world-settings.${WORLD_NETHER_NAME}.chunk-weight" "0.75"
    reload_plugin "viewdistancetweaks"
fi
