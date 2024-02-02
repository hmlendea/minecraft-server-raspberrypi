#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

function configure_plugin() {
	local PLUGIN_CMD="${1}" && shift
	local PLUGIN_CONFIG_FILE="${1}" && shift

	[ ! -f "${PLUGIN_CONFIG_FILE}" ] && return

	set_config_values "${PLUGIN_CONFIG_FILE}" "${@}"
	reload_plugin "${PLUGIN_CMD}"
}

WEBMAP_PAGE_TITLE="${SERVER_NAME} World Map"

if [ "${LOCALE}" == "ro" ]; then
    WEBMAP_PAGE_TITLE="Harta ${SERVER_NAME}"
fi

set_config_value "${SERVER_PROPERTIES_FILE}"            "max-players"                                               "${PLAYERS_MAX}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "view-distance"                                             "${VIEW_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "simulation-distance"                                       "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.item-despawn-rate"                  $((DESPAWN_RATE_ITEMS_DEFAULT_MINUTES * 60 * 20))
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.mob-spawn-range"                    "${MOB_SPAWN_RANGE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.simulation-distance"                "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.view-distance"                      "${VIEW_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.simulation-distance"      "${SIMULATION_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.view-distance"            "${VIEW_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.simulation-distance"   "${SIMULATION_DISTANCE_NETHER}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.view-distance"         "${VIEW_DISTANCE_NETHER}"
set_config_value "${BUKKIT_CONFIG_FILE}"                "spawn-limits.monsters"                                     "${MOB_SPAWN_LIMIT_MONSTER}"

set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "chunks.flush-regions-on-save"                  true
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

if [ -d "${AUTHME_DIR}" ]; then
    set_config_values "${AUTHME_CONFIG_FILE}" \
        "settings.restrictions.displayOtherAccounts" false \
        "settings.serverName" "${SERVER_NAME}" \
        "settings.sessions.enabled" true \
        "settings.sessions.timeout" 960 \
        "settings.messagesLanguage" "${LOCALE}" \
        "settings.restrictions.teleportUnAuthedToSpawn" false

    [ -d "${ESSENTIALS_DIR}" ] && set_config_values "${AUTHME_CONFIG_FILE}" "Hooks.useEssentialsMotd" true
    
    reload_plugin "authme"
fi

configure_plugin "discordsrv" "${DISCORDSRV_CONFIG_FILE}" \
    "ServerWatchdogEnabled" false \
    "UpdateCheckDisabled"   true

if [ -f "${DYNMAP_CONFIG_FILE}" ]; then
    set_config_value "${DYNMAP_CONFIG_FILE}" "max-sessions"                 5
    set_config_value "${DYNMAP_CONFIG_FILE}" "disable-webserver"            true
    set_config_value "${DYNMAP_CONFIG_FILE}" "webserver-port"               25550
    set_config_value "${DYNMAP_CONFIG_FILE}" "webpath"                      "${WEBMAP_DIR}"
    set_config_value "${DYNMAP_CONFIG_FILE}" "tilespath"                    "${WEBMAP_TILES_DIR}"
    set_config_value "${DYNMAP_CONFIG_FILE}" "webpage-title"                "${WEBMAP_PAGE_TITLE}"

    set_config_value "${DYNMAP_CONFIG_FILE}" "allowchat"                    false
    set_config_value "${DYNMAP_CONFIG_FILE}" "allowwebchat"                 false

    # Optimisations
    set_config_value "${DYNMAP_CONFIG_FILE}" "enabletilehash"               true
    set_config_value "${DYNMAP_CONFIG_FILE}" "tiles-rendered-at-once"       1
    set_config_value "${DYNMAP_CONFIG_FILE}" "tileupdatedelay"              60
    set_config_value "${DYNMAP_CONFIG_FILE}" "timesliceinterval"            0.5
    set_config_value "${DYNMAP_CONFIG_FILE}" "maxchunkspertick"             90
    set_config_value "${DYNMAP_CONFIG_FILE}" "renderacceleratethreshold"    30
    set_config_value "${DYNMAP_CONFIG_FILE}" "updaterate"                   3000

    set_config_value "${DYNMAP_CONFIG_FILE}" "fullrender-min-tps"           19.5
    set_config_value "${DYNMAP_CONFIG_FILE}" "update-min-tps"               19.0
    set_config_value "${DYNMAP_CONFIG_FILE}" "zoomout-min-tps"              18.0

    set_config_value "${DYNMAP_CONFIG_FILE}" "fullrenderplayerlimit"        2
    set_config_value "${DYNMAP_CONFIG_FILE}" "updateplayerlimit"            3

    #
    set_config_value "${DYNMAP_CONFIG_FILE}" "smooth-lighting"              true
    set_config_value "${DYNMAP_CONFIG_FILE}" "image-format"                 "png"
    set_config_value "${DYNMAP_CONFIG_FILE}" "use-generated-textures"       false
    set_config_value "${DYNMAP_CONFIG_FILE}" "correct-water-lighting"       false
    set_config_value "${DYNMAP_CONFIG_FILE}" "transparent-leaves"           true # Might affect performance tho
    set_config_value "${DYNMAP_CONFIG_FILE}" "ctm-support"                  false
    set_config_value "${DYNMAP_CONFIG_FILE}" "skinsrestorer-integration"    true
    set_config_value "${DYNMAP_CONFIG_FILE}" "defaultzoom"                  6
fi

configure_plugin "essentials" "${ESSENTIALS_CONFIG_FILE}" \
    "auto-afk"                  300 \
    "ops-name-color"            "none" \
    "locale"                    "${LOCALE}" \
    "per-warp-permissions"      true \
    "world-change-fly-reset"    false \
    "world-change-speed-reset"  false

configure_plugin "gsit" "${GSIT_CONFIG_FILE}" \
    "Options.check-for-update" false

configure_plugin "invsee" "${INVSEE_CONFIG_FILE}" \
    "enable-unknown-player-support" false

configure_plugin "luckperms" "${LUCKPERMS_CONFIG_FILE}" \
    "use-server-uuid-cache" true \
    "watch-files" false

if [ -d "${PLEXMAP_DIR}" ]; then
    set_config_values "${PLEXMAP_CONFIG_FILE}" \
        "settings.web-directory.path" "${WEBMAP_DIR}" \
        "settings.internal-webserver.enabled" false \
        "settings.performance.render-threads" 1 \
        "settings.performance.gc.when-finished" true \
        "settings.performance.gc.when-running" true \
        "world-settings.default.enabled" true \
        "world-settings.default.zoom.max-in" 2 \
        "world-settings.default.zoom.max-out" 2 \
        "world-settings.${WORLD_NAME}.enabled" true \
        "world-settings.${WORLD_NAME}.render.renderers.basic" "overworld_basic" \
        "world-settings.${WORLD_NAME}.render.renderers.biomes" "overworld_biomes" \
        "world-settings.${WORLD_NAME}.render.renderers.night" "" \
        "world-settings.${WORLD_NAME}.render.renderers.inhabited" "" \
        "world-settings.${WORLD_NAME}.render.renderers.flowermap" "" \
        "world-settings.${WORLD_NAME}.ui.display-name" "The Overworld" \
        "world-settings.${WORLD_NAME}.zoom.max-out" 3 \
        "world-settings.${WORLD_END_NAME}.enabled" true \
        "world-settings.${WORLD_END_NAME}.render.biome-blend" 0 \
        "world-settings.${WORLD_END_NAME}.render.renderers.basic" "the_end_basic" \
        "world-settings.${WORLD_END_NAME}.render.renderers.biomes" "" \
        "world-settings.${WORLD_END_NAME}.render.renderers.night" "" \
        "world-settings.${WORLD_END_NAME}.render.renderers.inhabited" "" \
        "world-settings.${WORLD_END_NAME}.render.renderers.flowermap" "" \
        "world-settings.${WORLD_END_NAME}.render.translucent-fluids" false \
        "world-settings.${WORLD_END_NAME}.ui.display-name" "The End" \
        "world-settings.${WORLD_END_NAME}.zoom.max-in" 1 \
        "world-settings.${WORLD_END_NAME}.zoom.max-out" 2 \
        "world-settings.${WORLD_NETHER_NAME}.enabled" true \
        "world-settings.${WORLD_NETHER_NAME}.render.biome-blend" 0 \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.basic" "nether_basic" \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.biomes" "" \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.night" "" \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.inhabited" "" \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.flowermap" "" \
        "world-settings.${WORLD_NETHER_NAME}.render.translucent-fluids" false \
        "world-settings.${WORLD_NETHER_NAME}.ui.display-name" "The Nether" \
        "world-settings.${WORLD_NETHER_NAME}.zoom.max-out" 0

    PLEXMAP_PLAYERS_LABEL="<online> Players"
    PLEXMAP_LOCALE="${LOCALE_FALLBACK}"

    if [ "${LOCALE}" == "ro" ]; then
        PLEXMAP_PLAYERS_LABEL="<online> Jucători"
    fi
    if [ -f "${PLEXMAP_DIR}/locale/lang-${LOCALE}.yml" ]; then
        PLEXMAP_LOCALE="${LOCALE}"
    fi

    set_config_values "${PLEXMAP_DIR}/locale/lang-${PLEXMAP_LOCALE}.yml" \
        "ui.title"              "${WEBMAP_PAGE_TITLE}" \
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

configure_plugin "pl3xmap" "${PLEXMAP_CONFIG_COLOURS_FILE}" \
    "blocks.colors.minecraft:torch"             "#000000" \
    "blocks.colors.minecraft:wall_torch"        "#000000" \
    "blocks.colors.minecraft:soul_torch"        "#000000" \
    "blocks.colors.minecraft:soul_wall_torch"   "#000000"
configure_plugin "pl3xmap" "${PLEXMAP_DIR}/layers/spawn.yml" \
    "settings.enabled" true \
    "settings.layer.default-hidden" true
configure_plugin "pl3xmap" "${PLEXMAP_DIR}/layers/world-border.yml" \
    "settings.enabled" false \
    "settings.layer.default-hidden" true

configure_plugin "pl3xmap" "${PLEXMAP_CLAIMS_WORLDGUARD_CONFIG_FILE}" \
    "settings.claim.popup.flags" "Protected Region" \
    "settings.layer.default-hidden" true \
    "settings.layer.label" "Regions" \
    "world-settings.default.map.zoom.max" 2 \
    "world-settings.default.map.zoom.max-out" 1 \

configure_plugin "skinsrestorer" "${SKINSRESTORER_CONFIG_FILE}" \
    "SkinExpiresAfter" 180

configure_plugin "spark" "${SPARK_CONFIG_FILE}" \
    "backgroundProfiler" false

configure_plugin "stackableitems" "${STACKABLEITEMS_CONFIG_FILE}" \
    "update-check.enabled" false

# TODO: check-updates to false once it can be updated via script
configure_plugin "tradeshop" "${TRADESHOP_CONFIG_FILE}" \
    "system-options.allow-metrics" false \
    "system-options.check-updates" true \
    "system-options.unlimited-admin" true \
    "global-options.allowed-shops" '["BARREL","CHEST","TRAPPED_CHEST","SHULKER"]' \
    "global-options.allow-sign-break" true \
    "global-options.allow-chest-break" true

if [ -d "${TREEASSIST_DIR}" ]; then
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "General.Toggle Remember"   false
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "General.Use Permissions"   true

    # Visuals
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Destruction.Falling Blocks"        true
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "Destruction.Falling Blocks Fancy"  false # Looks a bit odd, may cause lag

    # Telemetry
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "bStats.Active" false
    set_config_value "${TREEASSIST_CONFIG_FILE}"    "bStats.Full"   false

    # Integrations
    [ -f "${WORLDGUARD_CONFIG_FILE}" ] && set_config_value "${TREEASSIST_CONFIG_FILE}" "Plugins.WorldGuard" true

    reload_plugin "treeassist"
fi

configure_plugin "viaversion" "${VIAVERSION_CONFIG_FILE}" \
    "checkforupdates" false
    
configure_plugin "viewdistancetweaks" "${VIEWDISTANCETWEAKS_CONFIG_FILE}" \
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

configure_plugin "wanderingtrades" "${WANDERINGTRADES_CONFIG_FILE}" \
	"updateChecker" false
#	"language" "${LOCALE_FULL}" \

configure_plugin "worldedit" "${WORLDEDIT_CONFIG_FILE}" \
    "enabled-components.update-notifications" false \
    "max-memory-percent" 85 \
    "queue.parallel-threads" ${CPU_THREADS}

# Mob despawn ranges
for CREATURE_TYPE in "axolotls" "creature" "misc" "monster"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.hard"    "${MOB_DESPAWN_RANGE_HARD}"
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.soft"    "${MOB_DESPAWN_RANGE_SOFT}"
done
for CREATURE_TYPE in "ambient" "underground_water_creature" "water_ambient" "water_creature"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.hard"    "${MOB_DESPAWN_RANGE_CLOSE_HARD}"
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.soft"    "${MOB_DESPAWN_RANGE_SOFT}"
done

# Item despawn rates
for MATERIAL in "diamond" "netherite"; do
    for ITEM in "axe" "boots" "chestplate" "helmet" "hoe" "leggings" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" $((DESPAWN_RATE_ITEMS_RARE_HOURS * 60 * 60 * 20))
    done
done
for ITEM in \
    "coal" "coal_block" "coal_ore" "deepslate_coal_ore" "copper_ingot" "raw_copper" "copper_block" "copper_ore" "deepslate_copper_ore" \
    "diamond" "diamond_block" "diamond_ore" "deepslate_diamond_ore" "emerald" "emerald_block" "emerald_ore" "deepslate_emerald_ore" \
    "iron_ingot" "raw_iron" "iron_ore" "deepslate_iron_ore" "redstone" "redstone_block" "redstone_ore" "deepslate_redstone_ore" \
    "quartz" "quartz_ore" \
    "ancient_debris" "netherite_block" "netherite_ingot" "netherite_scrap" \
    "beacon" "elytra" "nether_star" "shield" "spawner" "totem_of_undying" "wither_skeleton_skull"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" $((DESPAWN_RATE_ITEMS_RARE_HOURS * 60 * 60 * 20))
done
for ITEM in "bamboo" "cactus" "kelp" "melon_slice" "pumpkin"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" $((DESPAWN_RATE_ITEMS_MEDIUM_MINUTES * 60 * 20))
done
for ITEM in \
    "acacia_leaves" "azalea_leaves" "birch_leaves" "cherry_leaves" "dark_oak_leaves" "jungle_leaves" "nether_wart_block" "mangrove_leaves" "oak_leaves" "spruce_leaves" "warped_wart_block" \
    "ender_pearl" "netherrack"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" $((DESPAWN_RATE_ITEMS_FAST_MINUTES * 60 * 20))
done
for MATERIAL in "golden" "iron"; do
    for ITEM in "axe" "boots" "chestplate" "helmet" "hoe" "leggings" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" $((DESPAWN_RATE_ITEMS_FAST_MINUTES * 60 * 20))
    done
done
for ITEM in "arrow" "bone" "rotten_flesh" "spider_eye" "string" "wheat_seeds"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" $((DESPAWN_RATE_ITEMS_INSTANT_SECONDS * 20))
done
for ITEM in "boots" "chestplate" "helmet" "leggings"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.leather_${ITEM}" $((DESPAWN_RATE_ITEMS_INSTANT_SECONDS * 20))
done
for MATERIAL in "wooden" "stone"; do
    for ITEM in "axe" "hoe" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" $((DESPAWN_RATE_ITEMS_INSTANT_SECONDS * 20))
    done
done

set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "environment.treasure-maps.enabled"    false # They cause too much lag eventually
