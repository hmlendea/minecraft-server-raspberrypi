#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"

function get_latest_github_release_tag() {
    local GH_REPOSITORY_URL=(${1//\// })
    local GH_REPOSITORY_NAME=${GH_REPOSITORY_URL[3]}
    local GH_USERNAME=${GH_REPOSITORY_URL[2]}

    local LATEST_RELEASE_APIREQUEST="https://api.github.com/repos/${GH_USERNAME}/${GH_REPOSITORY_NAME}/releases/latest"
    local LATEST_RELEASE_APIRESPONSE=$(curl -s "${LATEST_RELEASE_APIREQUEST}")
    local LATEST_RELEASE_TAG=$(echo "${LATEST_RELEASE_APIRESPONSE}" | jq -r ".tag_name")

    echo "${LATEST_RELEASE_TAG}"
}

function download_plugin_github() {
    local REPOSITORY_URL="${1}"
    local RELEASE_TAG="${2}"
    local PLUGIN_NAME="${3}"
    local PLUGIN_VERSION=$(echo "${RELEASE_TAG}" | sed 's/^\s*v//g')
    local ASSET_FILE_NAME=$(transform_asset_file_name "${4}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}")

    download_plugin "${REPOSITORY_URL}/releases/download/${RELEASE_TAG}/${ASSET_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
}

function update_plugin_github() {
    local PLUGIN_NAME="${1}"
    local GH_REPOSITORY_URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"
    local LATEST_RELEASE_TAG=$(get_latest_github_release_tag "${GH_REPOSITORY_URL}")

    [ "${LATEST_RELEASE_TAG}" == "null" ] && return

    download_plugin_github "${GH_REPOSITORY_URL}" "${LATEST_RELEASE_TAG}" "${PLUGIN_NAME}" "${ASSET_FILE_NAME_PATTERN}"
}
