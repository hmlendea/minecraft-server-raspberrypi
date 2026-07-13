#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "$(dirname "${BASH_SOURCE[0]}" | xargs realpath | sed 's/\/scripts.*//g')/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/web.sh"

function get_modrinth_project_name() {
    local URL="${1}"
    local PROJECT_NAME=$(basename "${URL%/}")

    echo "${PROJECT_NAME}"
}

function get_modrinth_project_id() {
    local PROJECT_NAME="${1}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_NAME}"
    local APIRESPONSE=$(curl -s "${APIREQUEST}")
    local PROJECT_ID=$(echo "${APIRESPONSE}" | jq -r '.id')

    echo "${PROJECT_ID}"
}

function get_modrinth_asset_name() {
    local PROJECT_ID="${1}"
    local VERSION_ID="${2}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_ID}/version/${VERSION_ID}"
    local APIRESPONSE=$(curl -s "${APIREQUEST}")
    local ASSET_NAME=$(echo "${APIRESPONSE}" | jq -r '.files.[0].filename')

    echo "${ASSET_NAME}"
}

function get_modrinth_version_number() {
    local PROJECT_NAME="${1}"
    local VERSION_ID="${2}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_NAME}/version/${VERSION_ID}"

    curl -s "${APIREQUEST}" | jq -r '.version_number'
}

function get_latest_modrinth_version_id() {
    local PROJECT_ID="${1}"
    local PROJECT_TYPE="${2}"

    local APIREQUEST="https://api.modrinth.com/v2/project/${PROJECT_ID}/version"
    local APIRESPONSE=$(curl -s "${APIREQUEST}")

    if [[ "${PROJECT_TYPE}" == 'plugin' ]]; then
        echo "${APIRESPONSE}" | jq -r '
            .[]
            | select(any(.loaders[]?; IN("paper","spigot","bukkit")))
            | .id
        ' | head -n 1

    elif [[ "${PROJECT_TYPE}" == 'datapack' ]]; then
        echo "${APIRESPONSE}" | jq -r '
            .[]
            | select(any(.loaders[]?; IN("datapack")))
            | .id
        ' | head -n 1

    else
        echo "${APIRESPONSE}" | jq -r '.[0].id'
    fi
}

function download_datapack_modrinth() {
    local PROJECT_ID="${1}"
    local DATAPACK_NAME="${2}"
    local DATAPACK_VERSION_ID="${3}"

    local DATAPACK_VERSION_NUMBER=$(get_modrinth_version_number "${PROJECT_ID}" "${DATAPACK_VERSION_ID}")
    local ASSET_FILE_NAME=$(get_modrinth_asset_name "${PROJECT_ID}" "${DATAPACK_VERSION_ID}")

    download_datapack "https://cdn.modrinth.com/data/${PROJECT_ID}/versions/${DATAPACK_VERSION_ID}/${ASSET_FILE_NAME}" "${DATAPACK_NAME}" "${DATAPACK_VERSION_NUMBER}"
}

function download_plugin_modrinth() {
    local PROJECT_ID="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION_ID="${3}"

    local PLUGIN_VERSION_NUMBER=$(get_modrinth_version_number "${PROJECT_ID}" "${PLUGIN_VERSION_ID}")
    local ASSET_FILE_NAME=$(get_modrinth_asset_name "${PROJECT_ID}" "${PLUGIN_VERSION_ID}")

    download_plugin "https://cdn.modrinth.com/data/${PROJECT_ID}/versions/${PLUGIN_VERSION_ID}/${ASSET_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION_NUMBER}"
}

function update_datapack_modrinth() {
    local DATAPACK_NAME="${1}"
    local URL="${2}"

    local MODRINTH_PROJECT_NAME=$(get_modrinth_project_name "${URL}")
    local MODRINTH_PROJECT_ID=$(get_modrinth_project_id "${MODRINTH_PROJECT_NAME}")
    local LATEST_VERSION_ID=$(get_latest_modrinth_version_id "${MODRINTH_PROJECT_ID}" 'datapack')

    [ -z "${LATEST_VERSION_ID}" ] && return

    download_datapack_modrinth "${MODRINTH_PROJECT_ID}" "${DATAPACK_NAME}" "${LATEST_VERSION_ID}" "${ASSET_FILE_NAME_PATTERN}"
}

function update_plugin_modrinth() {
    local PLUGIN_NAME="${1}"
    local URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"

    local MODRINTH_PROJECT_NAME=$(get_modrinth_project_name "${URL}")
    local MODRINTH_PROJECT_ID=$(get_modrinth_project_id "${MODRINTH_PROJECT_NAME}")

    local LATEST_VERSION_ID=$(get_latest_modrinth_version_id "${MODRINTH_PROJECT_ID}" 'plugin')

    [ -z "${LATEST_VERSION_ID}" ] && return

    download_plugin_modrinth "${MODRINTH_PROJECT_ID}" "${PLUGIN_NAME}" "${LATEST_VERSION_ID}" "${ASSET_FILE_NAME_PATTERN}"
}
