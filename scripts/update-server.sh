#!/bin/bash

source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

PURPUR_API_URL='https://api.purpurmc.org/v2/purpur'

function get_latest_purpur_build_version() {
    local MINECRAFT_VERSION="${1}"

    curl -s "${PURPUR_API_URL}/${MINECRAFT_VERSION}" | jq -r '.builds.latest'
}

function update_server() {
    local LATEST_PURPUR_BUILD_VERSION=$(get_latest_purpur_build_version "${MINECRAFT_VERSION}")

    download_file "${PURPUR_API_URL}/${MINECRAFT_VERSION}/${LATEST_PURPUR_BUILD_VERSION}/download" "purpur-${MINECRAFT_VERSION}-${LATEST_PURPUR_BUILD_VERSION}.jar"
}

if ! papermc status | sed -e 's/\x1b\[[0-9;]*m//g' | grep -q 'Status: stopped'; then
    echo 'ERROR: The server needs to be stopped to update the plugins!'
    exit 1
else
    update_server

    update_datapack 'DungeonsAndTaverns'        'https://modrinth.com/datapack/dungeons-and-taverns'
    update_datapack 'Explorify'                 'https://modrinth.com/datapack/explorify'
    update_datapack 'Hearths'                   'https://modrinth.com/datapack/hearths'
    update_datapack 'Nullscape'                 'https://modrinth.com/datapack/nullscape'
    update_datapack 'PandaTemple'               'https://modrinth.com/datapack/panda-temple'
    update_datapack 'qraftyfied'                'https://modrinth.com/datapack/qraftyfied'
    update_datapack 'VanillaStructureUpdate'    'https://modrinth.com/datapack/vanilla-structure-update'

    update_plugin 'AnarchyExploitFixes'         'https://modrinth.com/plugin/anarchyexploitfixes'           '%pluginName%-Folia-%pluginVersion%.jar'
    update_plugin 'AnnouncerPlus'               'https://github.com/jpenilla/AnnouncerPlus'                 '%pluginName%-%pluginVersion%.jar'
    update_plugin 'AuthMe'                      'https://github.com/AuthMe/AuthMeReloaded'
    # TODO: BestTools
    update_plugin 'ChestShop-3'                 'https://ci.minebench.de'                                   'ChestShop.jar'
    update_plugin 'ChestShopNotifier'           'https://ci.minebench.de'                                   '%pluginName%.jar'
    # TODO: ChestSort
    # TODO: CommandHelper
    update_plugin 'CoreProtect'                 'https://ci.froobworld.com'                                 '%pluginName%-%pluginVersion%.jar'
    update_plugin 'CustomCommands'              'https://modrinth.com/plugin/custom-commands'               '%pluginName%-%pluginVersion%.jar'
    update_plugin 'CustomCrafting'              'https://modrinth.com/plugin/customcrafting'                'customcrafting-spigot-%pluginVersion%.jar'
    update_plugin 'DeathMessages'               'https://github.com/Winds-Studio/DeathMessages'             '%pluginName%-%pluginVersion%.jar'
    update_plugin 'DecentHolograms'             'https://github.com/DecentSoftware-eu/DecentHolograms'      '%pluginName%-%pluginVersion%.jar'
    update_plugin 'DeluxeMenus'                 'https://ci.extendedclip.com'                               '%pluginName%-%pluginVersion%.jar'
    update_plugin 'DiscordSRV'                  'https://github.com/DiscordSRV/DiscordSRV'                  "%pluginName%-Build-%pluginVersion%.jar"
    update_plugin 'DynamicLights'               'https://github.com/xCykrix/DynamicLights'                  "%pluginName%-%pluginVersion%.jar"
    update_plugin 'Dynmap'                      'https://modrinth.com/plugin/dynmap'                        "%pluginName%-%pluginVersion%-spigot.jar"
#    update_plugin 'EssentialsX'                 'https://github.com/EssentialsX/Essentials'
#    update_plugin 'EssentialsXSpawn'            'https://github.com/EssentialsX/Essentials'
#    update_plugin 'EssentialsXChat'             'https://github.com/EssentialsX/Essentials'
    update_plugin 'FastAsyncWorldEdit'          'https://ci.athion.net'                                     '%pluginName%-Bukkit-%pluginVersion%.jar'
#    update_plugin 'GeyserMC'                    'https://modrinth.com/plugin/geyser'                        'Geyser-Spigot-%pluginVersion%.jar'
    update_plugin 'GrimAC'                      'https://modrinth.com/plugin/grimac'                        'grimac-%pluginVersion%.jar'
    update_plugin 'GSit'                        'https://github.com/Gecolay/GSit'
    update_plugin 'HardPlus'                    'https://modrinth.com/plugin/hardplus'                      '%pluginName%-%pluginVersion%.jar'
    update_plugin 'HeadDB'                      'https://github.com/thesilentpro/headdb'                    '%pluginName%.jar'
    update_plugin 'HealthHider'                 'https://github.com/NoahvdAa/HealthHider'                   '%pluginName%-%pluginVersion%.jar'
    update_plugin 'ImageMaps'                   'https://github.com/SydMontague/ImageMaps'                  '%pluginName%.jar'
    update_plugin 'InteractionVisualizer'       'https://ci.loohpjames.com'                                 '%pluginName%-%pluginVersion%.jar'
    update_plugin 'InvSee++'                    'https://github.com/Jannyboy11/InvSee-plus-plus'            '%pluginName%.jar'
    update_plugin 'KauriVPN'                    'https://github.com/funkemunky/AntiVPN'                     '%pluginName%-%pluginVersion%.jar'
    update_plugin 'LuckPerms'                   'https://ci.lucko.me'                                       '%pluginName%-Bukkit-%pluginVersion%.jar'
    update_plugin 'MiniMOTD'                    "https://github.com/jpenilla/MiniMOTD"                      "minimotd-bukkit-%pluginVersion%.jar"
    update_plugin 'NerdFlags'                   'https://github.com/NerdNu/NerdFlags'                       '%pluginName%-%pluginVersion%.jar'
    update_plugin 'NuVotifier'                  "https://github.com/NuVotifier/NuVotifier"                  "%pluginName%.jar"
    update_plugin 'OldCombatMechanics'          'https://github.com/kernitus/BukkitOldCombatMechanics'      "%pluginName%.jar"
    update_plugin 'Orebfuscator'                'https://github.com/Imprex-Development/orebfuscator'        'orebfuscator-plugin-%pluginVersion%.jar'
