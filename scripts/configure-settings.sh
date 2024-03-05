#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

WEBMAP_PAGE_TITLE="${SERVER_NAME} World Map"

if [ "${LOCALE}" == "ro" ]; then
    WEBMAP_PAGE_TITLE="Harta ${SERVER_NAME}"

    INVALID_OR_UNALLOWED_COMMAND_MESSAGE="${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Această comandă nu poate fi executată."

    set_config_value "${PAPER_GLOBAL_CONFIG_FILE}" "messages.no-permission" "${INVALID_OR_UNALLOWED_COMMAND_MESSAGE}"
    set_config_value "${PURPUR_CONFIG_FILE}" "settings.messages.cannot-ride-mob" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Nu poți călări acest mob."
    set_config_value "${SPIGOT_CONFIG_FILE}" "messages.unknown-command" "${INVALID_OR_UNALLOWED_COMMAND_MESSAGE}"
else
    INVALID_OR_UNALLOWED_COMMAND_MESSAGE="${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}This command cannot be executed."

    set_config_value "${PAPER_GLOBAL_CONFIG_FILE}" "messages.no-permission" "${INVALID_OR_UNALLOWED_COMMAND_MESSAGE}"
    set_config_value "${PURPUR_CONFIG_FILE}" "settings.messages.cannot-ride-mob" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}You cannot ride that mob."
    set_config_value "${SPIGOT_CONFIG_FILE}" "messages.unknown-command" "${INVALID_OR_UNALLOWED_COMMAND_MESSAGE}"
fi

