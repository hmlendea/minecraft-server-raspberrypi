#!/bin/bash
# shellcheck disable=SC2046,SC2086
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/messages.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

ensure_su_access

set_config_values "${SERVER_PROPERTIES_FILE}" \
    'accepts-transfers'                                         true \
    'allow-flight'                                              true \
    'difficulty'                                                'hard' \
    'enforce-secure-profile'                                    "${SIMULATION_DISTANCE}" \
    'max-chained-neighbor-updates'                              10000 \
    'max-players'                                               "${PLAYERS_MAX}" \
    'network-compression-threshold'                             512 \
    'online-mode'                                               false \
    'simulation-distance'                                       "${SIMULATION_DISTANCE}" \
    'spawn-protection'                                          0 \
    'sync-chunk-writes'                                         false \
    'view-distance'                                             "${VIEW_DISTANCE}"

set_config_value "${SPIGOT_CONFIG_FILE}"    'settings.save-user-cache-on-stop-only'                                     false
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.entity-activation-range.tick-inactive-villagers'    false
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.item-despawn-rate'                                  "${DESPAWN_RATE_ITEMS_DEFAULT_TICKS}"
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.merge-radius.exp'                                   '5.0'
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.merge-radius.item'                                  '3.5'
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.mob-spawn-range'                                    "${MOB_SPAWN_RANGE}"
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.nerf-spawner-mobs'                                  true
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.simulation-distance'                                "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"    'world-settings.default.view-distance'                                      "${VIEW_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"    "world-settings.${WORLD_END_NAME}.simulation-distance"                      "${SIMULATION_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"    "world-settings.${WORLD_END_NAME}.view-distance"                            "${VIEW_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"    "world-settings.${WORLD_NETHER_NAME}.simulation-distance"                   "${SIMULATION_DISTANCE_NETHER}"
set_config_value "${SPIGOT_CONFIG_FILE}"    "world-settings.${WORLD_NETHER_NAME}.view-distance"                         "${VIEW_DISTANCE_NETHER}"

set_config_value "${BUKKIT_CONFIG_FILE}" 'chunk-gc.period-in-ticks'     300
set_config_value "${BUKKIT_CONFIG_FILE}" 'settings.connection-throttle' "${CONNECTION_THROTTLE}"
set_config_value "${BUKKIT_CONFIG_FILE}" 'settings.query-plugins'       false
set_config_value "${BUKKIT_CONFIG_FILE}" 'spawn-limits.monsters'        "${MOB_SPAWN_LIMIT_MONSTER}"

set_config_values "${PAPER_GLOBAL_CONFIG_FILE}" \
    'block-updates.disable-tripwire-updates'                                        false \
    'chunk-loading-advanced.player-max-concurrent-chunk-generates'                  1 \
    'chunk-loading-basic.player-max-chunk-generate-rate'                            5 \
    'item-validation.book-size.page-max'                                            1024 \
    'misc.max-joins-per-tick'                                                       3 \
    'packet-limiter.overrides.ServerboundCommandSuggestionPacket.action'            'DROP' \
    'packet-limiter.overrides.ServerboundCommandSuggestionPacket.interval'          '1.0' \
    'packet-limiter.overrides.ServerboundCommandSuggestionPacket.max-packet-rate'   '15.0' \
    'timings.server-name'                                                           "${SERVER_NAME}" \
    'unsupported-settings.skip-vanilla-damage-tick-when-shield-blocked'             true

# Note: Setting hopper.disable-move-event=false will break Hopper Minecarts
set_config_values "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" \
    'chunks.delay-chunk-unloads-by'                                     '10s' \
    'chunks.flush-regions-on-save'                                      true \
    'chunks.max-auto-save-chunks-per-tick'                              6 \
    'chunks.prevent-moving-into-unloaded-chunks'                        true \
    'collisions.fix-climbing-bypassing-cramming-rule'                   true \
    'collisions.max-entity-collisions'                                  2 \
    'entities.armor-stands.do-collision-entity-lookups'                 false \
    'entities.armor-stands.tick'                                        false \
    'entities.behavior.disable-chest-cat-detection'                     true \
    'entities.spawning.disable-mob-spawner-spawn-egg-transformation'    true \
    'entities.spawning.per-player-mob-spawns'                           true \
    'entities.spawning.wandering-trader.spawn-chance-max'               125 \
    'entities.spawning.wandering-trader.spawn-day-length'               "${DAY_LENGTH_TICKS}" \
    'entities.spawning.entities.creative-arrow-despawn-rate'            40 \
    'entities.spawning.entities.non-player-arrow-despawn-rate'          40 \
    'environment.generate-flat-bedrock'                                 true \
    'environment.optimize-explosions'                                   true \
    'environment.treasure-maps.enabled'                                 true \
    'environment.treasure-maps.find-already-discovered.loot-tables'     true \
    'environment.treasure-maps.find-already-discovered.villager-trade'  true \
    'hopper.disable-move-event'                                         true \
    'hopper.ignore-occluding-blocks'                                    true \
    'misc.redstone-implementation'                                      'ALTERNATE_CURRENT' \
    'misc.update-pathfinding-on-block-update'                           false \
    'spawn.keep-spawn-loaded'                                           "${KEEP_SPAWN_LOADED}" \
    'spawn.keep-spawn-loaded-range'                                     "${VIEW_DISTANCE}" \
    'tick-rates.container-update'                                       3 \
    'tick-rates.grass-spread'                                           6 \
    'tick-rates.mob-spawner'                                            2

