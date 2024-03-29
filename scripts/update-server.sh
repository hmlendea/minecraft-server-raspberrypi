#!/bin/bash

source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

PURPUR_API_URL="https://api.purpurmc.org/v2/purpur"

function get_latest_github_release_tag() {
    local GH_REPOSITORY_URL=(${1//\// })
    local GH_REPOSITORY_NAME=${GH_REPOSITORY_URL[3]}
    local GH_USERNAME=${GH_REPOSITORY_URL[2]}

    local LATEST_RELEASE_APIREQUEST="https://api.github.com/repos/${GH_USERNAME}/${GH_REPOSITORY_NAME}/releases/latest"
    local LATEST_RELEASE_APIRESPONSE=$(curl -s "${LATEST_RELEASE_APIREQUEST}")
    local LATEST_RELEASE_TAG=$(echo "${LATEST_RELEASE_APIRESPONSE}" | jq -r ".tag_name")

    echo "${LATEST_RELEASE_TAG}"
}

function get_modrinth_project_id() {
    local PROJECT_NAME="${1}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_NAME}"
    local APIRESPONSE=$(curl -s "${APIREQUEST}")
    local PROJECT_ID=$(echo "${APIRESPONSE}" | jq -r '.id')

    echo "${PROJECT_ID}"
}

function get_modrinth_version_id() {
    local PROJECT_ID="${1}"
    local VERSION_NAME="${2}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_ID}/version/${VERSION_NAME}"
    local APIRESPONSE=$(curl -s "${APIREQUEST}")
    local VERSION_ID=$(echo "${APIRESPONSE}" | jq -r '.id')

    echo "${VERSION_ID}"
}

function get_modrinth_asset_name() {
    local PROJECT_ID="${1}"
    local VERSION_ID="${2}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_ID}/version/${VERSION_ID}"
    local APIRESPONSE=$(curl -s "${APIREQUEST}")
    local ASSET_NAME=$(echo "${APIRESPONSE}" | jq -r '.files.[0].filename')

    echo "${ASSET_NAME}"
}

function get_latest_modrinth_version() {
    local PROJECT_ID="${1}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_ID}/version"
    local APIRESPONSE=$(curl -s "${APIREQUEST}")
    local LATEST_VERSION=""

    [ -z "${LATEST_VERSION}" ] && LATEST_VERSION=$(echo "${APIRESPONSE}" | jq '[.[] | select(.loaders | to_entries[] | .value | IN("paper", "spigt", "bukkit"))]' | jq -r '.[0].version_number')
    [ -z "${LATEST_VERSION}" ] && LATEST_VERSION=$(echo "${APIRESPONSE}" | jq -r '.[0].version_number')

    echo "${LATEST_VERSION}"
}

function get_latest_jenkins_build_version() {
    local BASE_URL="${1}"
    local JOB_NAME="${2}"

    local REQUEST_URL="${BASE_URL}/job/${JOB_NAME}/lastSuccessfulBuild/api/json"
    local ARTIFACT_LIST=$(curl -s "${REQUEST_URL}" | jq -r '.artifacts[] | .fileName')
    local ARTIFACT_VERSION=$(echo "${ARTIFACT_LIST}" | \
                             head -n 1 | \
                             sed \
                                -e 's/'"${JOB_NAME}"'[\_\-]//g' \
                                -e 's/\.jar$//g' \
                                -e 's/^v//g')

    echo "${ARTIFACT_VERSION}"
}

function get_latest_purpur_build_version() {
    local MINECRAFT_VERSION="${1}"

    curl -s "${PURPUR_API_URL}/${MINECRAFT_VERSION}" | jq -r ".builds.latest"
}

function download_file() {
    local FILE_URL="${1}"
    local FILE_PATH="${2}"

    [ -f "${FILE_PATH}" ] && return

    sudo wget --quiet "${FILE_URL}" -O "${FILE_PATH}"
    sudo chown papermc:papermc "${FILE_PATH}"
    sudo chmod +x "${FILE_PATH}"

    if [ -f "${FILE_PATH}" ]; then
        local FILE_SIZE=$(du "${FILE_PATH}" | awk '{print $1}')
        if [ ${FILE_SIZE} -eq 0 ]; then
            sudo rm "${FILE_PATH}"
        else
            echo " > Downloaded '${FILE_PATH}'"
        fi
    fi
}

function download_plugin() {
    local ASSET_URL="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"
    local PLUGIN_FILE_NAME="${PLUGIN_NAME}_${PLUGIN_VERSION}.jar"
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

function download_from_github() {
    local REPOSITORY_URL="${1}"
    local RELEASE_TAG="${2}"
    local PLUGIN_NAME="${3}"
    local PLUGIN_VERSION=$(echo "${RELEASE_TAG}" | sed 's/^\s*v//g')
    local ASSET_FILE_NAME=$(transform_asset_file_name "${4}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}")

    download_plugin "${REPOSITORY_URL}/releases/download/${RELEASE_TAG}/${ASSET_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
}

function download_from_modrinth() {
    local PROJECT_ID="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"
#    local ASSET_FILE_NAME=$(transform_asset_file_name "${4}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}")
    local VERSION_ID=$(get_modrinth_version_id "${PROJECT_ID}" "${PLUGIN_VERSION}")
    local ASSET_FILE_NAME=$(get_modrinth_asset_name "${PROJECT_ID}" "${VERSION_ID}")

    download_plugin "https://cdn.modrinth.com/data/${PROJECT_ID}/versions/${VERSION_ID}/${ASSET_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
}

function download_from_jenkins() {
    local JENKINS_BASE_URL="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"
    local ARTIFACT_FILE_NAME=$(transform_asset_file_name "${4}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}")
    local ARTIFACT_NAME=""

    local PLUGIN_FILE_NAME="${PLUGIN_NAME}_${PLUGIN_VERSION}.jar"
    local PLUGIN_FILE_PATH="${SERVER_PLUGINS_DIR}/${PLUGIN_FILE_NAME}"

    [[ "${PLUGIN_NAME}" == "spark" ]] && ARTIFACT_NAME="spark-bukkit"

    download_plugin "${JENKINS_BASE_URL}/job/${PLUGIN_NAME}/lastSuccessfulBuild/artifact/${ARTIFACT_NAME}/build/libs/${ARTIFACT_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"

    if [ ! -f "${PLUGIN_FILE_PATH}" ]; then
        download_plugin "${JENKINS_BASE_URL}/job/${PLUGIN_NAME}/lastSuccessfulBuild/artifact/artifacts/${ARTIFACT_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
    fi
}

function update_plugin_github() {
    local PLUGIN_NAME="${1}"
    local GH_REPOSITORY_URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"
    local LATEST_RELEASE_TAG=$(get_latest_github_release_tag "${GH_REPOSITORY_URL}")

    [ "${LATEST_RELEASE_TAG}" == "null" ] && return

    download_from_github "${GH_REPOSITORY_URL}" "${LATEST_RELEASE_TAG}" "${PLUGIN_NAME}" "${ASSET_FILE_NAME_PATTERN}"
}

function update_plugin_modrinth() {
    local PLUGIN_NAME="${1}"
    local ASSET_FILE_NAME_PATTERN="${2}"

    local MODRINTH_PROJECT_ID=$(get_modrinth_project_id "${PLUGIN_NAME}")
    local LATEST_VERSION=$(get_latest_modrinth_version "${MODRINTH_PROJECT_ID}")

    [ -z "${LATEST_VERSION}" ] && return

    download_from_modrinth "${MODRINTH_PROJECT_ID}" "${PLUGIN_NAME}" "${LATEST_VERSION}" "${ASSET_FILE_NAME_PATTERN}"
}

function update_plugin_jenkins() {
    local PLUGIN_NAME="${1}"
    local JENKINS_BASE_URL="${2}"
    local ARTIFACT_FILE_NAME_PATTERN="${3}"
    local LATEST_BUILD_VERSION=$(get_latest_jenkins_build_version "${JENKINS_BASE_URL}" "${PLUGIN_NAME}")

    [ -z "${LATEST_BUILD_VERSION}" ] && return

    download_from_jenkins "${JENKINS_BASE_URL}" "${PLUGIN_NAME}" "${LATEST_BUILD_VERSION}" "${ARTIFACT_FILE_NAME_PATTERN}"
}

function update_plugin() {
    local PLUGIN_NAME="${1}"

    ! is_plugin_installed "${PLUGIN_NAME}" && return

    local URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"
    [ -z "${ASSET_FILE_NAME_PATTERN}" ] && ASSET_FILE_NAME_PATTERN="%pluginName%-%pluginVersion%.jar"

    echo "Checking for updates for plugin '${PLUGIN_NAME}'..."
    if [[ ${2} == *"github"* ]]; then
        update_plugin_github "${PLUGIN_NAME}" "${URL}" "${ASSET_FILE_NAME_PATTERN}"
    elif [[ ${2} == *"modrinth"* ]]; then
        update_plugin_modrinth "${PLUGIN_NAME}" "${ASSET_FILE_NAME_PATTERN}"
    else
        update_plugin_jenkins "${PLUGIN_NAME}" "${URL}" "${ASSET_FILE_NAME_PATTERN}"
    fi
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

    update_plugin "AuthMe"                  "https://github.com/AuthMe/AuthMeReloaded"
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