set_config_value "${SERVER_PROPERTIES_FILE}"            "max-players"                                               "${PLAYERS_MAX}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "view-distance"                                             "${VIEW_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "simulation-distance"                                       "${SIMULATION_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "enforce-secure-profile"                                    "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.item-despawn-rate"                  "${DESPAWN_RATE_ITEMS_DEFAULT_TICKS}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.mob-spawn-range"                    "${MOB_SPAWN_RANGE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.simulation-distance"                "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.view-distance"                      "${VIEW_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.simulation-distance"      "${SIMULATION_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.view-distance"            "${VIEW_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.simulation-distance"   "${SIMULATION_DISTANCE_NETHER}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.view-distance"         "${VIEW_DISTANCE_NETHER}"
set_config_value "${BUKKIT_CONFIG_FILE}"                "spawn-limits.monsters"                                     "${MOB_SPAWN_LIMIT_MONSTER}"

set_config_value "${PAPER_GLOBAL_CONFIG_FILE}" "timings.server-name" "${SERVER_NAME}"

set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "chunks.flush-regions-on-save"                          true
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "chunks.flush-regions-on-save"                          true
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.wandering-trader.spawn-chance-max"   125         
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.wandering-trader.spawn-day-length"   "${DAYTIME_LENGTH_TICKS}"         
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "spawn.keep-spawn-loaded"                               "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "spawn.keep-spawn-loaded-range"                         "${VIEW_DISTANCE}"

set_config_value "${PAPER_WORLD_CONFIG_FILE}"           "chunks.auto-save-interval"                     $((AUTOSAVE_MINS * 20 * 60))
set_config_value "${PAPER_WORLD_CONFIG_FILE}"           "spawn.keep-spawn-loaded"                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_CONFIG_FILE}"           "spawn.keep-spawn-loaded-range"                 "${VIEW_DISTANCE}"

set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       "chunks.auto-save-interval"                     $((AUTOSAVE_MINS_END * 20 * 60))
set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       "spawn.keep-spawn-loaded"                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_END_CONFIG_FILE}"       "spawn.keep-spawn-loaded-range"                 "${VIEW_DISTANCE_END}"

set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    "chunks.auto-save-interval"                     $((AUTOSAVE_MINS_NETHER * 20 * 60))
set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    "spawn.keep-spawn-loaded"                       "${KEEP_SPAWN_LOADED}"
set_config_value "${PAPER_WORLD_NETHER_CONFIG_FILE}"    "spawn.keep-spawn-loaded-range"                 "${VIEW_DISTANCE_NETHER}"

set_config_value "${PURPUR_CONFIG_FILE}" "settings.server-mod-name"                                                                     "${SERVER_NAME}"
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.blocks.campfire.lit-when-placed"                                       false
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.blocks.chest.open-with-solid-block-on-top"                             true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.blocks.coral.die-outside-water"                                        false
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.blocks.farmland.get-moist-from-below"                                  true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.blocks.respawn-anchor.explode"                                         false
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.blocks.sponge.absorption.range"                                        8
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.blocks.stonecutter.damage"                                             1.0
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.armorstand.place-with-arms-visible"                 true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.daylight-cycle-ticks.daytime"                       "${DAYTIME_LENGTH_TICKS}"
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.daylight-cycle-ticks.nighttime"                     "${NIGHTTIME_LENGTH_TICKS}"
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.disable-oxidation-proximity-penalty"                true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.mob-spawning.ignore-creative-players"               true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.persistent-droppable-display-names"                 true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.persistent-tileentity-display-names-and-lore"       true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.player.exp-dropped-on-death.maximum"                100000
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.player.invulnerable-while-accepting-resource-pack"  true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.player.shift-right-click-repairs-mending-points"    10
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.use-better-mending"                                 true

configure_plugin "PurpurExtras" "${PURPUR_EXTRAS_CONFIG_FILE}" \
    "settings.blocks.shift-right-click-for-invisible-item-frames" true \
    "settings.gameplay-settings.cancel-damage-from-pet-owner" true \
    "settings.items.beehive-lore.enabled" true \
    "settings.lightning-transforms-entities.enabled" true \
    "settings.mobs.snow_golem.drop-pumpkin-when-sheared" true \
    "settings.mobs.sheep.jeab-shear-random-color" true \
    "settings.mobs.unlock-all-recipes-on-join" true \
    "settings.protect-blocks-with-loot.enabled" true \
    "settings.anvil-splits-boats" true \
    "settings.anvil-splits-minecarts" true \

if is_plugin_installed "AuthMe"; then
    configure_plugin "AuthMe" "${AUTHME_CONFIG_FILE}" \
        "Hooks.useEssentialsMotd" $(is_plugin_installed "EssentialsX") \
        "settings.forceVaultHook" $(is_plugin_installed "Vault") \
        "settings.restrictions.displayOtherAccounts" false \
        "settings.serverName" "${SERVER_NAME}" \
        "settings.sessions.enabled" true \
        "settings.sessions.timeout" 960 \
        "settings.messagesLanguage" "${LOCALE}" \
        "settings.restrictions.teleportUnAuthedToSpawn" false

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "AuthMe" "${AUTHME_DIR}/messages/messages_ro.yml" \
            "error.denied_chat" "${COLOUR_ALERT}EROARE! ${COLOUR_MESSAGE}Trebuie să te autentifici pentru a putea vorbi." \
            "error.denied_command" "${COLOUR_ALERT}EROARE! ${COLOUR_MESSAGE}Trebuie să te autentifici pentru a putea folosi acea comandă." \
            "error.logged_in" "${COLOUR_ALERT}EROARE! ${COLOUR_MESSAGE}Ești autentificat deja." \
            "login.login_request" "${COLOUR_ALERT}ATENȚIE! ${COLOUR_MESSAGE}Trebuie să te autentifici pentru a putea juca.\n${COLOUR_MESSAGE}Folosește ${COLOUR_HIGHLIGHT}/logare <Parolă>" \
            "login.success" "${COLOUR_SUCCESS}SUCCES! ${COLOUR_MESSAGE}Te-ai autentificat." \
            "login.wrong_password" "${COLOUR_ERROR}EȘEC! ${COLOUR_MESSAGE}Parola este greșită." \
            "misc.logout" "${COLOUR_MESSAGE}Te-ai deautentificat." \
            "password.match_error" "${COLOUR_ERROR}EȘEC! ${COLOUR_MESSAGE}Parola de confirmare nu se potrivește." \
            "registration.register_request" "${COLOUR_ALERT}ATTENTION! ${COLOUR_MESSAGE}Trebuie să te înregistrezi pentru a putea juca.\n${COLOUR_MESSAGE}Folosește ${COLOUR_HIGHLIGHT}/logare <Parolă> <ConfirmareaParolei>" \
            "registration.success" "${COLOUR_SUCCESS}SUCCES! ${COLOUR_MESSAGE}Te-ai înregistrat." \
            "session.valid_session" "${COLOUR_MESSAGE}Ai rămas autentificat de data trecută."
    else
        configure_plugin "AuthMe" "${AUTHME_DIR}/messages/messages_en.yml" \
            "error.denied_chat" "${COLOUR_ALERT}ERROR! ${COLOUR_MESSAGE}You must authenticate in order to chat." \
            "error.denied_command" "${COLOUR_ALERT}ERROR! ${COLOUR_MESSAGE}You must authenticate in order to use that command." \
            "error.logged_in" "${COLOUR_ALERT}ERROR! ${COLOUR_MESSAGE}You are already authenticated." \
            "login.login_request" "${COLOUR_ALERT}ATTENTION! ${COLOUR_MESSAGE}You must authenticate in order to play.\n${COLOUR_MESSAGE}Use ${COLOUR_HIGHLIGHT}/login <Password>" \
            "login.success" "${COLOUR_SUCCESS}SUCCES! ${COLOUR_MESSAGE}You are now authenticated." \
            "login.wrong_password" "${COLOUR_ERROR}FAILURE! ${COLOUR_MESSAGE}The password is incorrect." \
            "misc.logout" "${COLOUR_MESSAGE}You are now deauthenticated." \
            "password.match_error" "${COLOUR_ERROR}FAILURE! ${COLOUR_MESSAGE}The confirmation password does not match." \
            "registration.register_request" "${COLOUR_ALERT}ATTENTION! ${COLOUR_MESSAGE}You must register in order to play.\n${COLOUR_MESSAGE}Use ${COLOUR_HIGHLIGHT}/auth <Password> <ConfirmPassword>" \
            "registration.success" "${COLOUR_SUCCESS}SUCCESS! ${COLOUR_MESSAGE}You are now registered." \
            "session.valid_session" "${COLOUR_MESSAGE}You remained authenticated from the previous session."
    fi
fi

# Check Updates because we cannot auto-update this one
configure_plugin "CoreProtect" "${COREPROTECT_CONFIG_FILE}" \
    "check-updates" true

configure_plugin "DiscordSRV" "${DISCORDSRV_CONFIG_FILE}" \
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

    set_config_value "${DYNMAP_CONFIG_FILE}" "fullrenderplayerlimit"        3
    set_config_value "${DYNMAP_CONFIG_FILE}" "updateplayerlimit"            4

    #
    set_config_value "${DYNMAP_CONFIG_FILE}" "smooth-lighting"              true
    set_config_value "${DYNMAP_CONFIG_FILE}" "image-format"                 "png"
    set_config_value "${DYNMAP_CONFIG_FILE}" "use-generated-textures"       false
    set_config_value "${DYNMAP_CONFIG_FILE}" "correct-water-lighting"       false
    set_config_value "${DYNMAP_CONFIG_FILE}" "transparent-leaves"           true # Might affect performance tho
    set_config_value "${DYNMAP_CONFIG_FILE}" "ctm-support"                  false
    set_config_value "${DYNMAP_CONFIG_FILE}" "skinsrestorer-integration"    $(is_plugin_installed "SkinsRestorer")
    set_config_value "${DYNMAP_CONFIG_FILE}" "defaultzoom"                  6
fi

if is_plugin_installed "EssentialsX"; then
    configure_plugin "EssentialsX" "${ESSENTIALS_CONFIG_FILE}" \
        "auto-afk"                              300 \
        "auto-afk-kick"                         "${IDLE_KICK_TIMEOUT_SECONDS}" \
        "change-tab-complete-name"              true \
        "chat.format"                           "${COLOUR_PLAYER}{DISPLAYNAME}${COLOUR_RESET}: ${COLOUR_CHAT}{MESSAGE}" \
        "command-cooldowns.tpr"                 300 \
        "currency-symbol"                       "₦" \
        "disable-item-pickup-while-afk"         true \
        "kit-auto-equip"                        true \
        "locale"                                "${LOCALE}" \
        "message-colors.primary"                "${COLOUR_MESSAGE_HEX}" \
        "message-colors.secondary"              "${COLOUR_HIGHLIGHT_HEX}" \
        "newbies.spawnpoint"                    "none" \
        "newbies.kit"                           "spawn" \
        "ops-name-color"                        "none" \
        "per-player-locale"                     true \
        "per-warp-permissions"                  true \
        "remove-god-on-disconnect"              true \
        "teleport-cooldown"                     4 \
        "teleport-delay"                        3 \
        "teleport-invulnerability"              7 \
        "update-check"                          false \
        "unsafe-enchantments"                   true \
        "use-nbt-serialization-in-createkit"    true \
        "world-change-fly-reset"                false \
        "world-change-speed-reset"              false

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "EssentialsX" "${ESSENTIALS_CONFIG_FILE}" \
            "custom-join-message"           "${COLOUR_PLAYER}{PLAYER} ${COLOUR_ACTION}a intrat în joc!" \
            "custom-quit-message"           "${COLOUR_PLAYER}{PLAYER} ${COLOUR_ACTION}a ieșit din joc!" \
            "custom-new-username-message"   "${COLOUR_PLAYER}{PLAYER} ${COLOUR_ACTION}a intrat în joc!" \
            "newbies.announce-format"       "${COLOUR_ANNOUNCEMENT}Bun venit ${COLOUR_PLAYER}{DISPLAYNAME} ${COLOUR_ANNOUNCEMENT}pe ${COLOUR_HIGHLIGHT}${SERVER_NAME}${COLOUR_ANNOUNCEMENT}!"

        create-file "${ESSENTIALS_DIR}/messages_ro.properties"
        configure_plugin "EssentialsX" "${ESSENTIALS_DIR}/messages_ro.properties" \
            "action"                "${COLOUR_PLAYER_XML}{0} ${COLOUR_ACTION_XML}{1}." \
            "kitResetOther"         "${COLOUR_MESSAGE_XML}Perioada de așteptare a kit-ului ${COLOUR_HIGHLIGHT_XML}{0} ${COLOUR_MESSAGE_XML}a fost resetată pentru ${COLOUR_PLAYER_XML}{1}${COLOUR_MESSAGE_XML}." \
            "meRecipient"           "${COLOUR_HIGHLIGHT_XML}eu" \
            "meSender"              "${COLOUR_HIGHLIGHT_XML}eu" \
            "msgFormat"             "${COLOUR_PLAYER_XML}{0} <primary>→ ${COLOUR_PLAYER_XML}{1}: ${COLOUR_CHAT_PRIVATE_XML}{2}" \
            "playerNeverOnServer"   "${COLOUR_ERROR_XML}ERROR! ${COLOUR_PLAYER_XML}{0} <primary>nu a jucat niciodată pe <secondary>${SERVER_NAME}<primary>." \
            "seenOffline"           "${COLOUR_PLAYER_XML}{0} <primary>este <dark_red>offline<primary> de <secondary>{1}<primary>." \
            "seenOnline"            "${COLOUR_PLAYER_XML}{0} <primary>este <green>online<primary> de <secondary>{1}<primary>." \
            "warpingTo"             "<primary>Te teleportezi la <secondary>{0}<primary>."
    else
        configure_plugin "EssentialsX" "${ESSENTIALS_CONFIG_FILE}" \
            "custom-join-message"           "${COLOUR_PLAYER}{PLAYER} ${COLOUR_ACTION}joined the game!" \
            "custom-quit-message"           "${COLOUR_PLAYER}{PLAYER} ${COLOUR_ACTION}left the game!" \
            "custom-new-username-message"   "${COLOUR_PLAYER}{PLAYER} ${COLOUR_ACTION}joined the game!" \
            "newbies.announce-format"       "${COLOUR_ANNOUNCEMENT}Welcome ${COLOUR_PLAYER}{DISPLAYNAME} ${COLOUR_ANNOUNCEMENT}to ${COLOUR_HIGHLIGHT}${SERVER_NAME}${COLOUR_ANNOUNCEMENT}!"

        create-file "${ESSENTIALS_DIR}/messages_ens.properties"
        configure_plugin "EssentialsX" "${ESSENTIALS_DIR}/messages_ens.properties" \
            "action"                "${COLOUR_PLAYER_XML}{0} ${COLOUR_ACTION_XML}{1}." \
            "kitResetOther"         "${COLOUR_MESSAGE_XML}The cooldown for kit ${COLOUR_HIGHLIGHT_XML}{0} ${COLOUR_MESSAGE_XML}has been reset for ${COLOUR_PLAYER_XML}{1}${COLOUR_MESSAGE_XML}." \
            "meRecipient"           "${COLOUR_HIGHLIGHT_XML}me" \
            "meSender"              "${COLOUR_HIGHLIGHT_XML}me" \
            "msgFormat"             "${COLOUR_PLAYER_XML}{0} <primary>→ ${COLOUR_PLAYER_XML}{1}: ${COLOUR_CHAT_PRIVATE_XML}{2}" \
            "playerNeverOnServer"   "${COLOUR_ERROR_XML}ERROR! ${COLOUR_PLAYER_XML}{0} <primary>never played on <secondary>${SERVER_NAME}<primary>." \
            "seenOffline"           "${COLOUR_PLAYER_XML}{0} <primary>has been <dark_red>offline<primary> since <secondary>{1}<primary>." \
            "seenOnline"            "${COLOUR_PLAYER_XML}{0} <primary>has been <green>online<primary> since <secondary>{1}<primary>." \
            "warpingTo"             "<primary>Whisking ye away to <secondary>{0}<primary>."
    fi
fi

configure_plugin "GSit" "${GSIT_CONFIG_FILE}" \
    "Options.check-for-update" false

configure_plugin "InvSee++" "${INVSEE_CONFIG_FILE}" \
    "enable-unknown-player-support" false

if is_plugin_installed "InvUnload"; then
    INVUNLOAD_COOLDOWN=2
    configure_plugin "InvUnload" "${INVUNLOAD_CONFIG_FILE}" \
        "max-chest-radius" 128 \
        "default-chest-radius" 24 \
        "cooldown" ${INVUNLOAD_COOLDOWN} \
        "ignore-blocked-chests" false \
        "check-for-updates" false \
        "message-prefix" "&r"

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "InvUnload" "${INVUNLOAD_CONFIG_FILE}" \
            "message-cooldown" "${COLOUR_ERROR}EȘEC! ${COLOUR_MESSAGE}Trebuie să aștepți ${COLOUR_HIGHLIGHT}${INVUNLOAD_COOLDOWN} secunde${COLOUR_MESSAGE} de la ultima golire." \
            "message-could-not-unload" "${COLOUR_ERROR}EȘEC! ${COLOUR_MESSAGE}Nu au fost găsite containere pentru restul obiectelor." \
            "message-error-not-a-number" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Distanța specificată nu este un număr valid." \
            "message-inventory-empty" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Inventarul tău este deja gol." \
            "message-radius-too-high" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Distanța nu poate fi mai mare de ${COLOUR_HIGHLIGHT}%d${COLOUR_MESSAGE} blocuri."
    else
        configure_plugin "InvUnload" "${INVUNLOAD_CONFIG_FILE}" \
            "message-cooldown" "${COLOUR_ERROR}FAILURE! ${COLOUR_MESSAGE}You need to wait ${COLOUR_HIGHLIGHT}${INVUNLOAD_COOLDOWN} seconds${COLOUR_MESSAGE} since the last unload." \
            "message-could-not-unload" "${COLOUR_ERROR}FAILURE! ${COLOUR_MESSAGE}There are no containers for the remaining items." \
            "message-error-not-a-number" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}The specified distance is not a valid number." \
            "message-inventory-empty" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}Your inventory is already empty." \
            "message-radius-too-high" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}The distance cannot be greater than ${COLOUR_HIGHLIGHT}%d${COLOUR_MESSAGE} blocks."
    fi
fi

configure_plugin "LuckPerms" "${LUCKPERMS_CONFIG_FILE}" \
    "resolve-comman-selectors" true \
    "use-server-uuid-cache" true \
    "watch-files" false

configure_plugin "OldCombatMechanics" "${OLDCOMBATMECHANICS_CONFIG_FILE}" \
    "disable-chorus-fruit.enabled" true \
    "disable-crafting.enabled" false \
    "disable-enderpearl-cooldown.enabled" false \
    "disable-offhand.enabled" false \
    "disable-sword-sweep.enabled" false \
    "update-checker.auto-update" false \
    "update-checker.enabled" false


if is_plugin_installed "PaperTweaks"; then
    set_config_values "${PAPERTWEAKS_CONFIG_FILE}" \
        "enable-bstats" false
    
    set_config_values "${PAPERTWEAKS_MODULES_FILE}" \
        "items.player-head-drops" true \
        "mobs.more-mob-heads" true \
        "survival.durability-ping" true \
        "survival.unlock-all-recipes" true
    
    set_config_values "${PAPERTWEAKS_MODULES_DIR}/moremobheads/config.yml" \
        "require-player-kill" true
    
    set_config_values "${PAPERTWEAKS_MODULES_DIR}/playerheaddrops/config.yml" \
        "require-player-kill" true
    
    reload_plugin "PaperTweaks"
fi

if is_plugin_installed "Pl3xmap"; then
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
        "settings.claim.popup.flags" "Protected Region" \
        "settings.layer.default-hidden" true \
        "settings.layer.label" "Regions" \
        "world-settings.default.map.zoom.max" 2 \
        "world-settings.default.map.zoom.max-out" 1 \
fi

if is_plugin_installed "SkinsRestorer"; then
    configure_plugin "SkinsRestorer" "${SKINSRESTORER_CONFIG_FILE}" \
        "SkinExpiresAfter" 180

    if [ "${LOCALE}" == "ro" ]; then
        copy-file-if-needed "${SKINSRESTORER_DIR}/locales/repository/locale_ro.json" "${SKINSRESTORER_DIR}/locales/custom/locale_ro.json"
        configure_plugin "SkinsRestorer" "${SKINSRESTORER_DIR}/locales/custom/locale.json" \
            "skinsrestorer..prefix_format" "${COLOUR_MESSAGE_XML}<message>" \
            "skinsrestorer..error_generic" "${COLOUR_ERROR_XML}EOARE! ${COLOUR_MESSAGE_XML}<message>" \
            "skinsrestorer..error_invalid_urlskin" "${COLOUR_ERROR_XML}EROARE! ${COLOUR_MESSAGE_XML}URL-ul sau formatul skin-ului este invalid. Asigură-te că se termină cu '${COLOUR_HIGHLIGHT_XML}.png${COLOUR_MESSAGE_XML}'." \
            "skinsrestorer..ms_uploading_skin" "${COLOUR_MESSAGE_XML}Se încarcă skin-ul..." \
            "skinsrestorer..success_admin_reload" "${COLOUR_SUCCESS_XML}SUCCES: ${COLOUR_MESSAGE_XML}Reloaded plugin ${COLOUR_PLUGIN_XML}SkinsRestorer${COLOUR_MESSAGE_XML}." \
            "skinsrestorer..success_generic" "${COLOUR_SUCCESS_XML}SUCCES! ${COLOUR_MESSAGE_XML}<message>" \
            "skinsrestorer..success_skin_change" "${COLOUR_MESSAGE_XML}Skin-ul tău a fost schimbat." \
            "skinsrestorer..success_skin_change_other" "${COLOUR_MESSAGE_XML}Skin-ul lui ${COLOUR_PLAYER_XML}<name> ${COLOUR_MESSAGE_XML}a fost schimbat." \
            "skinsrestorer..success_skin_updating" "${COLOUR_MESSAGE_XML}Skin-ul tău a fost actualizat." \
            "skinsrestorer..success_skin_updating_other" "${COLOUR_MESSAGE_XML}Skin-ul lui ${COLOUR_PLAYER_XML}<name> ${COLOUR_MESSAGE_XML}a fost actualizat."
    else
        copy-file-if-needed "${SKINSRESTORER_DIR}/locales/repository/locale.json" "${SKINSRESTORER_DIR}/locales/custom/locale.json"
        configure_plugin "SkinsRestorer" "${SKINSRESTORER_DIR}/locales/custom/locale.json" \
            "skinsrestorer..prefix_format" "${COLOUR_MESSAGE_XML}<message>" \
            "skinsrestorer..error_generic" "${COLOUR_ERROR_XML}ERROR! ${COLOUR_MESSAGE_XML}<message>" \
            "skinsrestorer..error_invalid_urlskin" "${COLOUR_ERROR_XML}ERROR! ${COLOUR_MESSAGE_XML}The skin's URL or format is invalid. Make sure it ends with '${COLOUR_HIGHLIGHT_XML}.png${COLOUR_MESSAGE_XML}'." \
            "skinsrestorer..ms_uploading_skin" "${COLOUR_MESSAGE_XML}Uploading the skin..." \
            "skinsrestorer..success_admin_reload" "${COLOUR_SUCCESS_XML}SUCCESS! ${COLOUR_MESSAGE_XML}Reloaded plugin ${COLOUR_PLUGIN_XML}SkinsRestorer${COLOUR_MESSAGE_XML}." \
            "skinsrestorer..success_generic" "${COLOUR_SUCCESS_XML}SUCCESS! ${COLOUR_MESSAGE_XML}<message>" \
            "skinsrestorer..success_skin_change" "${COLOUR_MESSAGE_XML}Your skin has been changed." \
            "skinsrestorer..success_skin_change_other" "${COLOUR_PLAYER_XML}<name>${COLOUR_MESSAGE_XML}'s skin has been changed." \
            "skinsrestorer..success_skin_updating" "${COLOUR_MESSAGE_XML}Your skin has been updated." \
            "skinsrestorer..success_skin_updating_other" "${COLOUR_PLAYER_XML}<name>${COLOUR_MESSAGE_XML}'s skin has been updated."
    fi
fi

configure_plugin "spark" "${SPARK_CONFIG_FILE}" \
    "backgroundProfiler" false

configure_plugin "StackableItems" "${STACKABLEITEMS_CONFIG_FILE}" \
    "update-check.enabled" false

configure_plugin "SuperbVote" "${SUPERBVOTE_CONFIG_FILE}" \
    "queue-votes"           true \
    "require-online"        false \
    "storage.database"      "mysql" \
    "streaks.enabled"       true \
    "vote-reminder.repeat"  ${VOTE_REMINDER_INTERVAL_SECONDS}

if is_plugin_installed "TradeShop"; then
    # TODO: check-updates to false once it can be updated via script
    configure_plugin "TradeShop" "${TRADESHOP_CONFIG_FILE}" \
        "language-options.message-prefix" "§" \
        "language-options.shop-bad-colour" "${COLOUR_ERROR}" \
        "language-options.shop-good-colour" "${COLOUR_SUCCESS}" \
        "language-options.shop-incomplete-colour" "${COLOUR_ERROR}" \
        "system-options.allow-metrics" false \
        "system-options.check-updates" false \
        "system-options.unlimited-admin" true \
        "global-options.allowed-shops" '["BARREL","CHEST","TRAPPED_CHEST","SHULKER"]' \
        "global-options.allow-sign-break" true \
        "global-options.allow-chest-break" true
#        "shop-sign-options.sign-default-colours.birch-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.cherry-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.crimson-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.oak-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.mangrove-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.spruce-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.warped-sign" "${COLOUR_WHITE}"

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "TradeShop" "${TRADESHOP_CONFIG_FILE}" \
            "language-options.shop-closed-status" "${COLOUR_ERROR}<Închis>" \
            "language-options.shop-incomplete-status" "${COLOUR_ERROR}<Invalid>" \
            "language-options.shop-open-status" "${COLOUR_SUCCESS}<Deschis>" \
            "language-options.shop-outofstock-status" "${COLOUR_ERROR}<Stoc Insuficient>"
            
        configure_plugin "TradeShop" "${TRADESHOP_MESSAGES_FILE}" \
            "change-closed" "${COLOUR_MESSAGE}Oferta a fost dezactivată." \
            "change-open" "${COLOUR_MESSAGE}Oferta a fost activată." \
            "insufficient-items" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Îți lipsesc următoarele obiecte:\n{%MISSINGITEMS%=  ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%}" \
            "item-added" "${COLOUR_MESSAGE}Produsul a fost adăugat la ofertă." \
            "item-not-removed" "${COLOUR_ERROR}! ${COLOUR_MESSAGE}Produsul nu a putut fi scos de la ofertă." \
            "item-removed" "${COLOUR_MESSAGE}Produsul a fost scos de la ofertă." \
            "no-sighted-shop" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Nu a putut fi găsită nici o ofertă." \
            "no-ts-create-permission" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Nu poți crea acest tip de ofertă." \
            "no-ts-open" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Nu poți deschide această ofertă." \
            "on-trade" "${COLOUR_MESSAGE}Ai cumpărat {%RECEIVEDLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%} ${COLOUR_MESSAGE}cu {%GIVENLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%}" \
            "player-full" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Ai inventarul plin." \
            "shop-closed" "${COLOUR_ERROR}EROARE! Această ofertă nu este activă." \
            "shop-empty" "${COLOUR_ERROR}EROARE! Această ofertă nu are stoc suficient." \
            "shop-full" "${COLOUR_ERROR}EROARE! Această ofertă nu are spațiu suficient în inventar." \
            "shop-insufficient-items" "${COLOUR_ERROR}EROARE! ${COLOUR_MESSAGE}Această ofertă nu are stoc suficient." \
            "successful-setup" "${COLOUR_MESSAGE}Ai creat cu succes o ofertă de vânzare."
    else
        configure_plugin "TradeShop" "${TRADESHOP_CONFIG_FILE}" \
            "language-options.shop-closed-status" "${COLOUR_ERROR}<Closed>" \
            "language-options.shop-incomplete-status" "${COLOUR_ERROR}<Invalid>" \
            "language-options.shop-open-status" "${COLOUR_SUCCESS}<Open>" \
            "language-options.shop-outofstock-status" "${COLOUR_ERROR}<Out of Stock>"

        configure_plugin "TradeShop" "${TRADESHOP_MESSAGES_FILE}" \
            "change-closed" "${COLOUR_MESSAGE}The offer was disabled." \
            "change-open" "${COLOUR_MESSAGE}The offer was enabled." \
            "insufficient-items" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}You are missing the following items:\n{%MISSINGITEMS%=  ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%}" \
            "item-added" "${COLOUR_MESSAGE}The product was added to the offer." \
            "item-not-removed" "${COLOUR_ERROR}! ${COLOUR_MESSAGE}The product could not be removed from the offer." \
            "item-removed" "${COLOUR_MESSAGE}The product was removed from the offer." \
            "no-sighted-shop" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}Could not find any offer in range." \
            "no-ts-create-permission" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}You cannot create this type of offer." \
            "no-ts-open" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}You cannot open this type of offer." \
            "on-trade" "${COLOUR_MESSAGE}You bought:\n{%RECEIVEDLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%}\n${COLOUR_MESSAGE}for:\n{%GIVENLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%}" \
            "player-full" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}Your inventory is full." \
            "shop-closed" "${COLOUR_ERROR}ERROR! This offer is not active." \
            "shop-empty" "${COLOUR_ERROR}ERROR! This offer is out of stock." \
            "shop-full" "${COLOUR_ERROR}ERROR! This offer's inventory is full." \
            "shop-insufficient-items" "${COLOUR_ERROR}ERROR! ${COLOUR_MESSAGE}This offer is out of stock." \
            "successful-setup" "${COLOUR_MESSAGE}You have successfully set up a trade offer."
    fi