set_config_value "${PAPER_WORLD_CONFIG_FILE}"           'chunks.auto-save-interval'                     $((AUTOSAVE_MINS * 20 * 60))
set_config_value "${PAPER_WORLD_CONFIG_FILE}"           'spawn.keep-spawn-loaded'                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_CONFIG_FILE}"           'spawn.keep-spawn-loaded-range'                 "${VIEW_DISTANCE}"

set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       'chunks.auto-save-interval'                     $((AUTOSAVE_MINS_END * 20 * 60))
set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       'spawn.keep-spawn-loaded'                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       'spawn.keep-spawn-loaded-range'                 "${VIEW_DISTANCE_END}"

set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    'chunks.auto-save-interval'                     $((AUTOSAVE_MINS_NETHER * 20 * 60))
set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    'spawn.keep-spawn-loaded'                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    'spawn.keep-spawn-loaded-range'                 "${VIEW_DISTANCE_NETHER}"

set_config_values "${PUFFERFISH_CONFIG_FILE}" \
    'dab.activation-dist-mod'          7 \
    'dab.enabled'                      true \
    'dab.max-tick-freq'                20 \
    'enable-async-mob-spawning'        true \
    'enable-suffocation-optimization'  true \
    'inactive-goal-selector-throttle'  true \
    'misc.disable-method-profiler'     true \
    'projectile.max-loads-per-tick'    8

set_config_values "${PURPUR_CONFIG_FILE}" \
    'settings.network.max-joins-per-second'                                                        true \
    'settings.server-mod-name'                                                                     "${SERVER_NAME}" \
    'settings.use-alternate-keepalive'                                                             true \
    'world-settings.default.blocks.campfire.lit-when-placed'                                       false \
    'world-settings.default.blocks.chest.open-with-solid-block-on-top'                             true \
    'world-settings.default.blocks.coral.die-outside-water'                                        false \
    'world-settings.default.blocks.farmland.get-moist-from-below'                                  true \
    'world-settings.default.blocks.respawn-anchor.explode'                                         false \
    'world-settings.default.blocks.sponge.absorption.range'                                        8 \
    'world-settings.default.blocks.stonecutter.damage'                                             1.0 \
    'world-settings.default.gameplay-mechanics.armorstand.place-with-arms-visible'                 true \
    'world-settings.default.gameplay-mechanics.daylight-cycle-ticks.daytime'                       "${DAYTIME_LENGTH_TICKS}" \
    'world-settings.default.gameplay-mechanics.daylight-cycle-ticks.nighttime'                     "${NIGHTTIME_LENGTH_TICKS}" \
    'world-settings.default.gameplay-mechanics.disable-oxidation-proximity-penalty'                true \
    'world-settings.default.gameplay-mechanics.mob-spawning.ignore-creative-players'               true \
    'world-settings.default.gameplay-mechanics.persistent-droppable-display-names'                 true \
    'world-settings.default.gameplay-mechanics.persistent-tileentity-display-names-and-lore'       true \
    'world-settings.default.gameplay-mechanics.persistent-tileentity-display-name'                 true \
    'world-settings.default.gameplay-mechanics.persistent-tileentity-lore'                         true \
    'world-settings.default.gameplay-mechanics.player.exp-dropped-on-death.maximum'                100000 \
    'world-settings.default.gameplay-mechanics.player.invulnerable-while-accepting-resource-pack'  true \
    'world-settings.default.gameplay-mechanics.player.shift-right-click-repairs-mending-points'    10 \
    'world-settings.default.gameplay-mechanics.use-better-mending'                                 true \
    'world-settings.default.mobs.dolphin.disable-treasure-searching'                               true \
    'world-settings.default.mobs.piglin.bypass-mob-griefing'                                       true \
    'world-settings.default.mobs.villager.bypass-mob-griefing'                                     true \
    'world-settings.default.mobs.villager.lobotomize.enabled'                                      false \
    'world-settings.default.mobs.villager.lobotomize.wait-until-trade-locked'                      true \
    'world-settings.default.mobs.villager.search-radius.acquire-poi'                               16 \
    'world-settings.default.mobs.villager.search-radius.nearest-bed-sensor'                        16 \
    'world-settings.default.mobs.zombie.aggressive-towards-villager-when-lagging'                  false

