#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/messages.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

ensure-su-access

WEBMAP_PAGE_TITLE="${SERVER_NAME} World Map"

PLACEHOLDER_ARG0="{0}"
PLACEHOLDER_ARG1="{1}"
PLACEHOLDER_ARG2="{2}"
PLACEHOLDER_NAME_POINTY="<name>"
PLACEHOLDER_PLAYER="{PLAYER}"
PLACEHOLDER_PLAYER_PERCENT="%player%"
PLACEHOLDER_DISPLAYNAME="{DISPLAYNAME}"
PLACEHOLDER_MESSAGE="{MESSAGE}"
PLACEHOLDER_MESSAGE_PERCENT="%message%"
PLACEHOLDER_MESSAGE_POINTY="<message>"
PLACEHOLDER_NAME_PERCENT="%name%"
PLACEHOLDER_REPLY_PERCENT="%reply%"

if [ "${LOCALE}" == "ro" ]; then
    WEBMAP_PAGE_TITLE="Harta ${SERVER_NAME}"
    INVALID_COMMAND_MESSAGE="$(get_formatted_message error command Această comandă nu se poate executa)"
    JOIN_MESSAGE="$(get_action_message ${PLACEHOLDER_PLAYER} a intrat în joc)"

    set_config_value "${PURPUR_CONFIG_FILE}" "settings.messages.cannot-ride-mob" "$(get_formatted_message error mount Acest mob nu se poate călări)"
else
    WEBMAP_PAGE_TITLE="${SERVER_NAME} World Map"
    INVALID_COMMAND_MESSAGE="$(get_formatted_message error command This command cannot be executed)"
    JOIN_MESSAGE="$(get_action_message ${PLACEHOLDER_PLAYER} joined the game)"

    set_config_value "${PURPUR_CONFIG_FILE}" "settings.messages.cannot-ride-mob" "$(get_formatted_message error mount This mob cannot be mounted)"
fi