fi

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
    is_plugin_installed "CoreProtect" && set_config_value "${TREEASSIST_CONFIG_FILE}" "Placed Blocks.Plugin Name" "CoreProtect"
    set_config_value "${TREEASSIST_CONFIG_FILE}" "Plugins.WorldGuard" $(is_plugin_installed "WorldGuard")

    reload_plugin "treeassist"
fi

configure_plugin "Vault" "${VAULT_CONFIG_FILE}" \
    "update-check" false

configure_plugin "ViaVersion" "${VIAVERSION_CONFIG_FILE}" \
    "checkforupdates" false
    
configure_plugin "ViewDistanceTweaks" "${VIEWDISTANCETWEAKS_CONFIG_FILE}" \
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

if is_plugin_installed "VotingPlugin"; then
    configure_plugin "VotingPlugin" "${VOTINGPLUGIN_CONFIG_FILE}" \
        "OnlineMode"                    ${ONLINE_MODE} \
        "TreatVanishAsOffline"          true \
        "VoteReminding.RemindOnlyOnce"  false \
        "VoteReminding.RemindDelay"     ${VOTE_REMINDER_INTERVAL_MINUTES}

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "VotingPlugin" "${VOTINGPLUGIN_CONFIG_FILE}" \
            "Format.BroadcastMsg"  "${COLOUR_PLAYER}%player% ${COLOUR_ACTION}a fost recompensat pentru votul pe ${COLOUR_HIGHLIGHT}%SiteName%${COLOUR_ACTION}." \
            "VoteReminding.Rewards.Messages.Player"  "${COLOUR_MESSAGE}Încă mai ai ${COLOUR_HIGHLIGHT}%sitesavailable% site-uri ${COLOUR_MESSAGE}pe care să votezi."
    else
        configure_plugin "VotingPlugin" "${VOTINGPLUGIN_CONFIG_FILE}" \
            "Format.BroadcastMsg"  "${COLOUR_PLAYER}%player% ${COLOUR_ACTION}was rewarded for voting on ${COLOUR_HIGHLIGHT}%SiteName%${COLOUR_ACTION}." \
            "VoteReminding.Rewards.Messages.Player"  "${COLOUR_MESSAGE}You have ${COLOUR_HIGHLIGHT}%sitesavailable% sites ${COLOUR_MESSAGE}left to vote on."
    fi