configure_plugin 'PurpurExtras' config \
    'settings.anvil-splits-boats' true \
    'settings.anvil-splits-minecarts' true \
    'settings.blocks.shift-right-click-for-invisible-item-frames' true \
    'settings.gameplay-settings.cancel-damage-from-pet-owner' true \
    'settings.items.beehive-lore.enabled' true \
    'settings.leash-snap.enabled' false \
    'settings.lightning-transforms-entities.enabled' true \
    'settings.mobs.snow_golem.drop-pumpkin-when-sheared' true \
    'settings.mobs.sheep.jeb-shear-random-color' true \
    'settings.protect-blocks-with-loot.enabled' true \
    'settings.protect-spawners.enabled' true \
    'settings.unlock-all-recipes-on-join' true

# 'prevent-burrow'=true && 'prevent-burrow.teleport-above-block'=true => broken slime-launchers
configure_plugin 'AnarchyExploitFixes' config \
    'bedrock.fill-in-bedrock.nether-floor.fill-on-chunkload.enable' true \
    'bedrock.fill-in-bedrock.overworld-floor.fill-on-chunkload.enable' true \
    'chat.prevent-scanning-server-plugins.enable' true \
    'chunk-limits.exp-bottle-limit.enable' true \
    'chunk-limits.falling-block-limit.enable' true \
    'combat.portal-god-mode-patch.enable' true \
    'combat.prevent-burrow.enable' false \
    'combat.prevent-burrow.teleport-above-block' false \
    'dupe-preventions.close-entity-inventories-on-chunk-unload' true \
    'dupe-preventions.close-entity-inventories-on-player-disconnect' true \
    'dupe-preventions.prevent-chested-living-entities-in-portals' true \
    'dupe-preventions.prevent-chests-on-living-entities' true \
    'elytra.packet-elytra-fly.patch-packet-elytra-fly' true \
    'elytra.packet-elytra-fly.kick-instead-of-remove-elytra' true \
    'elytra.packet-elytra-fly.notify-player-to-disable-packetfly' true \
    'general.commands.say.enable' false \
    'general.commands.help.enable' false \
    'general.commands.toggleconnectionmsgs.enable' false \
    'lag-preventions.prevent-flooding-machines.enable' true \
    'lag-preventions.prevent-lever-spam.enable' true \
    'lag-preventions.prevent-lever-spam.kick-player' true \
    'misc.auto-bed' false \
    'misc.prevent-scanning-server-plugins' true \
    'patches.anti-book-ban.enable' true \
    'patches.beehive-crash-patch.enable' true \
    'patches.beehive-crash-patch.kick-player' true \
    'patches.inventory-lag.enable' true \
    'patches.inventory-lag.close-open-inventory' true \
    'patches.map-cursor-lag-patch.enable' true \
    'patches.pearl-phase.enable' true \
    'patches.prevent-command-sign.enable' true \
    'patches.prevent-fast-world-teleport-crash.enable' true \
    'patches.prevent-teleport-coordinate-exploit.enable' true \
    'patches.sequence-crash-patch.enable' true \
    'patches.sequence-crash-patch.kick-player' true \
    'patches.sign-lag.enable' true \
    'patches.sign-lag.kick-player' true \
    'patches.tab-complete-crash-patch.enable' true \
    'patches.window-click-crash-patch.enable' true \
    'preventions.portals.prevent-destroying-end-portals.enable' true \
    'preventions.portals.prevent-portal-traps.enable' true \
    'preventions.portals.prevent-projectiles-in-portals' true \
    'preventions.prevent-nether-roof.enable' false \
    'preventions.withers.remove-flying-wither-skulls.on-chunk-load' true \
    'preventions.withers.remove-flying-wither-skulls.on-chunk-unload' true \

#    'settings.restrictions.ProtectInventoryBeforeLogIn' $(is_plugin_installed_bool 'ProtocolLib') \
configure_plugin 'AuthMe' config \
    'Hooks.useEssentialsMotd' $(is_plugin_installed_bool 'EssentialsX') \
    'Security.console.logConsole' false \
    'Security.tempban.enableTempban' true \
    'Security.tempban.maxLoginTries' 9 \
    'Security.tempban.minutesBeforeCounterReset' 300 \
    'Security.tempban.tempbanLength' 240 \
    'settings.delayJoinMessage' false \
    'settings.forceVaultHook' $(is_plugin_installed_bool 'Vault') \
    'settings.restrictions.DenyTabCompleteBeforeLogin' true \
    'settings.restrictions.displayOtherAccounts' false \
    'settings.registration.forceLoginAfterRegister' true \
    'settings.restrictions.kickOnWrongPassword' false \
    'settings.restrictions.ProtectInventoryBeforeLogIn' false \
    'settings.restrictions.timeout' 60 \
    'settings.serverName' "${SERVER_NAME}" \
    'settings.sessions.enabled' true \
    'settings.sessions.timeout' 960 \
    'settings.security.minPasswordLength' 8 \
    'settings.useAsyncTasks' true \
    'settings.useWelcomeMessage' $(is_plugin_not_installed_bool 'EssentialsX')

if ${USE_TELEMETRY}; then
    configure_plugin 'bStats' config \
        'enabled'       true \
        'serverUuid'    ''
