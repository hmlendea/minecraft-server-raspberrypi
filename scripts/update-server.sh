#!/bin/bash

source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

PURPUR_API_URL="https://api.purpurmc.org/v2/purpur"

function download_plugin() {
    local ASSET_URL="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"
    local PLUGIN_FILE_NAME="${PLUGIN_NAME}-${PLUGIN_VERSION}.jar"
    local PLUGIN_FILE_PATH="${SERVER_PLUGINS_DIR}/${PLUGIN_FILE_NAME}"

    if [ -f "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}_"*".jar" ] && \
       [ ! -f "${PLUGIN_FILE_PATH}" ]; then
        sudo rm "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}_"*".jar"
    fi

    download_file "${ASSET_URL}" "${PLUGIN_FILE_PATH}"
}

function transform_asset_file_name() {
    local ASSET_FILE_NAME_PATTERN="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"

    echo "${ASSET_FILE_NAME_PATTERN}" | sed \
            -e 's/%pluginName%/'"${PLUGIN_NAME}"'/g' \
            -e 's/%pluginVersion%/'"${PLUGIN_VERSION}"'/g'
}

function get_latest_purpur_build_version() {
    local MINECRAFT_VERSION="${1}"

    curl -s "${PURPUR_API_URL}/${MINECRAFT_VERSION}" | jq -r ".builds.latest"
}

function update_server() {
    local LATEST_PURPUR_BUILD_VERSION=$(get_latest_purpur_build_version "${MINECRAFT_VERSION}")

    download_file "${PURPUR_API_URL}/${MINECRAFT_VERSION}/${LATEST_PURPUR_BUILD_VERSION}/download" "purpur-${MINECRAFT_VERSION}-${LATEST_PURPUR_BUILD_VERSION}.jar"
}

if ! papermc status | sed -e 's/\x1b\[[0-9;]*m//g' | grep -q "Status: stopped"; then
    echo "ERROR: The server needs to be stopped to update the plugins!"
    exit 1
else
    update_server

    update_datapack "DungeonsAndTaverns"    "https://modrinth.com/datapack/dungeons-and-taverns"

    update_plugin "AuthMe"                  "https://github.com/AuthMe/AuthMeReloaded"
    update_plugin "BetterMessages"          "https://modrinth.com/plugin/bettermessages"            "%pluginName%-%pluginVersion%.jar"
    update_plugin "CustomCrafting"          "https://modrinth.com/plugin/customcrafting"            "customcrafting-spigot-%pluginVersion%.jar"
    update_plugin "WolfyUtils"              "https://modrinth.com/plugin/wolfyutils"                "wolfyutils-spigot-%pluginVersion%.jar"
    update_plugin "DeluxeMenus"             "https://ci.extendedclip.com"                           "%pluginName%-%pluginVersion%.jar"
    update_plugin "DiscordSRV"              "https://github.com/DiscordSRV/DiscordSRV"              "%pluginName%-Build-%pluginVersion%.jar"
    update_plugin "DynamicLights"           "https://github.com/xCykrix/DynamicLights"              "%pluginName%-%pluginVersion%-SNAPSHOT.jar"
    update_plugin "Dynmap"                  "https://modrinth.com/plugin/dynmap"                    "%pluginName%-%pluginVersion%-spigot.jar"
    update_plugin "EssentialsX"             "https://github.com/EssentialsX/Essentials"
    update_plugin "EssentialsXSpawn"        "https://github.com/EssentialsX/Essentials"
    update_plugin "EssentialsXChat"         "https://github.com/EssentialsX/Essentials"
    update_plugin "GSit"                    "https://github.com/Gecolay/GSit"
    update_plugin "ImageMaps"               "https://github.com/SydMontague/ImageMaps"              "%pluginName%.jar"
    update_plugin "InteractionVisualizer"   "https://ci.loohpjames.com"                             "%pluginName%-%pluginVersion%.jar"
    update_plugin "InvSee++"                "https://github.com/Jannyboy11/InvSee-plus-plus"        "%pluginName%.jar"
    update_plugin "MiniMOTD"                "https://github.com/jpenilla/MiniMOTD"                  "minimotd-bukkit-%pluginVersion%.jar"
    update_plugin "NuVotifier"              "https://github.com/NuVotifier/NuVotifier"              "%pluginName%.jar"
    update_plugin "OldCombatMechanics"      "https://github.com/kernitus/BukkitOldCombatMechanics"  "%pluginName%.jar"
    update_plugin "PaperTweaks"             "https://github.com/MC-Machinations/VanillaTweaks"      "%pluginName%.jar"
    update_plugin "Pl3xMap"                 "https://modrinth.com/plugin/pl3xmap"                   "%pluginName%-%pluginVersion%.jar"
    update_plugin "Pl3xMap-Claims"          "https://modrinth.com/plugin/pl3xmap-claims"            "%pluginName%-%pluginVersion%.jar"
    update_plugin "PlugManX"                "https://github.com/TheBlackEntity/PlugManX"            "%pluginName%.jar"
    update_plugin "ProtocolLib"             "https://github.com/dmulloy2/ProtocolLib"               "%pluginName%.jar"
    update_plugin "PurpurExtras"            "https://modrinth.com/plugin/purpurextras"              "%pluginName%-%pluginVersion%.jar"
    update_plugin "SkinsRestorer"           "https://github.com/SkinsRestorer/SkinsRestorerX"       "%pluginName%.jar"
    update_plugin "spark"                   "https://ci.lucko.me"                                   "%pluginName%-%pluginVersion%.jar"
    update_plugin "StackableItems"          "https://github.com/haveric/StackableItems"             "%pluginName%.jar"
    update_plugin "TAB"                     "https://github.com/NEZNAMY/TAB"                        "%plugiNName%.v%pluginVersion%.jar"
    update_plugin "TChat"                   "https://github.com/TectHost/TChat"                     "%pluginName%.jar"
    update_plugin "UltimateInventory"       "https://github.com/percyqaz/UltimateInventory"         "%pluginName%-%pluginVersion%.jar"
    update_plugin "Vault"                   "https://github.com/MilkBowl/Vault"                     "%pluginName%.jar"
    update_plugin "ViaVersion"              "https://github.com/ViaVersion/ViaVersion"
    update_plugin "ViaBackwards"            "https://github.com/ViaVersion/ViaBackwards"
    update_plugin "ViewDistanceTweaks"      "https://ci.froobworld.com"                             "%pluginName%-%pluginVersion%.jar"
    update_plugin "WanderingTrades"         "https://github.com/jpenilla/WanderingTrades"           "%pluginName%-%pluginVersion%.jar"
    update_plugin "FastAsyncWorldEdit"      "https://ci.athion.net"                                 "%pluginName%-%pluginVersion%.jar"
    update_plugin "VotingPlugin"            "https://bencodez.com"                                  "%pluginName%.jar"
    update_plugin "WorldEditSUI"            "https://github.com/kennytv/WorldEditSUI"               "%pluginName%-%pluginVersion%.jar"
    update_plugin "WorldGuardExtraFlags"    "https://github.com/aromaa/WorldGuardExtraFlags"        "%pluginName%.jar"
fi