fi

configure_plugin "WanderingTrades" "${WANDERINGTRADES_CONFIG_FILE}" \
	"updateChecker" false
#	"language" "${LOCALE_FULL}" \

configure_plugin "FastAsyncWorldEdit" "${WORLDEDIT_CONFIG_FILE}" \
    "enabled-components.update-notifications" false \
    "max-memory-percent" 85 \
    "queue.parallel-threads" ${CPU_THREADS}

configure_plugin "WorldEditSUI" "${WORLDEDITSUI_CONFIG_FILE}" \
    "update-checks" false

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
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" ${DESPAWN_RATE_ITEMS_RARE_TICKS}
    done
done

for OVERWORLD_MATERIAL in "coal" "copper" "iron" "gold" "redstone" "lapis" "diamond" "emerald"; do
    for BLOCK in "${OVERWORLD_MATERIAL}_block" "${OVERWORLD_MATERIAL}_ore" "deepslate_${OVERWORLD_MATERIAL}_ore"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${BLOCK}" ${DESPAWN_RATE_ITEMS_RARE_TICKS}
    done
done
for NETHER_MATERIAL in "quartz" "gold"; do
    for BLOCK in "${NETHER_MATERIAL}_block" "nether_${NETHER_MATERIAL}_ore"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${BLOCK}" ${DESPAWN_RATE_ITEMS_RARE_TICKS}
    done
