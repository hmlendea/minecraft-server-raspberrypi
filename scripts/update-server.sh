#!/bin/bash

SERVER_ROOT_DIR="/srv/papermc"
SERVER_PLUGINS_DIR="${SERVER_ROOT_DIR}/plugins"

PURPUR_API_URL="https://api.purpurmc.org/v2/purpur"

USE_AUTHME=true
USE_DISCORDSRV=true
USE_ESSENTIALS=true
USE_GSIT=true
USE_IMAGEMAPS=true
USE_SKINSRESTORER=true
USE_STACKABLEITEMS=true
USE_VIAVERSION=true
USE_WORLDGUARD=true

function get_latest_github_release_tag() {
    local URL_PARTS=(${1//\// })
    local GH_USERNAME=${URL_PARTS[2]}
    local GH_REPOSITORY_NAME=${URL_PARTS[3]}

    local LATEST_RELEASE_APIREQUEST="https://api.github.com/repos/${GH_USERNAME}/${GH_REPOSITORY_NAME}/releases/latest"
    local LATEST_RELEASE_APIRESPONSE=$(curl -s "${LATEST_RELEASE_APIREQUEST}")
    local LATEST_RELEASE_TAG=$(echo "${LATEST_RELEASE_APIRESPONSE}" | jq -r ".tag_name")

    echo "${LATEST_RELEASE_TAG}"
}

function get_latest_purpur_minecraft_version() {
    curl -s "${PURPUR_API_URL}" | jq -r '.versions | sort | .[-1]'
}

function get_latest_purpur_build_version() {
    local MINECRAFT_VERSION="${1}"

    curl -s "${PURPUR_API_URL}/${MINECRAFT_VERSION}" | jq -r ".builds.latest"
}

function download_file() {
    local FILE_URL="${1}"
    local FILE_PATH="${2}"

    [ -f "${FILE_PATH}" ] && return

    echo "Downloading '${FILE_URL}' to '${FILE_PATH}'..."
    sudo wget "${FILE_URL}" -O "${FILE_PATH}"
    sudo chown papermc:papermc "${FILE_PATH}"
    sudo chmod +x "${FILE_PATH}"
}

function download_from_github() {
    local REPOSITORY_URL="${1}"
    local RELEASE_TAG="${2}"
    local PLUGIN_NAME="${3}"
    local PLUGIN_VERSION=$(echo "${RELEASE_TAG}" | sed 's/^\s*v//g')
    local PLUGIN_FILE_NAME="${PLUGIN_NAME}_${PLUGIN_VERSION}.jar"
    local PLUGIN_FILE_PATH="${SERVER_PLUGINS_DIR}/${PLUGIN_FILE_NAME}"
    local ASSET_FILE_NAME=$(echo "${4}" | sed \
            -e 's/%pluginName%/'"${PLUGIN_NAME}"'/g' \
            -e 's/%pluginVersion%/'"${PLUGIN_VERSION}"'/g')
            
    if [ -f "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}_"*".jar" ] && \
       [ ! -f "${PLUGIN_FILE_PATH}" ]; then
        sudo rm "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}_"*".jar"
    fi

    download_file "${REPOSITORY_URL}/releases/download/${RELEASE_TAG}/${ASSET_FILE_NAME}" "${PLUGIN_FILE_PATH}"
}

function update_plugin_github() {
    local PLUGIN_NAME="${1}"
    local GH_REPOSITORY_URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"
    local LATEST_RELEASE_TAG=$(get_latest_github_release_tag "${GH_REPOSITORY_URL}")

    [ "${LATEST_RELEASE_TAG}" == "null" ] && return

    download_from_github "${GH_REPOSITORY_URL}" "${LATEST_RELEASE_TAG}" "${PLUGIN_NAME}" "${ASSET_FILE_NAME_PATTERN}"
}

function update_plugin() {
    local EXTRA_ARG="${3}"
    local ASSET_FILE_NAME_PATTERN="${EXTRA_ARG}"
    [ -z "${ASSET_FILE_NAME_PATTERN}" ] && ASSET_FILE_NAME_PATTERN="%pluginName%-%pluginVersion%.jar"
    
    update_plugin_github "${1}" "${2}" "${ASSET_FILE_NAME_PATTERN}"
}

function update_server() {
    local LATEST_PURPUR_MINECRAFT_VERSION=$(get_latest_purpur_minecraft_version)
    local LATEST_PURPUR_BUILD_VERSION=$(get_latest_purpur_build_version "${LATEST_PURPUR_MINECRAFT_VERSION}")

    download_file "${PURPUR_API_URL}/${LATEST_PURPUR_MINECRAFT_VERSION}/${LATEST_PURPUR_BUILD_VERSION}/download" "purpur-${LATEST_PURPUR_MINECRAFT_VERSION}-${LATEST_PURPUR_BUILD_VERSION}.jar"
}

if ! papermc status | sed -e 's/\x1b\[[0-9;]*m//g' | grep -q "Status: stopped"; then
    echo "ERROR: The server needs to be stopped to update the plugins!"
    exit 1
elif [ ! -f "/usr/bin/jq" ]; then
    echo "ERROR: jq is not installed!"
    exit 2
else
    update_server

    ${USE_AUTHME}           && update_plugin "AuthMe"               "https://github.com/AuthMe/AuthMeReloaded"
    ${USE_DISCORDSRV}       && update_plugin "DiscordSRV"           "https://github.com/DiscordSRV/DiscordSRV"          "%pluginName%-Build-%pluginVersion%.jar"
    ${USE_ESSENTIALS}       && update_plugin "EssentialsX"          "https://github.com/EssentialsX/Essentials"
    ${USE_GSIT}             && update_plugin "GSit"                 "https://github.com/Gecolay/GSit"
    ${USE_IMAGEMAPS}        && update_plugin "ImageMaps"            "https://github.com/SydMontague/ImageMaps"          "%pluginName%.jar"
    ${USE_SKINSRESTORER}    && update_plugin "SkinsRestorer"        "https://github.com/SkinsRestorer/SkinsRestorerX"   "%pluginName%.jar"
    ${USE_STACKABLEITEMS}   && update_plugin "StackableItems"       "https://github.com/haveric/StackableItems"         "%pluginName%.jar"
    ${USE_VIAVERSION}       && update_plugin "ViaVersion"           "https://github.com/ViaVersion/ViaVersion"
    ${USE_WORLDGUARD}       && update_plugin "WorldGuardExtraFlags" "https://github.com/aromaa/WorldGuardExtraFlags"    "%pluginName%.jar"
fi
