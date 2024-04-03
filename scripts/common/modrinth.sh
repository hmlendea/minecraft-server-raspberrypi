#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/web.sh"

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

function download_datapack_modrinth() {
    local PROJECT_ID="${1}"
    local DATAPACK_NAME="${2}"
    local DATAPACK_VERSION="${3}"
    local VERSION_ID=$(get_modrinth_version_id "${PROJECT_ID}" "${DATAPACK_VERSION}")
    local ASSET_FILE_NAME=$(get_modrinth_asset_name "${PROJECT_ID}" "${VERSION_ID}")

    download_datapack "https://cdn.modrinth.com/data/${PROJECT_ID}/versions/${VERSION_ID}/${ASSET_FILE_NAME}" "${DATAPACK_NAME}" "${DATAPACK_VERSION}"
}

function download_plugin_modrinth() {
    local PROJECT_ID="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"
    local VERSION_ID=$(get_modrinth_version_id "${PROJECT_ID}" "${PLUGIN_VERSION}")
    local ASSET_FILE_NAME=$(get_modrinth_asset_name "${PROJECT_ID}" "${VERSION_ID}")

    download_plugin "https://cdn.modrinth.com/data/${PROJECT_ID}/versions/${VERSION_ID}/${ASSET_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
}

function update_datapack_modrinth() {
    local DATAPACK_NAME="${1}"

    local MODRINTH_PROJECT_ID=$(get_modrinth_project_id "${DATAPACK_NAME}")
    local LATEST_VERSION=$(get_latest_modrinth_version "${MODRINTH_PROJECT_ID}")

    [ -z "${LATEST_VERSION}" ] && return

    download_datapack_modrinth "${MODRINTH_PROJECT_ID}" "${DATAPACK_NAME}" "${LATEST_VERSION}" "${ASSET_FILE_NAME_PATTERN}"
}

function update_plugin_modrinth() {
    local PLUGIN_NAME="${1}"
    local ASSET_FILE_NAME_PATTERN="${2}"

    local MODRINTH_PROJECT_ID=$(get_modrinth_project_id "${PLUGIN_NAME}")
    local LATEST_VERSION=$(get_latest_modrinth_version "${MODRINTH_PROJECT_ID}")

    [ -z "${LATEST_VERSION}" ] && return

    download_plugin_modrinth "${MODRINTH_PROJECT_ID}" "${PLUGIN_NAME}" "${LATEST_VERSION}" "${ASSET_FILE_NAME_PATTERN}"
}
