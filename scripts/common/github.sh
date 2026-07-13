#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "$(dirname "${BASH_SOURCE[0]}" | xargs realpath | sed 's/\/scripts.*//g')/scripts/common/paths.sh"

function get_latest_github_release_tag() {
    local REPOSITORY_URL="${1}"
    local ALLOW_PRERELEASES="${2:-false}"

    local GH_USERNAME
    local GH_REPOSITORY_NAME

    GH_USERNAME=$(basename "$(dirname "${REPOSITORY_URL}")")
    GH_REPOSITORY_NAME=$(basename "${REPOSITORY_URL}")
    GH_REPOSITORY_NAME="${GH_REPOSITORY_NAME%.git}"

    local RELEASES_API="https://api.github.com/repos/${GH_USERNAME}/${GH_REPOSITORY_NAME}/releases"
    local TAGS_API="https://api.github.com/repos/${GH_USERNAME}/${GH_REPOSITORY_NAME}/tags"

    local RELEASES_RESPONSE
    RELEASES_RESPONSE=$(curl -s "${RELEASES_API}")

    echo "=== RELEASES RAW ===" >&2
    echo "${RELEASES_RESPONSE}" >&2

    local RELEASES_TYPE
    RELEASES_TYPE=$(echo "${RELEASES_RESPONSE}" | jq -r 'type')

    if [ "${RELEASES_TYPE}" = "array" ] && \
       [ "$(echo "${RELEASES_RESPONSE}" | jq 'length')" -gt 0 ]; then

        if ${ALLOW_PRERELEASES}; then
            echo "${RELEASES_RESPONSE}" | jq -r '
                sort_by(.published_at)
                | last
                | .tag_name
            '
        else
            echo "${RELEASES_RESPONSE}" | jq -r '
                map(select(.prerelease == false))
                | sort_by(.published_at)
                | last
                | .tag_name
            '
        fi

        return
    fi

    local TAGS_RESPONSE
    TAGS_RESPONSE=$(curl -s "${TAGS_API}")

    echo "=== TAGS RAW ===" >&2
    echo "${TAGS_RESPONSE}" >&2

    local TAGS_TYPE
    TAGS_TYPE=$(echo "${TAGS_RESPONSE}" | jq -r 'type')

    if [ "${TAGS_TYPE}" = "array" ] && \
       [ "$(echo "${TAGS_RESPONSE}" | jq 'length')" -gt 0 ]; then

        echo "${TAGS_RESPONSE}" | jq -r '.[0].name'
    fi
}

function download_plugin_github() {
    local REPOSITORY_URL="${1}"
    local RELEASE_TAG="${2}"
    local PLUGIN_NAME="${3}"
    local PLUGIN_VERSION=$(echo "${RELEASE_TAG}" | sed 's/^\s*v//g')
    local ASSET_FILE_NAME=$(transform_asset_file_name "${4}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}")

    local DOWNLOAD_URL="${REPOSITORY_URL}/releases/download/${RELEASE_TAG}/${ASSET_FILE_NAME}"

    echo "TAG: ${RELEASE_TAG}"
    echo "ASSET: ${ASSET_FILE_NAME}"
    echo "URL: ${DOWNLOAD_URL}"

    download_plugin "${DOWNLOAD_URL}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
}

function update_plugin_github() {
    local PLUGIN_NAME="${1}"
    local GH_REPOSITORY_URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"
    local ALLOW_PRERELEASES="${4:-false}"

    local LATEST_RELEASE_TAG=$(
        get_latest_github_release_tag \
            "${GH_REPOSITORY_URL}" \
            "${ALLOW_PRERELEASES}"
    )

    echo $PLUGIN_NAME $LATEST_RELEASE_TAG

    [ "${LATEST_RELEASE_TAG}" == "null" ] && return
    [ -z "${LATEST_RELEASE_TAG}" ] && return

    download_plugin_github \
        "${GH_REPOSITORY_URL}" \
        "${LATEST_RELEASE_TAG}" \
        "${PLUGIN_NAME}" \
        "${ASSET_FILE_NAME_PATTERN}"
}