else
    configure_plugin 'bStats' config \
        'enabled'       false \
        'serverUuid'    '00000000-0000-0000-0000-000000000000'
fi

configure_plugin 'BestTools' config \
    'besttools-enabled-by-default' true \
    'refill-enabled-by-default' true \
    'hotbar-only' false \
    'use-axe-as-sword' true

configure_plugin 'ChatBubbles' messages \
    'ChatBubble_Life' "$(convert_seconds_to_ticks 15)" \
    'Reload_Success' "$(get_reload_message ChatBubbles)"

if is_plugin_installed 'ChestShop'; then
    configure_plugin 'ChestShop' config \
        'AUTHME_HOOK'                                           "$(is_plugin_installed_bool AuthMe)" \
        'INCLUDE_SETTINGS_IN_METRICS'                           "${USE_TELEMETRY}" \
        'LOG_TO_FILE'                                           true \
        'SHIFT_SELLS_IN_STACKS'                                 true \
        'TURN_OFF_DEFAULT_PROTECTION_WHEN_PROTECTED_EXTERNALLY' true \
        'TURN_OFF_UPDATES'                                      "${SKIP_PLUGIN_UPDATE_CHECKS}" \
        'TURN_OFF_UPDATE_NOTIFIER'                              "${SKIP_PLUGIN_UPDATE_CHECKS}" \
        'TURN_OFF_DEV_UPDATE_NOTIFIER'                          "${SKIP_PLUGIN_UPDATE_CHECKS}"
        'WORLDGUARD_INTEGRATION'                                "$(is_plugin_installed_bool WorldGuard)" \
        'WORLDGUARD_USE_FLAG'                                   "$(is_plugin_installed_bool WorldGuard)" \
        'WORLDGUARD_USE_PROTECTION'                             "$(is_plugin_installed_bool WorldGuard)"

    configure_plugin 'ChestShopNotifier' config \
        'notifications.notify-on-user-join' true \
        'history.max-rows' 10
fi

configure_plugin 'ChestSort' config \
    'allow-gui' false \
    'check-for-updates' "${CHECK_PLUGINS_FOR_UPDATES}" \
    'sorting-enabled-by-default' true \
    'inv-sorting-enabled-by-default' true \
    'show-message-when-using-chest' true \
    'show-message-when-using-chest-and-sorting-is-enabled' true \
    'sort-time' 'both'

configure_plugin 'ClickThrough' config \
    'check-for-updates' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'CoreProtect' config \
    'check-updates' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'DeathMessages' config \
    "Hooks.Discord.Enabled" "$(is_plugin_installed_bool DiscordSRV)" \
    "Hooks.MythicMobs.Enabled" "$(is_plugin_installed_bool MythicMobs)" \
    "Hooks.WorldGuard.Enabled" "$(is_plugin_installed_bool WorldGuard)"

configure_plugin 'DecentHolograms' config \
    'update-checker' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'DeluxeMenus' config \
    'check_updates' "${CHECK_PLUGINS_FOR_UPDATES}" \

if is_plugin_installed 'DiscordSRV'; then
    configure_plugin 'DiscordSRV' config \
        'Experiment_WebhookChatMessageAvatarFromDiscord' true \
        'Experiment_WebhookChatMessageDelivery' true \
        'ServerWatchdogEnabled' false \
        'UpdateCheckDisabled'   "${SKIP_PLUGIN_UPDATE_CHECKS}"

    configure_plugin 'DiscordSRV' messages \
        'MinecraftPlayerAchievementMessage.Webhook.Enable' true \
        'MinecraftPlayerDeathMessage.Enabled' $(is_plugin_not_installed_bool DeathMessages) \
        'MinecraftPlayerDeathMessage.Webhook.Enable' true \
        'MinecraftPlayerFirstJoinMessage.Webhook.Enable' true \
        'MinecraftPlayerJoinMessage.Webhook.Enable' true \
        'MinecraftPlayerLeaveMessage.Webhook.Enable' true

    configure_plugin 'DiscordSRV' synchronization \
        'NicknameSynchronizationEnabled' true

fi

configure_plugin 'DynamicLights' config \
    'default-lock-state' false \
    'update-rate' 2

configure_plugin 'Dynmap' config \
    'max-sessions'                 5 \
    'disable-webserver'            true \
    'webserver-port'               25550 \
    'webpath'                      "${WEBMAP_DIR}" \
    'tilespath'                    "${WEBMAP_TILES_DIR}" \
    \
    'allowchat'                    false \
    'allowwebchat'                 false \
    \
    "enabletilehash"               true \
    "tiles-rendered-at-once"       1 \
    "tileupdatedelay"              60 \
    "timesliceinterval"            0.5 \
    "maxchunkspertick"             90 \
    "renderacceleratethreshold"    30 \
    'updaterate'                   3000 \
    \
    'fullrender-min-tps'           19.5 \
    'update-min-tps'               19.0 \
    'zoomout-min-tps'              18.0 \
    \
    'fullrenderplayerlimit'        3 \
    'updateplayerlimit'            4 \
    \
    "smooth-lighting"              true \
    "image-format"                 'png' \
    "use-generated-textures"       false \
    "correct-water-lighting"       false \
    "transparent-leaves"           true \
    "ctm-support"                  false \
    "skinsrestorer-integration"    $(is_plugin_installed_bool 'SkinsRestorer') \
    "defaultzoom"                  6