done
for OVERWORLD_MATERIAL_WITH_INGOT in "copper" "iron" "gold"; do
    for ITEM in "raw_${OVERWORLD_MATERIAL_WITH_INGOT}" "raw_${OVERWORLD_MATERIAL_WITH_INGOT}_block" "${OVERWORLD_MATERIAL_WITH_INGOT}_ingot"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${BLOCK}" ${DESPAWN_RATE_ITEMS_RARE_TICKS}
    done
done
for ITEM in \
    "coal" "redstone" "diamond" "emerald" \
    "ancient_debris" "netherite_block" "netherite_ingot" "netherite_scrap" \
    "beacon" "elytra" "nether_star" "shield" "spawner" "totem_of_undying" "wither_skeleton_skull"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" ${DESPAWN_RATE_ITEMS_RARE_TICKS}
done
for ITEM in "bamboo" "cactus" "kelp" "melon_slice" "pumpkin"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" ${DESPAWN_RATE_ITEMS_MEDIUM_TICKS}
done
for ITEM in \
    "acacia_leaves" "azalea_leaves" "birch_leaves" "cherry_leaves" "dark_oak_leaves" "jungle_leaves" "nether_wart_block" "mangrove_leaves" "oak_leaves" "spruce_leaves" "warped_wart_block" \
    "ender_pearl" "netherrack"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" ${DESPAWN_RATE_ITEMS_FAST_TICKS}
done
for MATERIAL in "golden" "iron"; do
    for ITEM in "axe" "boots" "chestplate" "helmet" "hoe" "leggings" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" ${DESPAWN_RATE_ITEMS_FAST_TICKS}
    done
done
for ITEM in "arrow" "bone" "rotten_flesh" "spider_eye" "string" "wheat_seeds"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.alt-item-despawn-rate.items.${ITEM}" ${DESPAWN_RATE_ITEMS_INSTANT_TICKS}
done
for ITEM in "boots" "chestplate" "helmet" "leggings"; do
    set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.leather_${ITEM}" ${DESPAWN_RATE_ITEMS_INSTANT_TICKS}
done
for MATERIAL in "wooden" "stone"; do
    for ITEM in "axe" "hoe" "pickaxe" "shovel" "sword"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" ${DESPAWN_RATE_ITEMS_INSTANT_TICKS}
    done
done

set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "environment.treasure-maps.enabled"    false # They cause too much lag eventually