#    update_plugin 'PacketEvents'                'https://github.com/retrooper/packetevents'                 'packetevents-spigot-%pluginVersion%.jar'
    update_plugin 'PaperTweaks'                 "https://github.com/MC-Machinations/VanillaTweaks"          "%pluginName%.jar"
    update_plugin 'Pl3xMap'                     "https://modrinth.com/plugin/pl3xmap"                       "%pluginName%-%pluginVersion%.jar"
    update_plugin 'Pl3xMap-Claims'              "https://modrinth.com/plugin/pl3xmap-claims"                "%pluginName%-%pluginVersion%.jar"
#    update_plugin 'PlaceholderAPI'              'https://ci.extendedclip.com'                               '%pluginName%-%pluginVersion%.jar'
    update_plugin 'PlugManX'                    "https://github.com/TheBlackEntity/PlugManX"                "%pluginName%.jar"
    update_plugin 'ProAntiTab'                  'https://github.com/RayzsYT/ProAntiTab'                     '%pluginName%-%pluginVersion%.jar'
    update_plugin 'ProtocolLib'                 'https://ci.dmulloy2.net'                                   '%pluginName%.jar'
#    update_plugin 'ProtocolLib'                 "https://github.com/dmulloy2/ProtocolLib"                   "%pluginName%.jar"
    update_plugin 'PurpurExtras'                'https://modrinth.com/plugin/purpurextras'                  '%pluginName%-%pluginVersion%.jar'
    update_plugin 'SeeMore'                     'https://github.com/froobynooby/SeeMore'                    '%pluginName%-%pluginVersion%.jar'
    update_plugin 'SimpleVoiceChat'             'https://modrinth.com/plugin/simple-voice-chat'             'voicechat-bukkit-%pluginVersion.jar'
    update_plugin 'SkinsRestorer'               "https://github.com/SkinsRestorer/SkinsRestorerX"           "%pluginName%.jar"
    update_plugin 'Sonar'                       'https://github.com/jonesdevelopment/sonar'                 '%pluginName%-Bukkit.jar'
    update_plugin 'spark'                       "https://ci.lucko.me"                                       "%pluginName%-Bukkit-%pluginVersion%.jar"
    update_plugin 'StackableItems'              "https://github.com/haveric/StackableItems"                 "%pluginName%.jar"
    # TODO: SuperbVote
    update_plugin 'TAB'                         "https://github.com/NEZNAMY/TAB"                            "%pluginName%.v%pluginVersion%.jar"
    update_plugin 'TChat'                       "https://github.com/TectHost/TChat"                         "%pluginName%.jar"
    update_plugin 'ToolStats'                   'https://github.com/hyperdefined/ToolStats'                 'toolstats-%pluginVersion%.jar'
    # TODO: TreeAssist
    update_plugin 'UltimateInventory'           "https://github.com/percyqaz/UltimateInventory"             "%pluginName%-%pluginVersion%.jar"
    # TODO: VanillaMessagesFormatter
    update_plugin 'VanillaMinimaps'             'https://github.com/JNNGL/VanillaMinimaps'                  'vanillaminimaps-%pluginVersion%.jar'
    update_plugin 'Vault'                       "https://github.com/MilkBowl/Vault"                         "%pluginName%.jar"
    update_plugin 'ViaBackwards'                "https://github.com/ViaVersion/ViaBackwards"
    update_plugin 'ViaVersion'                  "https://github.com/ViaVersion/ViaVersion"
    update_plugin 'ViewDistanceTweaks'          "https://ci.froobworld.com"                                 "%pluginName%-%pluginVersion%.jar"
    update_plugin 'VivecraftSpigotExtensions'   'https://github.com/jrbudda/Vivecraft_Spigot_Extensions'    'Vivecraft_Spigot_Extensions.%pluginVersion%.jar'
    update_plugin 'VotingPlugin'                "https://bencodez.com"                                      "%pluginName%.jar"
    update_plugin 'WanderingTrades'             'https://jenkins.jpenilla.xyz'                              "%pluginName%-%pluginVersion%.jar"
    #update_plugin 'WanderingTrades'             'https://github.com/jpenilla/WanderingTrades'               "%pluginName%-%pluginVersion%.jar"
    update_plugin 'WolfyUtils'                  "https://modrinth.com/plugin/wolfyutils"                    "wolfyutils-spigot-%pluginVersion%.jar"
    update_plugin 'WorldEditSUI'                "https://github.com/kennytv/WorldEditSUI"                   "%pluginName%-%pluginVersion%.jar"
    update_plugin 'WorldGuard'                  'https://modrinth.com/plugin/worldguard'                    'worldguard-bukkit-%pluginVersion%-dist.jar'
    update_plugin 'WorldGuardExtraFlags'        'https://github.com/aromaa/WorldGuardExtraFlags'            '%pluginName%.jar'
    update_plugin 'XRayHunter'                  'https://github.com/rlf/XRayHunter'                         '%pluginName%.jar'
fi