configure_plugin 'EssentialsX' config \
    'allow-silient-join-quit'               true \
    'auto-afk'                              300 \
    "auto-afk-kick"                         "${IDLE_KICK_TIMEOUT_SECONDS}" \
    "change-tab-complete-name"              true \
    "command-cooldowns.tpr"                 300 \
    "currency-symbol"                       "${CURRENCY_SYMBOL}" \
    "disable-item-pickup-while-afk"         true \
    "kit-auto-equip"                        true \
    "newbies.spawnpoint"                    'none' \
    "newbies.kit"                           'spawn' \
    "ops-name-color"                        'none' \
    'per-player-locale'                     false \
    'per-warp-permissions'                  true \
    'remove-god-on-disconnect'              true \
    'show-zero-baltop'                      false \
    "teleport-cooldown"                     0 \
    "teleport-delay"                        0 \
    "teleport-invulnerability"              10 \
    'update-check'                          "${CHECK_PLUGINS_FOR_UPDATES}" \
    "unsafe-enchantments"                   true \
    "use-nbt-serialization-in-createkit"    true \
    "world-change-fly-reset"                false \
    "world-change-speed-reset"              false

configure_plugin 'Geyser' config \
    'above-bedrock-nether-building' true \
    'allow-custom-skulls' true \
    'bedrock.server-name' "${SERVER_NAME}" \
    'disable-bedrock-scaffolding' true \
    'max-players' "${PLAYERS_MAX}" \
    'metrics.enabled' "${CHECK_PLUGINS_FOR_UPDATES}" \
    'passthrough-motd' true \
    'passthrough-player-counts' true \
    'remote.auth-type' 'offline'

configure_plugin 'GrimAC' config \
    'exploit.allow-sprint-jumping-when-using-elytra' false

configure_plugin 'GSit' config \
    'Lang.client-lang'          false \
    'Options.check-for-update'  "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'HardPlus' config \
    'module.cold-damage.enable' false \
    'module.damage-give.modifier' 0.9 \
    'module.damage-take.modifier.default' 1.1 \
    'module.damage-take.modifier.environment' 1.1 \
    'module.damage-take.modifier.fall' 1.0 \
    'module.damage-take.modifier.magic' 1.1 \
    'module.damage-take.modifier.mob.hostile.default' 1.1 \
    'module.damage-take.modifier.mob.hostile.enderman' 1.25 \
    'module.damage-take.modifier.mob.hostile.skeleton' 1.1 \
    'module.damage-take.modifier.mob.hostile.zombie' 1.1 \
    'module.damage-take.modifier.mob.passive' 1.1 \
    'module.damage-take.modifier.melee' 1.1 \
    'module.damage-take.modifier.player' 1.0 \
    'module.mob-target.range' 10.0 \
    'module.wither-skeleton-bow.spawn-chance' 25.0

configure_plugin 'HealthHider' config \
    'enable-bypass-permission' true

configure_plugin 'InteractionVisualizer' config \
    'Modules.Hologram.Enabled' false

configure_plugin 'InvSee++' config \
    'enable-unknown-player-support' false

if is_plugin_installed 'InvUnload'; then
    INVUNLOAD_COOLDOWN=2
    configure_plugin 'InvUnload' config \
        'check-for-updates'         "${CHECK_PLUGINS_FOR_UPDATES}" \
        'default-chest-radius'      16 \
        'cooldown'                  "${INVUNLOAD_COOLDOWN}" \
        'ignore-blocked-chests'     false \
        'laser-animation'           false \
        'laser-default-duration'    5 \
        'max-chest-radius'          64 \
        'particle-type'             'WITCH'
fi

configure_plugin 'KauriVPN' config \
    'bstats' "${USE_TELEMETRY}"

configure_plugin 'LightAntiCheat' config \
    'alerts.broadcast-punishments.enabled' true \
    'alerts.broadcast-violations.enabled' false

configure_plugin 'LuckPerms' config \
    'resolve-command-selectors' true \
    'use-server-uuid-cache' true \
    'watch-files' false

configure_plugin 'OldCombatMechanics' config \
    'disable-chorus-fruit.enabled' true \
    'disable-crafting.enabled' false \
    'disable-enderpearl-cooldown.enabled' false \
    'disable-offhand.enabled' false \
    'disable-sword-sweep.enabled' false \
    'message-prefix' "§" \
    'update-checker.auto-update' false \
    'update-checker.enabled' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'OreAnnouncer' config \
    'oreannouncer.updates.check'    "${CHECK_PLUGINS_FOR_UPDATES}" \
    'oreannouncer.updates.warn'     "${CHECK_PLUGINS_FOR_UPDATES}"