set_config_value "${SERVER_PROPERTIES_FILE}"            "max-players"                                               "${PLAYERS_MAX}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "view-distance"                                             "${VIEW_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "simulation-distance"                                       "${SIMULATION_DISTANCE}"
set_config_value "${SERVER_PROPERTIES_FILE}"            "enforce-secure-profile"                                    "${SIMULATION_DISTANCE}"

set_config_value "${SPIGOT_CONFIG_FILE}"                "messages.unknown-command"                                  "${INVALID_COMMAND_MESSAGE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.item-despawn-rate"                  "${DESPAWN_RATE_ITEMS_DEFAULT_TICKS}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.mob-spawn-range"                    "${MOB_SPAWN_RANGE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.simulation-distance"                "${SIMULATION_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.default.view-distance"                      "${VIEW_DISTANCE}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.simulation-distance"      "${SIMULATION_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_END_NAME}.view-distance"            "${VIEW_DISTANCE_END}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.simulation-distance"   "${SIMULATION_DISTANCE_NETHER}"
set_config_value "${SPIGOT_CONFIG_FILE}"                "world-settings.${WORLD_NETHER_NAME}.view-distance"         "${VIEW_DISTANCE_NETHER}"

set_config_value "${BUKKIT_CONFIG_FILE}"                'spawn-limits.monsters'                                     "${MOB_SPAWN_LIMIT_MONSTER}"

set_config_value "${PAPER_GLOBAL_CONFIG_FILE}"          'messages.no-permission' "$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})"
set_config_value "${PAPER_GLOBAL_CONFIG_FILE}"          'timings.server-name' "${SERVER_NAME}"
set_config_value "${PAPER_GLOBAL_CONFIG_FILE}"          'unsupported-settings.skip-vanilla-damage-tick-when-shield-blocked' true # Skip unnecessary tick to save a bit of performance # Note: This could cause rapid damage for the shields

set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "chunks.flush-regions-on-save"                          true
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.wandering-trader.spawn-chance-max"   125         
set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "entities.spawning.wandering-trader.spawn-day-length"   "${DAY_LENGTH_TICKS}"
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
set_config_value "${PURPUR_CONFIG_FILE}" 'world-settings.default.gameplay-mechanics.persistent-tileentity-display-names-and-lore'       true
set_config_value "${PURPUR_CONFIG_FILE}" 'world-settings.default.gameplay-mechanics.persistent-tileentity-display-name'                 true
set_config_value "${PURPUR_CONFIG_FILE}" 'world-settings.default.gameplay-mechanics.persistent-tileentity-lore'                         true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.player.exp-dropped-on-death.maximum"                100000
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.player.invulnerable-while-accepting-resource-pack"  true
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.player.shift-right-click-repairs-mending-points"    10
set_config_value "${PURPUR_CONFIG_FILE}" "world-settings.default.gameplay-mechanics.use-better-mending"                                 true

if is_plugin_installed "PurpurExtras"; then
    configure_plugin "PurpurExtras" config \
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

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "PurpurExtras" config \
            "settings.protect-blocks-with-loot.message" "$(get_formatted_message_minimessage error break_block Cuferele cu comori se pot distruge decât în timp ce ești ${COLOUR_HIGHLIGHT}aplecat)"
    else
        configure_plugin "PurpurExtras" config \
            "settings.protect-blocks-with-loot.message" "$(get_formatted_message_minimessage error break_block Treasure chests can only be broken while ${COLOUR_HIGHLIGHT}sneaking)"
    fi
fi

if is_plugin_installed 'AuthMe'; then
#        "settings.customJoinMessage" "$(sed 's/PLAYER/DISPLAYNAMENOCOLOR/g' <<< ${JOIN_MESSAGE})" \
    configure_plugin 'AuthMe' config \
        "Hooks.useEssentialsMotd" $(is_plugin_installed_bool 'EssentialsX') \
        'Security.console.logConsole' false \
        'Security.tempban.enableTempban' true \
        'Security.tempban.maxLoginTries' 6 \
        'Security.tempban.minutesBeforeCounterReset' 300 \
        'Security.tempban.tempbanLength' 240 \
        'settings.forceVaultHook' $(is_plugin_installed_bool 'Vault') \
        'settings.restrictions.DenyTabCompletionBeforeLogin' true \
        'settings.restrictions.displayOtherAccounts' false \
        'settings.restrictions.ProtectInventoryBeforeLogIn' $(is_plugin_installed_bool 'ProtocolLib') \
        "settings.serverName" "${SERVER_NAME}" \
        "settings.sessions.enabled" true \
        "settings.sessions.timeout" 960 \
        "settings.messagesLanguage" "${LOCALE}" \
        "settings.restrictions.teleportUnAuthedToSpawn" false \
        "settings.useAsyncTasks" true \
        "settings.useWelcomeMessage" $(is_plugin_not_installed_bool 'EssentialsX')

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "AuthMe" "$(get_plugin_dir AuthMe)/messages/messages_ro.yml" \
            "error.denied_chat" "$(get_formatted_message error auth Trebuie să te autentifici pentru a putea vorbi)" \
            "error.denied_command" "${INVALID_COMMAND_MESSAGE}" \
            "error.logged_in" "$(get_formatted_message error auth Ești autentificat deja)" \
            "login.command_usage" "$(get_formatted_message info auth Utilizare: ${COLOUR_COMMAND}/auth ${COLOUR_COMMAND}'<Parolă>')" \
            "login.login_request" "$(get_formatted_message error auth Trebuie să te autentifici pentru a putea juca.\\n${BULLETPOINT_LIST_MARKER}Folosește ${COLOUR_COMMAND}/auth ${COLOUR_COMMAND_ARGUMENT}'<Parolă>'${COLOUR_MESSAGE})" \
            "login.success" "$(get_formatted_message success auth Te-ai autentificat)" \
            "login.wrong_password" "$(get_formatted_message error auth Parola este greșită)" \
            "misc.logout" "$(get_formatted_message success auth Te-ai deautentificat)" \
            "misc.reload" "$(get_reload_message AuthMe)" \
            "password.match_error" "$(get_formatted_message error auth Parola de confirmare nu se potrivește)" \
            "registration.register_request" "$(get_formatted_message error auth Trebuie să te înregistrezi pentru a putea juca.\\n${BULLETPOINT_LIST_MARKER}Folosește ${COLOUR_COMMAND}/register ${COLOUR_COMMAND_ARGUMENT}'<Parolă>' '<ConfirmareaParolei>'${COLOUR_MESSAGE})" \
            "registration.success" "$(get_formatted_message success auth Te-ai înregistrat)" \
            "session.valid_session" "$(get_formatted_message success auth Te-ai autentificat automat de data trecută)"
    else
        configure_plugin "AuthMe" "$(get_plugin_dir AuthMe)/messages/messages_en.yml" \
            "error.denied_chat" "$(get_formatted_message error auth You must authenticate in order to chat)" \
            "error.denied_command" "${INVALID_COMMAND_MESSAGE}" \
            "error.logged_in" "$(get_formatted_message error auth You are already authenticated)" \
            "login.command_usage" "$(get_formatted_message info auth Usage: ${COLOUR_COMMAND}/auth ${COLOUR_COMMAND}'<Parolă>')" \
            "login.login_request" "$(get_formatted_message error auth You must authenticate in order to play.\\n${BULLETPOINT_LIST_MARKER}Use ${COLOUR_COMMAND}/auth ${COLOUR_COMMAND_ARGUMENT}'<Password>'${COLOUR_MESSAGE})" \
            "login.success" "$(get_formatted_message success auth You are now authenticated)" \
            "login.wrong_password" "$(get_formatted_message error auth The password is incorrect)" \
            "misc.logout" "$(get_formatted_message success auth You are now deauthenticated)" \
            "misc.reload" "$(get_reload_message AuthMe)" \
            "password.match_error" "$(get_formatted_message error auth The confirmation password does not match)" \
            "registration.register_request" "$(get_formatted_message error auth You must register in order to play.\\n${BULLETPOINT_LIST_MARKER}Use ${COLOUR_COMMAND}/register ${COLOUR_COMMAND_ARGUMENT}'<Password>' '<ConfirmPassword>'${COLOUR_MESSAGE})" \
            "registration.success" "$(get_formatted_message success auth You are now registered)" \
            "session.valid_session" "$(get_formatted_message success auth You authenticated automatically from the previous session)"
    fi
fi

if is_plugin_installed 'BestTools'; then
    configure_plugin 'BestTools' config \
        'besttools-enabled-by-default' true \
        'refill-enabled-by-default' true \
        'hotbar-only' false \
        'use-axe-as-sword' true

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'BestTools' config \
            'message-besttools-enabled' "$(get_formatted_message success tool Selectarea automată a uneltelor a fost ${COLOUR_HIGHLIGHT}activată)" \
            'message-besttools-disabled' "$(get_formatted_message success tool Selectarea automată a uneltelor a fost ${COLOUR_HIGHLIGHT}dezactivată)"
    else
        configure_plugin 'BestTools' config \
            'message-besttools-enabled' "$(get_formatted_message success tool Automatic tool selection has been ${COLOUR_HIGHLIGHT}enabled)" \
            'message-besttools-disabled' "$(get_formatted_message success tool Automatic tool selection has been ${COLOUR_HIGHLIGHT}disabled)"
    fi
fi

# Check Updates because we cannot auto-update this one
configure_plugin "CoreProtect" config \
    "check-updates" true

if is_plugin_installed "DeathMessages"; then
    configure_plugin "DeathMessages" config \
        "Add-Prefix-To-All-Messages" false \
        "Hooks.Discord.Enabled" "$(is_plugin_installed_bool DiscordSRV)" \
        "Hooks.MythicMobs.Enabled" "$(is_plugin_installed_bool MythicMobs)" \
        "Hooks.WorldGuard.Enabled" "$(is_plugin_installed_bool WorldGuard)"

    configure_plugin "DeathMessages" messages \
        "Commands.DeathMessages.No-Permission" "${INVALID_COMMAND_MESSAGE}" \
        "Commands.DeathMessages.Sub-Commands.Reload.Reloaded" "$(get_reload_message DeathMessages)" \
        "Discord.DeathMessage.Color" "BLACK" \
        "Discord.DeathMessage.Content" " " \
        "Discord.DeathMessage.Description" " " \
        "Discord.DeathMessage.Footer.Text" " " \
        "Discord.DeathMessage.Image" " " \
        "Discord.DeathMessage.Remove-Plugin-Prefix" true \
        "Discord.DeathMessage.Timestamp" false \
        "Discord.DeathMessage.Title" " " \
        "Prefix" "${COLOUR_RESET}"

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "DeathMessages" messages \
            "Mobs.Bat" "Liliac" \
            "Mobs.Skeleton" "Schelet"
    else
        configure_plugin "DeathMessages" messages \
            "Mobs.Bat" "Bat" \
            "Mobs.Skeleton" "Skeleton"
    fi
fi

if is_plugin_installed "DiscordSRV"; then
    configure_plugin "DiscordSRV" config \
        "ServerWatchdogEnabled" false \
        "UpdateCheckDisabled"   true

    configure_plugin "DiscordSRV" messages \
        "DiscordToMinecraftChatMessageFormat" "$(get_player_mention ${PLACEHOLDER_NAME_PERCENT})${COLOUR_CHAT}:${COLOUR_MESSAGE}${PLACEHOLDER_REPLY_PERCENT} ${COLOUR_CHAT}${PLACEHOLDER_MESSAGE_PERCENT}" \
        "MinecraftPlayerDeathMessage.Enabled" $(is_plugin_not_installed_bool DeathMessages)
fi

if is_plugin_installed 'DynamicLights'; then
    configure_plugin 'DynamicLights' config \
        'default-lock-state' false \
        'update-rate' 2

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'DynamicLights' messages \
            'language.disable-lock'          "$(get_formatted_message_minimessage success light Plasarea luminilor din mâna stângă a fost ${COLOUR_HIGHLIGHT}activată)" \
            'language.enable-lock'           "$(get_formatted_message_minimessage success light Plasarea luminilor din mâna stângă a fost ${COLOUR_HIGHLIGHT}dezactivată)" \
            'language.prevent-block-place'   "$(get_formatted_message_minimessage error light Plasarea luminilor din mâna stângă este ${COLOUR_HIGHLIGHT}dezactivată${COLOUR_MESSAGE})" \
            'language.reload'                "$(get_reload_message_minimessage DynamicLights)" \
            'language.toggle-off'            "$(get_formatted_message_minimessage success light Randarea luminilor dinamice a fost ${COLOUR_HIGHLIGHT}dezactivată)" \
            'language.toggle-on'             "$(get_formatted_message_minimessage success light Randarea luminilor dinamice a fost ${COLOUR_HIGHLIGHT}activată)"
    else
        configure_plugin 'DynamicLights' messages \
            'language.disable-lock'          "$(get_formatted_message_minimessage success light Placing light sources from the off-hand has been ${COLOUR_HIGHLIGHT}enabled)" \
            'language.enable-lock'           "$(get_formatted_message_minimessage success light Placing light sources from the off-hand has been ${COLOUR_HIGHLIGHT}disabled)" \
            'language.prevent-block-place'   "$(get_formatted_message_minimessage error light Placing items from the off-hand is currently ${COLOUR_HIGHLIGHT}diabled${COLOUR_MESSAGE})" \
            'language.reload'                "$(get_reload_message_minimessage DynamicLights)" \
            'language.toggle-off'            "$(get_formatted_message_minimessage success light The rendering of dynamic lights has been ${COLOUR_HIGHLIGHT}disabled)" \
            'language.toggle-on'             "$(get_formatted_message_minimessage success light The rendering of dynamic lights has been ${COLOUR_HIGHLIGHT}enabled)"
    fi
fi

configure_plugin "Dynmap" config \
    "max-sessions"                 5 \
    "disable-webserver"            true \
    "webserver-port"               25550 \
    "webpath"                      "${WEBMAP_DIR}" \
    "tilespath"                    "${WEBMAP_TILES_DIR}" \
    "webpage-title"                "${WEBMAP_PAGE_TITLE}" \
    \
    "allowchat"                    false \
    "allowwebchat"                 false \
    \
    "enabletilehash"               true \
    "tiles-rendered-at-once"       1 \
    "tileupdatedelay"              60 \
    "timesliceinterval"            0.5 \
    "maxchunkspertick"             90 \
    "renderacceleratethreshold"    30 \
    "updaterate"                   3000 \
    \
    "fullrender-min-tps"           19.5 \
    "update-min-tps"               19.0 \
    "zoomout-min-tps"              18.0 \
    \
    "fullrenderplayerlimit"        3 \
    "updateplayerlimit"            4 \
    \
    "smooth-lighting"              true \
    "image-format"                 'png' \
    "use-generated-textures"       false \
    "correct-water-lighting"       false \
    "transparent-leaves"           true \
    "ctm-support"                  false \
    "skinsrestorer-integration"    $(is_plugin_installed_bool 'SkinsRestorer') \
    "defaultzoom"                  6


if is_plugin_installed "EssentialsX"; then
    echo EssentialsX
    configure_plugin "EssentialsX" config \
        "auto-afk"                              300 \
        "auto-afk-kick"                         "${IDLE_KICK_TIMEOUT_SECONDS}" \
        "change-tab-complete-name"              true \
        "chat.format"                           "$(get_player_mention ${PLACEHOLDER_DISPLAYNAME}): ${COLOUR_CHAT}${PLACEHOLDER_MESSAGE}" \
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
        "per-player-locale"                     false \
        "per-warp-permissions"                  true \
        "remove-god-on-disconnect"              true \
        "teleport-cooldown"                     3 \
        "teleport-delay"                        3 \
        "teleport-invulnerability"              7 \
        "update-check"                          false \
        "unsafe-enchantments"                   true \
        "use-nbt-serialization-in-createkit"    true \
        "world-change-fly-reset"                false \
        "world-change-speed-reset"              false

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "EssentialsX" config \
            "custom-join-message"           "${JOIN_MESSAGE}" \
            "custom-quit-message"           "$(get_action_message ${PLACEHOLDER_PLAYER} a ieșit din joc)" \
            "custom-new-username-message"   "${JOIN_MESSAGE}" \
            "newbies.announce-format"       "$(get_announcement_message Bun venit $(get_player_mention ${PLACEHOLDER_DISPLAYNAME}) ${COLOUR_ANNOUNCEMENT}pe ${COLOUR_HIGHLIGHT}${SERVER_NAME})"

        create-file "${ESSENTIALS_DIR}/messages/messages_ro.properties"
        configure_plugin "EssentialsX" "${ESSENTIALS_DIR}/messages/messages_ro.properties" \
            "action"                            "$(get_action_message_minimessage ${PLACEHOLDER_ARG0} ${PLACEHOLDER_ARG1})" \
            "backAfterDeath"                    "$(get_formatted_message_minimessage info teleport Folosește ${COLOUR_COMMAND}/b ${COLOUR_MESSAGE}pentru a te întoarce unde ai murit)" \
            "backOther"                         "$(get_formatted_message_minimessage success teleport $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}s-a întors la locația anterioară)" \
            "backUsageMsg"                      "$(get_formatted_message_minimessage success teleport Te-ai întors la locația anterioară)" \
            "broadcast"                         "$(get_announcement_message_minimessage ${PLACEHOLDER_ARG0})" \
            "deleteHome"                        "$(get_formatted_message_minimessage success home Casa ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}a fost ștearsă)" \
            "deleteWarp"                        "$(get_formatted_message_minimessage success warp Warp-ul ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}a fost șters)" \
            'enchantmentApplied'                "$(get_formatted_message_minimessage success enchant Farmecul ${COLOUR_HIGHLIGHT}{PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}a fost aplicat)" \
            'enchantmentNotFound'               "$(get_formatted_message_minimessage error enchant The ${COLOUR_HIGHLIGHT}{PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}nu a fost găsit)" \
            'enchantmentRemoved'                "$(get_formatted_message_minimessage success enchant Farmecul ${COLOUR_HIGHLIGHT}{PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}a fost înlăturat)" \
            "errorWithMessage"                  "${PLACEHOLDER_ARG0}" \
            "essentialsReload"                  "$(get_reload_message_minimessage EssentialsX ${PLACEHOLDER_ARG0})" \
            "false"                             "$(covert_message_to_minimessage ${COLOUR_RED_DARK}nu${COLOUR_MESSAGE})" \
            "flyMode"                           "$(get_formatted_message_minimessage success gamemode Zborul ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}pentru $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            "gameMode"                          "$(get_formatted_message_minimessage success gamemode Modul de joc a fost schimbat la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}pentru $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            "godModeDisabledFor"                "$(convert_message_to_minimessage ${COLOUR_ERROR}dezactivat ${COLOUR_MESSAGE}pentru $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "godModeEnabledFor"                 "$(convert_message_to_minimessage ${COLOUR_SUCCESS}activat ${COLOUR_MESSAGE}pentru $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "godMode"                           "$(get_formatted_message_minimessage success gamemode Modul invincibil ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "homes"                             "$(get_formatted_message_minimessage info home Case: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "homeSet"                           "$(get_formatted_message_minimessage success home Casa a fost setată la locația curentă)" \
            "itemnameSuccess"                   "$(get_formatted_message_minimessage success other Obiectul din mână a fost redenumit în \"${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0}${COLOUR_MESSAGE}\")" \
            "kitResetOther"                     "$(get_formatted_message_minimessage info kit Perioada de așteptare a kit-ului ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}a fost resetată pentru $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            "listAmount"                        "$(get_formatted_message_minimessage info inspect Sunt ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}jucători online)" \
            "meRecipient"                       "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}eu)" \
            "meSender"                          "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}eu)" \
            "msgFormat"                         "$(get_formatted_message_minimessage info message $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_CHAT_PRIVATE}→ $(get_player_mention ${PLACEHOLDER_ARG1})${COLOUR_CHAT_PRIVATE}: ${COLOUR_CHAT_PRIVATE}${PLACEHOLDER_ARG2})" \
            "noAccessCommand"                   "$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})" \
            "noPendingRequest"                  "$(get_formatted_message_minimessage error player Nu ai nici o cerere în așteptare)" \
            "noPerm"                            "$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})" \
            "pendingTeleportCancelled"          "$(get_formatted_message_minimessage error player Cererea de teleportare în așteptare a fost anulată)" \
            "playerNeverOnServer"               "$(get_formatted_message_minimessage error inspect $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}nu a jucat niciodată pe ${COLOUR_HIGHLIGHT}${SERVER_NAME})" \
            "playerNotFound"                    "$(get_formatted_message_minimessage error other Jucătorul specificat nu este online)" \
            "playtime"                          "$(get_formatted_message_minimessage info inspect Ai petrecut un total de ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}jucându-te pe ${COLOUR_HIGHLIGHT}${SERVER_NAME})" \
            "playtimeOther"                     "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG1}) a petrecut un total de ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}jucându-se pe ${COLOUR_HIGHLIGHT}${SERVER_NAME})" \
            "requestAccepted"                   "$(get_formatted_message_minimessage success player Cererea de teleportare a fost acceptată)" \
            "requestAcceptedFrom"               "$(get_formatted_message_minimessage success player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}a acceptat cererea de telportare)" \
            "requestDenied"                     "$(get_formatted_message_minimessage error player Cererea de teleportare a fost respinsă)" \
            "requestDeniedFrom"                 "$(get_formatted_message_minimessage error player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE} ți-a respins cererea de teleportare)" \
            "requestSent"                       "$(get_formatted_message_minimessage info player Cererea de teleportare a fost trimisă către $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "requestSentAlready"                "$(get_formatted_message_minimessage error player Ai trimis deja o cerere de teleportare către $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "requestTimedOut"                   "$(get_formatted_message_minimessage error player Cererea de teleportare a expirat)" \
            "requestTimedOutFrom"               "$(get_formatted_message_minimessage error player Cererea de teleportare de la $(get_player_message ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}a expirat)" \
            "second"                            "secundă" \
            "seenOffline"                       "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}este ${COLOUR_RED_DARK}offline ${COLOUR_MESSAGE}de ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1})" \
            "seenOnline"                        "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}este ${COLOUR_GREEN_LIGHT}online ${COLOUR_MESSAGE}de ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1})" \
            "teleporting"                       "$(get_formatted_message_minimessage success teleport Teleportarea s-a realizat)" \
            "teleportBottom"                    "$(get_formatted_message_minimessage sucess teleport Te-ai teleportat la cea mai de ${COLOUR_HIGHLIGHT}jos ${COLOUR_MESSAGE}spațiu liber de la locația curentă)" \
            "teleportHereRequest"               "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}ți-a cerut să te teleportezi la locația sa)" \
            "teleportHome"                      "$(get_formatted_message_minimessage success home Te-ai teleportat la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "teleportRequest"                   "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}ți-a cerut să se teleporteze la locația ta)" \
            "teleportRequestSpecificCancelled"  "$(get_formatted_message_minimessage info player Cererea de teleportare către $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}a fost anulată)" \
            "teleportRequestTimeoutInfo"        "$(get_formatted_message_minimessage info player Această cerere va expira după ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} secunde)" \
            "teleportTop"                       "$(get_formatted_message_minimessage success teleport Te-ai teleportat la cea mai de ${COLOUR_HIGHLIGHT}sus ${COLOUR_MESSAGE}spațiu liber de la locația curentă)" \
            "teleportToPlayer"                  "$(get_formatted_message_minimessage success player Te-ai teleportat la $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "timeBeforeTeleport"                "$(get_formatted_message_minimessage error teleport Trebuie să aștepți ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}înainte de a te putea teleporta din nou)" \
            "tprSuccess"                        "$(get_formatted_message_minimessage error teleport Te-ai teleportat la o locație aleatorie)" \
            "true"                              "$(covert_message_to_minimessage ${COLOUR_GREEN_LIGHT}da${COLOUR_MESSAGE})" \
            "typeTpacancel"                     "$(get_formatted_message_minimessage info player Pentru a o anula, folosește ${COLOUR_COMMAND}/tpacancel)" \
            "typeTpaccept"                      "$(get_formatted_message_minimessage info player Pentru a o aproba, folosește ${COLOUR_COMMAND}/tpyes)" \
            "typeTpdeny"                        "$(get_formatted_message_minimessage info player Pentru a o respinge, folosește ${COLOUR_COMMAND}/tpno)" \
            "unsafeTeleportDestination"         "$(get_formatted_message_minimessage error teleport Destinația aleasă pentru teleportare nu poate să fie setată deoarece nu este sigură)" \
            "vanish"                            "$(get_formatted_message_minimessage success gamemode Modul invizibil ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1} ${COLOUR_MESSAGE}pentru $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "vanished"                          "" \
            "warpingTo"                         "$(get_formatted_message_minimessage success warp Te-ai teleportat la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "warpsCount"                        "$(get_formatted_message_minimessage info warp Există ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}de warp-uri. Pagina ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1}${COLOUR_MESSAGE}/${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG2})" \
            "warpNotExist"                      "$(get_formatted_message_minimessage error warp Destinația specificată nu este validă)" \
            "warpSet"                           "$(get_formatted_message_minimessage success warp Warp-ul ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}a fost setat la locația curentă)" \
            "warpUsePermission"                 "$(get_formatted_message_minimessage error warp Destinația specificată nu este validă)" \
            "whoisTop"                          "$(get_formatted_message_minimessage success inspect Informații despre $(get_player_mention ${PLACEHOLDER_ARG0}):)" \
            "whoisExp"                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Experiență: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisFly"                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Zbor: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisGamemode"                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Mod de joc: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisGod"                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Invincibilitate: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisHealth"                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Viață: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisHunger"                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Foame: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisJail"                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Arestat: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisLocation"                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Locație: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisMoney"                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Bani: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisNick"                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Nume: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisOp"                           "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Operator: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisPlaytime"                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Timp petrecut în joc: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisSpeed"                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Viteză: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisUuid"                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Identificator: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})"
    else
        configure_plugin "EssentialsX" "${ESSENTIALS_CONFIG_FILE}" \
            "custom-join-message"           "${JOIN_MESSAGE}" \
            "custom-quit-message"           "$(get_action_message ${PLACEHOLDER_PLAYER} left the game)" \
            "custom-new-username-message"   "${JOIN_MESSAGE}" \
            "newbies.announce-format"       "$(get_announcement_message Welcome $(get_player_mention ${PLACEHOLDER_DISPLAYNAME}) ${COLOUR_ANNOUNCEMENT}to ${COLOUR_HIGHLIGHT}${SERVER_NAME})"

        create-file "${ESSENTIALS_DIR}/messages/messages_en.properties"
        configure_plugin "EssentialsX" "${ESSENTIALS_DIR}/messages/messages_en.properties" \
            "action"                            "$(get_action_message_minimessage ${PLACEHOLDER_ARG0} ${PLACEHOLDER_ARG1})!" \
            "backAfterDeath"                    "$(get_formatted_message_minimessage info teleport Use ${COLOUR_COMMAND}/b ${COLOUR_MESSAGE}to return to your death location)" \
            "backOther"                         "$(get_formatted_message_minimessage success teleport Returned $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}to their preivous location)" \
            "backUsageMsg"                      "$(get_formatted_message_minimessage success teleport Returned to your previous location)" \
            "broadcast"                         "$(get_announcement_message_minimessage ${PLACEHOLDER_ARG0})" \
            "deleteHome"                        "$(get_formatted_message_minimessage success home Home ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}has been deleted)" \
            "deleteWarp"                        "$(get_formatted_message_minimessage success warp Warp ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}has been deleted)" \
            'enchantmentApplied'                "$(get_formatted_message_minimessage success enchant The ${COLOUR_HIGHLIGHT}{PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}enchantment has been applied)" \
            'enchantmentNotFound'               "$(get_formatted_message_minimessage error enchant The ${COLOUR_HIGHLIGHT}{PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}has not been found)" \
            'enchantmentRemoved'                "$(get_formatted_message_minimessage success enchant The ${COLOUR_HIGHLIGHT}{PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}enchantment has been removed)" \
            "errorWithMessage"                  "${PLACEHOLDER_ARG0}" \
            "essentialsReload"                  "$(get_reload_message_minimessage EssentialsX ${PLACEHOLDER_ARG0})" \
            "false"                             "$(covert_message_to_minimessage ${COLOUR_RED_DARK}no${COLOUR_MESSAGE})" \
            "flyMode"                           "$(get_formatted_message_minimessage success gamemode Flight ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            "gameMode"                          "$(get_formatted_message_minimessage success gamemode Game mode changed to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            "godModeDisabledFor"                "$(convert_message_to_minimessage ${COLOUR_ERROR}disabled ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "godModeEnabledFor"                 "$(convert_message_to_minimessage ${COLOUR_SUCCESS}enabled ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "godMode"                           "$(get_formatted_message_minimessage success gamemode Invincibility ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "homes"                             "$(get_formatted_message_minimessage success home Homes: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "homeSet"                           "$(get_formatted_message_minimessage success home Home set at the current location)" \
            "itemnameSuccess"                   "$(get_formatted_message_minimessage success other The held item has been renamed to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "kitResetOther"                     "$(get_formatted_message_minimessage info kit The cooldown for kit ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}has been reset for $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            "listAmount"                        "$(get_formatted_message_minimessage info inspect There are ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}players online)" \
            "meRecipient"                       "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}me)" \
            "meSender"                          "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}me)" \
            "msgFormat"                         "$(get_formatted_message_minimessage info message $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_CHAT_PRIVATE}→ $(get_player_mention ${PLACEHOLDER_ARG1})${COLOUR_CHAT_PRIVATE}: ${COLOUR_CHAT_PRIVATE}${PLACEHOLDER_ARG2})" \
            "noAccessCommand"                   "$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})" \
            "noPendingRequest"                  "$(get_formatted_message_minimessage error player There are no pending requests)" \
            "noPerm"                            "$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})" \
            "pendingTeleportCancelled"          "$(get_formatted_message_minimessage error player Cererea de teleportare în așteptare a fost anulată)" \
            "playerNeverOnServer"               "$(get_formatted_message_minimessage error inspect $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}never played on ${COLOUR_HIGHLIGHT}${SERVER_NAME})" \
            "playerNotFound"                    "$(get_formatted_message_minimessage error other The specified player is not online)" \
            "playtime"                          "$(get_formatted_message_minimessage info inspect You spent a total of ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}playing on ${COLOUR_HIGHLIGHT}${SERVER_NAME})" \
            "playtimeOther"                     "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG1}) spent a total of ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}playing on ${COLOUR_HIGHLIGHT}${SERVER_NAME})" \
            "requestAccepted"                   "$(get_formatted_message_minimessage success player Teleportation request accepted)" \
            "requestAcceptedFrom"               "$(get_formatted_message_minimessage success player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}accepted your teleportation request)" \
            "requestDenied"                     "$(get_formatted_message_minimessage error player Teleportation request denied)" \
            "requestDeniedFrom"                 "$(get_formatted_message_minimessage error player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE} denied your teleportation request)" \
            "requestSent"                       "$(get_formatted_message_minimessage info player Teleportation request sent to $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "requestSentAlready"                "$(get_formatted_message_minimessage error player You have already sent a teleportatin request to $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "requestTimedOut"                   "$(get_formatted_message_minimessage error player The teleportation request has timed out)" \
            "requestTimedOutFrom"               "$(get_formatted_message_minimessage error player The teleportation request from $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}has timed out)" \
            "seenOffline"                       "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}has been ${COLOUR_RED_DARK}offline ${COLOUR_MESSAGE}for ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1})" \
            "seenOnline"                        "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}has been ${COLOUR_GREEN_LIGHT}online ${COLOUR_MESSAGE}for ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1})" \
            "teleporting"                       "$(get_formatted_message_minimessage success teleport Teleported successfully)" \
            "teleportBottom"                    "$(get_formatted_message_minimessage success teleport Teleported to the ${COLOUR_HIGHLIGHT}lowest ${COLOUR_MESSAGE}empty space at your current location)" \
            "teleportHereRequest"               "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}asked you to teleport to them)" \
            "teleportRequestSpecificCancelled"  "$(get_formatted_message_minimessage info player Teleportation request with $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}cancelled)" \
            "teleportRequestTimeoutInfo"        "$(get_formatted_message_minimessage info player This request will time out after ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} seconds)" \
            "teleportHome"                      "$(get_formatted_message_minimessage success home Teleported to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "teleportRequest"                   "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}asked you to let them teleport to you)" \
            "teleportTop"                       "$(get_formatted_message_minimessage success teleport Teleported to the ${COLOUR_HIGHLIGHT}highest ${COLOUR_MESSAGE}empty space at your current location)" \
            "teleportToPlayer"                  "$(get_formatted_message_minimessage success player Teleported to $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "timeBeforeTeleport"                "$(get_formatted_message_minimessage error teleport You must wait ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}before teleporting again)" \
            "tprSuccess"                        "$(get_formatted_message_minimessage success teleport Teleported to a random location)" \
            "true"                              "$(covert_message_to_minimessage ${COLOUR_GREEN_LIGHT}yes${COLOUR_MESSAGE})" \
            "typeTpacancel"                     "$(get_formatted_message_minimessage info player To cancel it, use ${COLOUR_COMMAND}/tpacancel)" \
            "typeTpaccept"                      "$(get_formatted_message_minimessage info player To approve it, use ${COLOUR_COMMAND}/tpyes)" \
            "typeTpdeny"                        "$(get_formatted_message_minimessage info player To deny this request, use ${COLOUR_COMMAND}/tpno)" \
            "unsafeTeleportDestination"         "$(get_formatted_message_minimessage error teleport The chosen teleportation target could not be set because it is not safe)" \
            "vanish"                            "$(get_formatted_message_minimessage success gamemode Invisible mode ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1} ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            "vanished"                          "" \
            "warpingTo"                         "$(get_formatted_message_minimessage success warp Teleported to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "warpNotExist"                      "$(get_formatted_message_minimessage error warp The specified warp is invalid)" \
            "warpsCount"                        "$(get_formatted_message_minimessage info warp There are ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}warps. Page ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1}${COLOUR_MESSAGE}/${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG2})" \
            "warpSet"                           "$(get_formatted_message_minimessage success warp Warp ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}set at the current location)" \
            "warpUsePermission"                 "$(get_formatted_message_minimessage error warp The specified warp is invalid)" \
            "whoisTop"                          "$(get_formatted_message_minimessage success inspect Informații despre $(get_player_mention ${PLACEHOLDER_ARG0}):)" \
            "whoisExp"                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Experience: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisFly"                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Flight: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisGamemode"                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Gamemode: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisGod"                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Invincibility: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisHealth"                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Health: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisHunger"                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Hunger: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisJail"                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Jailed: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisLocation"                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Location: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisMoney"                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Money: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisNick"                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Name: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisOp"                           "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Operator: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisPlaytime"                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Time spent in-game: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisSpeed"                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Speed: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "whoisUuid"                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Identifier: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})"
    fi
fi

if is_plugin_installed "GSit"; then
    configure_plugin "GSit" config \
        "Options.check-for-update" false

    configure_plugin "GSit" "$(get_plugin_dir GSit)/lang/en_en.yml" \
        "Messages.command-permission-error" "$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})" \
        "Messages.command-sender-error" "$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})" \
        "Plugin.plugin-reload" "$(get_reload_message_minimessage GSit)"
fi

configure_plugin "InvSee++" config \
    "enable-unknown-player-support" false

if is_plugin_installed "InvUnload"; then
    INVUNLOAD_COOLDOWN=2
    configure_plugin "InvUnload" config \
        'check-for-updates'         false \
        'default-chest-radius'      16 \
        'cooldown'                  "${INVUNLOAD_COOLDOWN}" \
        'ignore-blocked-chests'     false \
        'laser-animation'           false \
        'laser-default-duration'    5 \
        'max-chest-radius'          32 \
        'message-prefix'            "${COLOUR_RESET}" \
        'particle-type'             'WITCH'

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "InvUnload" config \
            "message-cooldown" "$(get_formatted_message error inventory Trebuie să aștepți ${COLOUR_HIGHLIGHT}${INVUNLOAD_COOLDOWN} secunde${COLOUR_MESSAGE} de la ultima golire)" \
            "message-could-not-unload" "$(get_formatted_message error inventory Nu au fost găsite containere pentru restul obiectelor)" \
            "message-error-not-a-number" "$(get_formatted_message error inventory Distanța specificată nu este un număr valid)" \
            "message-inventory-empty" "$(get_formatted_message error inventory Inventarul tău este deja gol)" \
            "message-no-chests-nearby" "$(get_formatted_message error inventory Nu există containere de depozitare în apropriere)" \
            "message-radius-too-high" "$(get_formatted_message error inventory Distanța poate să fie maximum ${COLOUR_HIGHLIGHT}%d${COLOUR_MESSAGE} blocuri)"
    else
        configure_plugin "InvUnload" config \
            "message-cooldown" "$(get_formatted_message error inventory You must wait ${COLOUR_HIGHLIGHT}${INVUNLOAD_COOLDOWN} seconds${COLOUR_MESSAGE} since the last unload)" \
            "message-could-not-unload" "$(get_formatted_message error inventory There are no containers for the remaining items)" \
            "message-error-not-a-number" "$(get_formatted_message error inventory The specified distance is not a valid number)" \
            "message-inventory-empty" "$(get_formatted_message error inventory Your inventory is already empty)" \
            "message-no-chests-nearby" "$(get_formatted_message error inventory There are no storage containers nearby)" \
            "message-radius-too-high" "$(get_formatted_message error inventory The distance can be at most ${COLOUR_HIGHLIGHT}%d${COLOUR_MESSAGE} blocks)"
    fi
fi

configure_plugin "LuckPerms" config \
    "resolve-comman-selectors" true \
    "use-server-uuid-cache" true \
    "watch-files" false

if is_plugin_installed "OldCombatMechanics"; then
    configure_plugin "OldCombatMechanics" config \
        "disable-chorus-fruit.enabled" true \
        "disable-crafting.enabled" false \
        "disable-enderpearl-cooldown.enabled" false \
        "disable-offhand.enabled" false \
        "disable-sword-sweep.enabled" false \
        "message-prefix" "§" \
        "update-checker.auto-update" false \
        "update-checker.enabled" false

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "OldCombatMechanics" config \
            "disable-offhand.denied-message" "$(get_formatted_message error combat Modul de luptă actual nu permite obiecte în mâna stângă)" \
            "mode-messages.invalid-modeset" "$(get_formatted_message error combat Modul de luptă specificat nu este valid)" \
            "mode-messages.invalid-player" "$(get_formatted_message error combat Jucătorul specificat nu este valid)" \
            "mode-messages.message-usage" "$(get_formatted_message info combat Îți poți schimba modul de luptă folosind ${COLOUR_COMMAND}/ocm mode ${COLOUR_COMMAND_ARGUMENT}'<Mod>' [Jucător])" \
            "mode-messages.mode-set" "$(get_formatted_message error combat Modul de luptă a fost schimbat la ${COLOUR_HIGHLIGHT}%s)" \
            "mode-messages.mode-status" "$(get_formatted_message info combat Modul de luptă actual: ${COLOUR_HIGHLIGHT}%s)" \
            "old-golden-apples.message-enchanted" "$(get_formatted_message error combat Trebuie să aștepți ${COLOUR_HIGHLIGHT}%seconds% ${COLOUR_MESSAGE}înainte să poți mânca alt ${COLOUR_PINK}Măr Auriu Fermecat)" \
            "old-golden-apples.message-normal" "$(get_formatted_message error combat Trebuie să aștepți ${COLOUR_HIGHLIGHT}%seconds% ${COLOUR_MESSAGE}înainte să poți mânca alt ${COLOUR_AQUA}Măr Auriu)"
    else
        configure_plugin "OldCombatMechanics" config \
            "disable-offhand.denied-message" "$(get_formatted_message error combat The current combat mode does not allow items in the off-hand slot)" \
            "mode-messages.invalid-modeset" "$(get_formatted_message error combat The specified combat mode is invalid)" \
            "mode-messages.invalid-player" "$(get_formatted_message error combat The specified player is invalid)" \
            "mode-messages.message-usage" "$(get_formatted_message info combat You can change your combat mode using ${COLOUR_COMMAND}/ocm mode ${COLOUR_COMMAND_ARGUMENT}'<Mode>' [Player])" \
            "mode-messages.mode-set" "$(get_formatted_message success combat Your combat mode has been set to ${COLOUR_HIGHLIGHT}%s)" \
            "mode-messages.mode-status" "$(get_formatted_message info combat Your current combat mode is ${COLOUR_HIGHLIGHT}%s)" \
            "old-golden-apples.message-enchanted" "$(get_formatted_message error combat You must wait ${COLOUR_HIGHLIGHT}%seconds% ${COLOUR_MESSAGE}before eating another ${COLOUR_PINK}Enchanted Golden Apple)" \
            "old-golden-apples.message-normal" "$(get_formatted_message error combat You must wait ${COLOUR_HIGHLIGHT}%seconds% ${COLOUR_MESSAGE}before eating another ${COLOUR_AQUA}Golden Apple)"
    fi
fi

if is_plugin_installed "PaperTweaks"; then
    set_config_values config \
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

    configure_plugin "PaperTweaks" "${PAPERTWEAKS_DIR}/i18n/en.properties" \
        "command.reload.all.reloaded.success" "$(get_reload_message PaperTweaks)"
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
        "world-settings.default.map.zoom.max-out" 1
fi

if is_plugin_installed "SkinsRestorer"; then
    configure_plugin "SkinsRestorer" config \
        "SkinExpiresAfter" 180

    if [ "${LOCALE}" == "ro" ]; then
        copy-file-if-needed "${SKINSRESTORER_DIR}/locales/repository/locale_ro.json" "${SKINSRESTORER_DIR}/locales/custom/locale_ro.json"
        configure_plugin "SkinsRestorer" "${SKINSRESTORER_DIR}/locales/custom/locale.json" \
            "skinsrestorer..prefix_format" "$(convert_message_to_minimessage ${COLOUR_MESSAGE}${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_generic" "$(get_formatted_message_minimessage error skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_invalid_urlskin" "$(get_formatted_message_minimessage error skin URL-ul sau formatul skin-ului este invalid. Asigură-te că se termină cu ${COLOUR_HIGHLIGHT}.png${COLOUR_MESSAGE})" \
            "skinsrestorer..ms_uploading_skin" "$(get_formatted_message_minimessage info skin Se încarcă skin-ul...)" \
            "skinsrestorer..success_admin_reload" "$(get_reload_message_minimessage SkinsRestorer)" \
            "skinsrestorer..success_generic" "$(get_formatted_message_minimessage success skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..success_skin_change" "$(get_formatted_message_minimessage success skin Skin-ul tău a fost schimbat)" \
            "skinsrestorer..success_skin_change_other" "$(get_formatted_message_minimessage success skin Skin-ul lui $(get_player_mention ${PLACEHOLDER_NAME_POINTY}) a fost schimbat)" \
            "skinsrestorer..success_skin_clear" "$(get_formatted_message_minimessage success skin Skin-ul tău a fost scos)" \
            "skinsrestorer..success_updating_skin" "$(get_formatted_message_minimessage success skin Skin-ul tău a fost actualizat)" \
            "skinsrestorer..success_updating_skin_other" "$(get_formatted_message_minimessage success skin Skin-ul lui $(get_player_mention ${PLACEHOLDER_NAME_POINTY}) a fost actualizat)"
    else
        copy-file-if-needed "${SKINSRESTORER_DIR}/locales/repository/locale.json" "${SKINSRESTORER_DIR}/locales/custom/locale.json"
        configure_plugin "SkinsRestorer" "${SKINSRESTORER_DIR}/locales/custom/locale.json" \
            "skinsrestorer..prefix_format" "$(convert_message_to_minimessage ${COLOUR_MESSAGE}${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_generic" "$(get_formatted_message_minimessage error skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_invalid_urlskin" "$(get_formatted_message_minimessage error skin The skin\'s URL or format is invalid. Make sure it ends with ${COLOUR_HIGHLIGHT}.png${COLOUR_MESSAGE})" \
            "skinsrestorer..ms_uploading_skin" "$(get_formatted_message_minimessage info skin Uploading the skin...)" \
            "skinsrestorer..success_admin_reload" "$(get_reload_message_minimessage SkinsRestorer)" \
            "skinsrestorer..success_generic" "$(get_formatted_message_minimessage success skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..success_skin_change" "$(get_formatted_message_minimessage success skin Your skin has been changed)" \
            "skinsrestorer..success_skin_change_other" "$(get_formatted_message_minimessage success skin $(get_player_mention ${PLACEHOLDER_NAME_POINTY})\'s skin has been changed)" \
            "skinsrestorer..success_skin_clear" "$(get_formatted_message_minimessage success skin Your skin has been cleared)" \
            "skinsrestorer..success_updating_skin" "$(get_formatted_message_minimessage success skin Your skin has been updated)" \
            "skinsrestorer..success_updating_skin_other" "$(get_formatted_message_minimessage success skin $(get_player_mention ${PLACEHOLDER_NAME_POINTY})\'s skin has been updated)"
    fi
fi

configure_plugin "spark" config \
    "backgroundProfiler" false

configure_plugin "StackableItems" config \
    "update-check.enabled" false

if is_plugin_installed "SuperbVote"; then
    configure_plugin "SuperbVote" config \
        "queue-votes"           true \
        "require-online"        false \
        "storage.database"      "json" \
        "streaks.enabled"       true \
        "vote-reminder.repeat"  "${VOTE_REMINDER_INTERVAL_SECONDS}"

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "SuperbVote" config \
            "vote-reminder.message" "$(get_formatted_message info vote ${COLOUR_GREEN_LIGHT}Memo: ${COLOUR_MESSAGE}Ia-ți recompensele zilnice votând serverul! Folosește ${COLOUR_COMMAND}/vote)"
    else
        configure_plugin "SuperbVote" config \
            "vote-reminder.message" "$(get_formatted_message info vote ${COLOUR_GREEN_LIGHT}Reminder: ${COLOUR_MESSAGE}Claim your daily rewards by voting the server! Use ${COLOUR_COMMAND}/vote)"
    fi
fi

configure_plugin "TAB" messages \
    "no-permission" "${INVALID_COMMAND_MESSAGE}" \
    "reload-success" "$(get_reload_message TAB)"

if is_plugin_installed "TradeShop"; then
    # TODO: check-updates to false once it can be updated via script
    configure_plugin "TradeShop" config \
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
        configure_plugin "TradeShop" config \
            "language-options.shop-closed-status" "${COLOUR_ERROR}<Închis>" \
            "language-options.shop-incomplete-status" "${COLOUR_ERROR}<Invalid>" \
            "language-options.shop-open-status" "${COLOUR_SUCCESS}<Deschis>" \
            "language-options.shop-outofstock-status" "${COLOUR_ERROR}<Stoc Insuficient>"
            
        configure_plugin "TradeShop" messages \
            "change-closed" "$(get_formatted_message success trade Oferta a fost dezactivată)" \
            "change-open" "$(get_formatted_message success trade Oferta a fost activată)" \
            "insufficient-items" "$(get_formatted_message error trade Îți lipsesc următoarele obiecte:\\n{%MISSINGITEMS%=  ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "item-added" "$(get_formatted_message success trade Obiectul a fost adăugat la ofertă)" \
            "item-not-removed" "$(get_formatted_message error trade Obiectul nu s-a putut scoate de la ofertă)" \
            "item-removed" "$(get_formatted_message success trade Obiectul a fost scos de la ofertă)" \
            "no-sighted-shop" "$(get_formatted_message error trade Nu s-a găsit nici o ofertă)" \
            "no-ts-create-permission" "$(get_formatted_message error trade Nu poți crea acest tip de ofertă)" \
            "no-ts-open" "$(get_formatted_message error trade Nu poți deschide această ofertă)" \
            "on-trade" "$(get_formatted_message success trade Ai cumpărat {%RECEIVEDLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%} ${COLOUR_MESSAGE}cu {%GIVENLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "player-full" "$(get_formatted_message error trade Ai inventarul plin)" \
            "shop-closed" "$(get_formatted_message error trade Această ofertă nu este activă)" \
            "shop-empty" "$(get_formatted_message error trade Această ofertă nu are stoc suficient)" \
            "shop-full" "$(get_formatted_message error trade Această ofertă nu are spațiu suficient în inventar)" \
            "shop-insufficient-items" "$(get_formatted_message error trade Această ofertă nu are stoc suficient)" \
            "successful-setup" "$(get_formatted_message success trade Ai creat cu succes o ofertă de vânzare)"
    else
        configure_plugin "TradeShop" config \
            "language-options.shop-closed-status" "${COLOUR_ERROR}<Closed>" \
            "language-options.shop-incomplete-status" "${COLOUR_ERROR}<Invalid>" \
            "language-options.shop-open-status" "${COLOUR_SUCCESS}<Open>" \
            "language-options.shop-outofstock-status" "${COLOUR_ERROR}<Out of Stock>"

        configure_plugin "TradeShop" messages \
            "change-closed" "$(get_formatted_message success trade The offer was disabled)" \
            "change-open" "$(get_formatted_message success trade The offer was enabled)" \
            "insufficient-items" "$(get_formatted_message error trade You are missing the following items:\\n{%MISSINGITEMS%=  ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "item-added" "$(get_formatted_message success trade The item was added to the offer)" \
            "item-not-removed" "$(get_formatted_message error trade The item could not be removed from the offer)" \
            "item-removed" "$(get_formatted_message success trade The item was removed from the offer)" \
            "no-sighted-shop" "$(get_formatted_message error trade Could not find any offer in range)" \
            "no-ts-create-permission" "$(get_formatted_message error You cannot create this type of offer)" \
            "no-ts-open" "$(get_formatted_message error trade You cannot open this type of offer)" \
            "on-trade" "$(get_formatted_message info trade You bought:\\n{%RECEIVEDLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%}\n${COLOUR_MESSAGE}for:\n{%GIVENLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "player-full" "$(get_formatted_message error trade Your inventory is full)" \
            "shop-closed" "$(get_formatted_message error trade This offer is not active)" \
            "shop-empty" "$(get_formatted_message error trade This offer is out of stock)" \
            "shop-full" "$(get_formatted_message error trade This offer\'s inventory is full)" \
            "shop-insufficient-items" "$(get_formatted_message error trade This offer is out of stock)" \
            "successful-setup" "$(get_formatted_message success trade You have successfully set up a trade offer)"
    fi
fi

if is_plugin_installed "TreeAssist"; then
    # Integrations
    is_plugin_installed "CoreProtect" && set_config_value "$(get_plugin_file TreeAssist config)" "Placed Blocks.Plugin Name" "CoreProtect"
    for PLUGIN_NAME in "AureliumSkills" "CustomEvents" "Jobs" "mcMMO" "WorldGuard"; do
        set_config_value "$(get_plugin_file TreeAssist config)" "Plugins.${PLUGIN_NAME}" "$(is_plugin_installed_bool ${PLUGIN_NAME})"
    done

    configure_plugin "TreeAssist" config \
        "bStats.Active"                     false \
        "bStats.Full"                       false \
        "Destruction.Falling Blocks"        true \
        "Destruction.Falling Blocks Fancy"  false \
        "General.Toggle Remember"           false \
        "General.Use Permissions"           true
fi

configure_plugin "Vault" config \
    "update-check" false

configure_plugin "ViaVersion" config \
    "check-for-updates" false
    
configure_plugin "ViewDistanceTweaks" config \
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
    configure_plugin "VotingPlugin" config \
        "OnlineMode"                    "${ONLINE_MODE}" \
        "TreatVanishAsOffline"          true \
        "VoteReminding.RemindOnlyOnce"  false \
        "VoteReminding.RemindDelay"     "${VOTE_REMINDER_INTERVAL_MINUTES}"

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "VotingPlugin" config \
            "Format.BroadcastMsg"  "$(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT}) ${COLOUR_ACTION}a fost recompensat pentru votul pe ${COLOUR_HIGHLIGHT}%SiteName%${COLOUR_ACTION}." \
            "VoteReminding.Rewards.Messages.Player"  "${COLOUR_MESSAGE}Încă mai ai ${COLOUR_HIGHLIGHT}%sitesavailable% site-uri ${COLOUR_MESSAGE}pe care să votezi."
    else
        configure_plugin "VotingPlugin" config \
            "Format.BroadcastMsg"  "$(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT}) ${COLOUR_ACTION}was rewarded for voting on ${COLOUR_HIGHLIGHT}%SiteName%${COLOUR_ACTION}." \
            "VoteReminding.Rewards.Messages.Player"  "${COLOUR_MESSAGE}You have ${COLOUR_HIGHLIGHT}%sitesavailable% sites ${COLOUR_MESSAGE}left to vote on."
    fi
fi

if is_plugin_installed "WanderingTrades"; then
    configure_plugin "WanderingTrades" config \
    	"updateChecker" false \
    	"language" "${LOCALE_FULL}"

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "WanderingTrades" "$(get_plugin_dir WanderingTrades)/lang/ro_RO.yml" \
            "command.reload.message" "$(get_formatted_message_minimessage info plugin Se reîncarcă ${COLOUR_PLUGIN}WanderingTrades${COLOUR_MESSAGE}...)"
    else
        configure_plugin "WanderingTrades" "$(get_plugin_dir WanderingTrades)/lang/en_US.yml" \
            "command.reload.message" "$(get_formatted_message_minimessage info plugin Reloading ${COLOUR_PLUGIN}WanderingTrades${COLOUR_MESSAGE}...)"
    fi
fi

if is_plugin_installed "FastAsyncWorldEdit"; then
    configure_plugin "FastAsyncWorldEdit" config \
        "enabled-components.update-notifications" false \
        "max-memory-percent" 85 \
        "queue.parallel-threads" "${CPU_THREADS_HALF}" \
        "queue.target-size" $((CPU_THREADS_HALF * 5))

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "FastAsyncWorldEdit" messages \
            "prefix"                                                "${COLOUR_MESSAGE}${PLACEHOLDER_ARG0}" \
            "fawe..error.no-perm"                                   "${INVALID_COMMAND_MESSAGE}" \
            "fawe..worldedit..copy..command..copy"                  "$(get_formatted_message success worldedit Au fost copiate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..command..time-elapsed"                      "$(get_formatted_message info worldedit Au trecut ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} secunde ${COLOUR_MESSAGE}modificând ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1} blocuri${COLOUR_MESSAGE}, cu viteza de ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG2} blocuri/s)" \
            "worldedit..contract..contracted"                       "$(get_formatted_message success worldedit Selecția a fost scurtată cu ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..count..counted"                             "$(get_formatted_message success worldedit Au fost numărate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..error..incomplete-region"                   "$(get_formatted_message error worldedit Nu s-a făcut nici o selecție)" \
            "worldedit..expand..expanded"                           "$(get_formatted_message success worldedit Selecția a fost extinsă cu ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..expand..expanded..vert"                     "$(get_formatted_message success worldedit Selecția a fost extinsă cu ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..line..changed"                              "$(get_formatted_message success worldedit Au fost schimbate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..move..moved"                                "$(get_formatted_message success worldedit Au fost mutate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..pos..already-set"                           "$(get_formatted_message error worldedit Poziția a fost deja setată)" \
            "worldedit..redo..none"                                 "$(get_formatted_message error worldedit Nu există modificări de refăcut)" \
            "worldedit..redo..redone"                               "$(get_formatted_message success worldedit S-au refăcut ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} modificări)" \
            "worldedit..reload..config"                             "$(get_reload_message FastAsyncWorldEdit)" \
            "worldedit..select..cleared"                            "$(get_formatted_message success worldedit Selecția a fost ștearsă)" \
            "worldedit..selection..cuboid..explain..primary"        "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 1 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..primary-area"   "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 1 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary"      "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 2 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary-area" "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 2 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..set..done"                                  "$(get_formatted_message success worldedit Au fost schimbate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..shift..shifted"                             "$(get_formatted_message success worldedit Selecția a fost mutată)" \
            "worldedit..size..blocks"                               "$(get_formatted_message info worldedit Blocuri: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..distance"                             "$(get_formatted_message info worldedit Distanță: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..size"                                 "$(get_formatted_message info worldedit Dimensiune: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..type"                                 "$(get_formatted_message info worldedit Tip: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..undo..none"                                 "$(get_formatted_message error worldedit Nu există modificări de anulat)" \
            "worldedit..undo..undone"                               "$(get_formatted_message success worldedit S-au anulat ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} modificări)" \
            "worldedit..wand..selwand..info"                        "$(get_formatted_message info worldedit ${COLOUR_COMMAND}Click Stânga ${COLOUR_MESSAGE}setează ${COLOUR_HIGHLIGHT}Poziția 1${COLOUR_MESSAGE}, ${COLOUR_COMMAND}Click Dreapta ${COLOUR_MESSAGE}setează ${COLOUR_HIGHLIGHT}Poziția 2)"
    else
        configure_plugin "FastAsyncWorldEdit" messages \
            "prefix"                                                "${COLOUR_MESSAGE}${PLACEHOLDER_ARG0}" \
            "fawe..error.no-perm"                                   "${INVALID_COMMAND_MESSAGE}" \
            "fawe..worldedit..copy..command..copy"                  "$(get_formatted_message success worldedit Copied ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..command..time-elapsed"                      "$(get_formatted_message info worldedit ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} seconds ${COLOUR_MESSAGE}elapsed while changing ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1} blocks${COLOUR_MESSAGE}, at the speed of ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG2} blocks/s)" \
            "worldedit..contract..contracted"                       "$(get_formatted_message success worldedit The selection was shrunk by ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..count..counted"                             "$(get_formatted_message success worldedit Counted ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..error..incomplete-region"                   "$(get_formatted_message error worldedit No selection has been made)" \
            "worldedit..expand..expanded"                           "$(get_formatted_message success worldedit The selection was expanded by ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..expand..expanded..vert"                     "$(get_formatted_message success worldedit The selection was expanded by ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..line..changed"                              "$(get_formatted_message success worldedit Changed ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..move..moved"                                "$(get_formatted_message success worldedit Moved ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..pos..already-set"                           "$(get_formatted_message error worldedit Position already set)" \
            "worldedit..redo..none"                                 "$(get_formatted_message error worldedit Nothing to redo)" \
            "worldedit..redo..redone"                               "$(get_formatted_message success worldedit Redid ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} edits)" \
            "worldedit..reload..config"                             "$(get_reload_message FastAsyncWorldEdit)" \
            "worldedit..select..cleared"                            "$(get_formatted_message success worldedit The selection was cleared)" \
            "worldedit..selection..cuboid..explain..primary"        "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 1 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..primary-area"   "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 1 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary"      "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 2 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary-area" "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 2 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..set..done"                                  "$(get_formatted_message success worldedit Set ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..shift..shifted"                             "$(get_formatted_message success worldedit The selection was shifted)" \
            "worldedit..size..blocks"                               "$(get_formatted_message info worldedit Blocks: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..distance"                             "$(get_formatted_message info worldedit Distance: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..size"                                 "$(get_formatted_message info worldedit Size: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..type"                                 "$(get_formatted_message info worldedit Type: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..undo..none"                                 "$(get_formatted_message error worldedit Nothing to undo)" \
            "worldedit..undo..undone"                               "$(get_formatted_message success worldedit Undid ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} edits)" \
            "worldedit..wand..selwand..info"                        "$(get_formatted_message info worldedit ${COLOUR_COMMAND}Left Click ${COLOUR_MESSAGE}sets ${COLOUR_HIGHLIGHT}Position 1${COLOUR_MESSAGE}, ${COLOUR_COMMAND}Right Click ${COLOUR_MESSAGE} sets ${COLOUR_HIGHLIGHT}Position 2)"
    fi
fi

if is_plugin_installed "WorldEditSUI"; then
    configure_plugin "WorldEditSUI" config \
        'advanced-grid.enabled' true \
        'update-checks' false

    configure_plugin "WorldEditSUI" messages \
        "noPermission" "${INVALID_COMMAND_MESSAGE}" \
        "prefix" "${COLOUR_RESET}" \
        "reload" "$(get_reload_message WorldEditSUI)" \
        "WGNotEnabled" "${INVALID_COMMAND_MESSAGE}"

    if [ "${LOCALE}" == "ro" ]; then
        configure_plugin "WorldEditSUI" messages \
            "particlesHidden" "$(get_formatted_message info worldedit Cadrul de selecție ${COLOUR_HIGHLIGHT}dezactivate)" \
            "particlesShown" "$(get_formatted_message info worldedit Cadrul de selecție ${COLOUR_HIGHLIGHT}activate)"
    else
        configure_plugin "WorldEditSUI" messages \
            "particlesHidden" "$(get_formatted_message info worldedit Selection box ${COLOUR_HIGHLIGHT}disabled)" \
            "particlesShown" "$(get_formatted_message info worldedit Selection box ${COLOUR_HIGHLIGHT}enabled)"
    fi
fi

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
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${MATERIAL}_${ITEM}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
    done
done

for OVERWORLD_MATERIAL in "coal" "copper" "iron" "gold" "redstone" "lapis" "diamond" "emerald"; do
    for BLOCK in "${OVERWORLD_MATERIAL}_block" "${OVERWORLD_MATERIAL}_ore" "deepslate_${OVERWORLD_MATERIAL}_ore"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${BLOCK}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
    done
done
for NETHER_MATERIAL in "quartz" "gold"; do
    for BLOCK in "${NETHER_MATERIAL}_block" "nether_${NETHER_MATERIAL}_ore"; do
        set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}" "entities.spawning.alt-item-despawn-rate.items.${BLOCK}" "${DESPAWN_RATE_ITEMS_RARE_TICKS}"
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

set_config_value "${PAPER_WORLD_DEFAULT_CONFIG_FILE}"   "environment.treasure-maps.enabled"    true #false # They cause too much lag eventually
