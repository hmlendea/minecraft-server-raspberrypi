#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/web.sh"

function get_latest_jenkins_build_version() {
    local BASE_URL="${1}"
    local JOB_NAME="${2}"

    local REQUEST_URL="${BASE_URL}/job/${JOB_NAME}/lastSuccessfulBuild/api/json"
    local BUILD_ID=$(curl -s "${REQUEST_URL}" | jq -r '.id')

    local ARTIFACT_LIST=$(curl -s "${REQUEST_URL}" | jq -r '.artifacts[] | .fileName')
    local ARTIFACT_VERSION=$(echo "${ARTIFACT_LIST}" | \
                             head -n 1 | \
                             sed \
                                -e 's/'"${JOB_NAME}"'[\_\-]//g' \
                                -e 's/\(Bukkit\|Spigot\)//g' \
                                -e 's/^-//g' \
                                -e 's/\.jar$//g' \
                                -e 's/^v//g')

    if [[ "${JOB_NAME}" == "${ARTIFACT_VERSION}"* ]]; then
        ARTIFACT_VERSION="build${BUILD_ID}"
    fi

    echo "${ARTIFACT_VERSION}"
}

function download_plugin_jenkins() {
    local JENKINS_BASE_URL="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"
    local ARTIFACT_FILE_NAME=$(transform_asset_file_name "${4}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}")
    local ARTIFACT_NAME=""

    local PLUGIN_FILE_NAME="${PLUGIN_NAME}-${PLUGIN_VERSION}.jar"
    local PLUGIN_FILE_PATH="${SERVER_PLUGINS_DIR}/${PLUGIN_FILE_NAME}"

    [ "${PLUGIN_NAME}" = 'spark' ] && ARTIFACT_NAME='spark-bukkit'

    download_plugin "${JENKINS_BASE_URL}/job/${PLUGIN_NAME}/lastSuccessfulBuild/artifact/${ARTIFACT_NAME}/build/libs/${ARTIFACT_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"

    if [ ! -f "${PLUGIN_FILE_PATH}" ]; then
        download_plugin "${JENKINS_BASE_URL}/job/${PLUGIN_NAME}/lastSuccessfulBuild/artifact/artifacts/${ARTIFACT_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
    fi

    if [ ! -f "${PLUGIN_FILE_PATH}" ]; then
        download_plugin "${JENKINS_BASE_URL}/job/${PLUGIN_NAME}/lastSuccessfulBuild/artifact/target/${ARTIFACT_FILE_NAME}" "${PLUGIN_NAME}" "${PLUGIN_VERSION}"
    fi
}

function update_plugin_jenkins() {
    local PLUGIN_NAME="${1}"
    local JENKINS_BASE_URL="${2}"
    local ARTIFACT_FILE_NAME_PATTERN="${3}"
    local LATEST_BUILD_VERSION=$(get_latest_jenkins_build_version "${JENKINS_BASE_URL}" "${PLUGIN_NAME}")

    [ -z "${LATEST_BUILD_VERSION}" ] && return

    download_plugin_jenkins "${JENKINS_BASE_URL}" "${PLUGIN_NAME}" "${LATEST_BUILD_VERSION}" "${ARTIFACT_FILE_NAME_PATTERN}"
}

function transform_asset_file_name() {
    local ASSET_FILE_NAME_PATTERN="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"

    echo "${ASSET_FILE_NAME_PATTERN}" | sed \
            -e 's/%pluginName%/'"${PLUGIN_NAME}"'/g' \
            -e 's/%pluginVersion%/'"${PLUGIN_VERSION}"'/g'
}