configure_plugin 'Orebfuscator' config \
    'cache.baseDirectory' 'cache/orebfuscator' \
    'general.checkForUpdates' "${CHECK_PLUGINS_FOR_UPDATES}" \
    'general.updateOnBlockDamage' false \
    'general.bypassNotification' false \
    'general.ignoreSpectator' true \
    'obfuscation.obfuscation-end.enabled' false \
    'obfuscation.obfuscation-nether.enabled' true \
    'obfuscation.obfuscation-nether.hiddenBlocks' '["minecraft:ancient_debris"]' \
    'obfuscation.obfuscation-overworld.enabled' true \
    'obfuscation.obfuscation-overworld.hiddenBlocks' '["minecraft:diamond_ore","minecraft:deepslate_diamond_ore"]' \
    'obfuscation.obfuscation-overworld.maxY' '64' \
    'obfuscation.obfuscation-overworld.minY' '-64' \
    'proximity.proximity-overworld.enabled' false \
    'proximity.proximity-nether.enabled' false \
    'proximity.proximity-end.enabled' false

if is_plugin_installed 'PaperTweaks'; then
    configure_plugin 'PaperTweaks' config \
        'enable-bstats' "${USE_TELEMETRY}"
    
    set_config_values "${PAPERTWEAKS_MODULES_FILE}" \
        'items.player-head-drops' true \
        'mobs.more-mob-heads' true \
        'survival.cauldron-concrete' true \
        'survival.custom-nether-portals' true \
        'survival.durability-ping' true \
        'survival.unlock-all-recipes' true
    
    set_config_values "${PAPERTWEAKS_MODULES_DIR}/moremobheads/config.yml" \
        "require-player-kill" true
    
    set_config_values "${PAPERTWEAKS_MODULES_DIR}/playerheaddrops/config.yml" \
        "require-player-kill" true
fi

if is_plugin_installed 'Pl3xmap'; then
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
        "world-settings.${WORLD_NAME}.render.renderers.night" '' \
        "world-settings.${WORLD_NAME}.render.renderers.inhabited" '' \
        "world-settings.${WORLD_NAME}.render.renderers.flowermap" '' \
        "world-settings.${WORLD_NAME}.ui.display-name" "The Overworld" \
        "world-settings.${WORLD_NAME}.zoom.max-out" 3 \
        "world-settings.${WORLD_END_NAME}.enabled" true \
        "world-settings.${WORLD_END_NAME}.render.biome-blend" 0 \
        "world-settings.${WORLD_END_NAME}.render.renderers.basic" "the_end_basic" \
        "world-settings.${WORLD_END_NAME}.render.renderers.biomes" '' \
        "world-settings.${WORLD_END_NAME}.render.renderers.night" '' \
        "world-settings.${WORLD_END_NAME}.render.renderers.inhabited" '' \
        "world-settings.${WORLD_END_NAME}.render.renderers.flowermap" '' \
        "world-settings.${WORLD_END_NAME}.render.translucent-fluids" false \
        "world-settings.${WORLD_END_NAME}.ui.display-name" "The End" \
        "world-settings.${WORLD_END_NAME}.zoom.max-in" 1 \
        "world-settings.${WORLD_END_NAME}.zoom.max-out" 2 \
        "world-settings.${WORLD_NETHER_NAME}.enabled" true \
        "world-settings.${WORLD_NETHER_NAME}.render.biome-blend" 0 \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.basic" "nether_basic" \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.biomes" '' \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.night" '' \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.inhabited" '' \
        "world-settings.${WORLD_NETHER_NAME}.render.renderers.flowermap" '' \
        "world-settings.${WORLD_NETHER_NAME}.render.translucent-fluids" false \
        "world-settings.${WORLD_NETHER_NAME}.ui.display-name" "The Nether" \
        "world-settings.${WORLD_NETHER_NAME}.zoom.max-out" 0

    if cmp -s "${SERVER_IMAGE_FILE}" "${WEBMAP_ICON_FILE}"; then
        echo "Copying '${SERVER_IMAGE_FILE}' to '${WEBMAP_ICON_FILE}'..."
        sudo cp "${SERVER_IMAGE_FILE}" "${WEBMAP_ICON_FILE}"
    fi
    
    configure_plugin "Pl3xmap" "${PLEXMAP_CONFIG_COLOURS_FILE}" \
        "blocks.colors.minecraft:torch"             "#000000" \
        "blocks.colors.minecraft:wall_torch"        "#000000" \
        "blocks.colors.minecraft:soul_torch"        "#000000" \
        "blocks.colors.minecraft:soul_wall_torch"   "#000000"

    configure_plugin "Pl3xmap" "${PLEXMAP_DIR}/layers/spawn.yml" \
        "settings.enabled" true \
        "settings.layer.default-hidden" true

    configure_plugin "Pl3xmap" "${PLEXMAP_DIR}/layers/world-border.yml" \
        "settings.enabled" false \
        "settings.layer.default-hidden" true

    configure_plugin "Pl3xmap" "${PLEXMAP_CLAIMS_WORLDGUARD_CONFIG_FILE}" \
        "settings.layer.default-hidden" true \
        "world-settings.default.map.zoom.max" 2 \
        "world-settings.default.map.zoom.max-out" 1
fi

configure_plugin 'ProAntiTab' config \
    'updater.enabled' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'SkinsRestorer' config \
    'commands.perSkinPermissionConsent' 'I will follow the rules' \
    'SkinExpiresAfter' 180

configure_plugin 'Sonar' config \
    'general.check-for-updates' "${CHECK_PLUGINS_FOR_UPDATES}" \
    'general.max-online-per-ip' 5 \
    'database.maximum-age' 3 \
    'verification.check-geyser-players' false \
    'verification.transfer.enabled' true \
    'verification.destination-host' "${SERVER_HOSTNAME}"

configure_plugin 'spark' config \
    'backgroundProfiler' false

configure_plugin 'StackableItems' config \
    'update-check.enabled' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'SuperbVote' config \
    'queue-votes'           true \
    'require-online'        false \
    'storage.database'      'json' \
    'streaks.enabled'       true \
    'vote-reminder.repeat'  "${VOTE_REMINDER_INTERVAL_SECONDS}"

configure_plugin 'ToolStats' config \
    'enabled.dropped-by' false \
    'enabled.flight-time' false \
    'enabled.spawned-in.armor' false \
    'enabled.spawned-in.axe' false \
    'enabled.spawned-in.bow' false \
    'enabled.spawned-in.hoe' false \
    'enabled.spawned-in.pickaxe' false \
    'enabled.spawned-in.shears' false \
    'enabled.spawned-in.shovel' false \
    'enabled.spawned-in.sword' false

configure_plugin 'TradeShop' config \
    "language-options.shop-bad-colour" "${COLOUR_ERROR}" \
    "language-options.shop-good-colour" "${COLOUR_SUCCESS}" \
    "language-options.shop-incomplete-colour" "${COLOUR_ERROR}" \
    "system-options.allow-metrics" false \
    'system-options.check-updates' "${CHECK_PLUGINS_FOR_UPDATES}" \
    "system-options.unlimited-admin" true \
    "global-options.allowed-shops" '["BARREL","CHEST","TRAPPED_CHEST","SHULKER"]' \
    "global-options.allow-sign-break" true \
    "global-options.allow-chest-break" true
#     "shop-sign-options.sign-default-colours.birch-sign" "${COLOUR_WHITE}" \
#     "shop-sign-options.sign-default-colours.cherry-sign" "${COLOUR_WHITE}" \
#     "shop-sign-options.sign-default-colours.crimson-sign" "${COLOUR_WHITE}" \
#     "shop-sign-options.sign-default-colours.oak-sign" "${COLOUR_WHITE}" \
#     "shop-sign-options.sign-default-colours.mangrove-sign" "${COLOUR_WHITE}" \
#     "shop-sign-options.sign-default-colours.spruce-sign" "${COLOUR_WHITE}" \
#     "shop-sign-options.sign-default-colours.warped-sign" "${COLOUR_WHITE}"

if is_plugin_installed 'TreeAssist'; then
    # Integrations
    is_plugin_installed 'CoreProtect' && set_config_value "$(get_plugin_file TreeAssist config)" 'Placed Blocks.Plugin Name' 'CoreProtect'
    for PLUGIN_NAME in 'AureliumSkills' 'CustomEvents' 'Jobs' 'mcMMO' 'WorldGuard'; do
        set_config_value "$(get_plugin_file TreeAssist config)" "Plugins.${PLUGIN_NAME}" "$(is_plugin_installed_bool ${PLUGIN_NAME})"
    done

    if ${CHECK_PLUGINS_FOR_UPDATES}; then
        configure_plugin 'TreeAssist' config 'Update.Mode' 'announce'
    else
        configure_plugin 'TreeAssist' config 'Update.Mode' 'none'
    fi

    configure_plugin 'TreeAssist' config \
        'bStats.Active'                     "${USE_TELEMETRY}" \
        'bStats.Full'                       "${USE_TELEMETRY}" \
        'Commands.No Replant.Cooldown Time' 90 \
        'Commands.Replant.Cooldown Time'    90 \
        'Destruction.Falling Blocks'        true \
        'Destruction.Falling Blocks Fancy'  true \
        'General.Toggle Remember'           false \
        'General.Use Permissions'           true
fi

configure_plugin 'Updater' config \
    'disable'   "${SKIP_PLUGINS_FOR_UPDATES}"

configure_plugin 'Vault' config \
    'update-check' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'ViaVersion' config \
    'check-for-updates' "${CHECK_PLUGINS_FOR_UPDATES}"
    
configure_plugin 'ViewDistanceTweaks' config \
    'enabled' true \
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

configure_plugin 'VotingPlugin' config \
    'OnlineMode'                    "${ONLINE_MODE}" \
    'TreatVanishAsOffline'          true \
    'VoteReminding.RemindOnlyOnce'  false \
    'VoteReminding.RemindDelay'     "${VOTE_REMINDER_INTERVAL_MINUTES}"

configure_plugin 'WanderingTrades' config \
	'updateChecker' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'FastAsyncWorldEdit' config \
    'enabled-components.update-notifications' "${CHECK_PLUGINS_FOR_UPDATES}" \
    'history.use-database' false \
    'max-memory-percent' 85 \
    'region-restrictions' true \
    'queue.parallel-threads' "${CPU_THREADS_HALF}" \
    'queue.target-size' $((CPU_THREADS_HALF * 5))

configure_plugin 'WorldEditSUI' config \
    'advanced-grid.enabled' true \
    'update-checks' "${CHECK_PLUGINS_FOR_UPDATES}"

configure_plugin 'WorldGuard' config \
    'protections.max-claim-size' 125000 \
    'use-player-teleports' false

# Entity save limits
for ENTITY_TYPE in 'arrow' 'ender_pearl' 'experience_orb' 'fireball' 'small_fireball' 'snowball'; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "chunks.entity-per-chunk-save-limit.${ENTITY_TYPE}" 8
done

# Entity timeouts
for ENTITY_TYPE in 'ARROW' 'EGG' 'ENDER_PEARL' 'SNOWBALL'; do
    set_config_value "${PUFFERFISH_CONFIG_FILE}" "entity_timeouts.${ENTITY_TYPE}" 200
done

# Mob despawn ranges
for CREATURE_TYPE in 'axolotls' 'creature' 'misc' 'monster'; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.hard"    "${MOB_DESPAWN_RANGE_HARD}"
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.soft"    "${MOB_DESPAWN_RANGE_SOFT}"
done
for CREATURE_TYPE in "ambient" "underground_water_creature" "water_ambient" "water_creature"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.hard"    "${MOB_DESPAWN_RANGE_CLOSE_HARD}"
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.despawn-ranges.${CREATURE_TYPE}.soft"    "${MOB_DESPAWN_RANGE_SOFT}"
done

# Item despawn rates
for MATERIAL in 'diamond' 'netherite'; do
    for ITEM in "axe" "boots" "chestplate" "helmet" "hoe" "leggings" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
    done
done

for OVERWORLD_MATERIAL in 'coal' 'copper' 'iron' 'gold' 'redstone' 'lapis' 'diamond' 'emerald'; do
    for ITEM in "${OVERWORLD_MATERIAL}_block" "${OVERWORLD_MATERIAL}_ore" "deepslate_${OVERWORLD_MATERIAL}_ore"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${ITEM}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
    done
done
for OVERWORLD_MATERIAL in 'coal' 'redstone' 'diamond' 'emerald'; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${OVERWORLD_MATERIAL}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
done
for NETHER_MATERIAL in 'quartz' 'gold'; do
    for ITEM in "${NETHER_MATERIAL}" "${NETHER_MATERIAL}_block" "nether_${NETHER_MATERIAL}_ore"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${ITEM}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
    done
done
for OVERWORLD_MATERIAL_WITH_INGOT in "copper" "iron" "gold"; do
    for ITEM in "raw_${OVERWORLD_MATERIAL_WITH_INGOT}" "raw_${OVERWORLD_MATERIAL_WITH_INGOT}_block" "${OVERWORLD_MATERIAL_WITH_INGOT}_ingot"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${BLOCK}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
    done
done
for ITEM in \
    "coal" "redstone" "diamond" "emerald" \
    "ancient_debris" "netherite_block" "netherite_ingot" "netherite_scrap" \
    "beacon" "elytra" "nether_star" "shield" "spawner" "totem_of_undying" "wither_skeleton_skull"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
done
for ITEM in "bamboo" "cactus" "kelp" "melon_slice" "pumpkin"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" "${DESPAWN_RATE_ITEMS_MEDIUM_TICKS}"
done
for ITEM in \
    "acacia_leaves" "azalea_leaves" "birch_leaves" "cherry_leaves" "dark_oak_leaves" "jungle_leaves" "nether_wart_block" "mangrove_leaves" "oak_leaves" "spruce_leaves" "warped_wart_block" \
    "ender_pearl" "netherrack"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" "${DESPAWN_RATE_ITEMS_FAST_TICKS}"
done
for MATERIAL in "golden" "iron"; do
    for ITEM in "axe" "boots" "chestplate" "helmet" "hoe" "leggings" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" "${DESPAWN_RATE_ITEMS_FAST_TICKS}"
    done
done
for ITEM in "arrow" "bone" "rotten_flesh" "spider_eye" "string" "wheat_seeds"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" "${DESPAWN_RATE_ITEMS_INSTANT_TICKS}"
done
for ITEM in "boots" "chestplate" "helmet" "leggings"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.leather_${ITEM}" "${DESPAWN_RATE_ITEMS_INSTANT_TICKS}"
done
for MATERIAL in "wooden" "stone"; do
    for ITEM in "axe" "hoe" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" "${DESPAWN_RATE_ITEMS_INSTANT_TICKS}"
    done
done
