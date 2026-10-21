#!/bin/bash
set -euo pipefail

SERVER_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_SCRIPTS_COMMON_DIR="${SERVER_ROOT_DIR}/scripts/common"

function source() { :; }
builtin source "${SERVER_SCRIPTS_COMMON_DIR}/modrinth.sh"
unset -f source

function curl() {
    printf '%s\n' "${TEST_RESPONSE}"
}

function assert_version() {
    local PROJECT_TYPE="${1}"
    local EXPECTED_VERSION="${2}"
    local TEST_RESPONSE="${3}"
    local ACTUAL_VERSION

    if ! ACTUAL_VERSION=$(get_latest_modrinth_version_id 'fixture' "${PROJECT_TYPE}" 2>&1); then
        printf 'FAIL (%s): lookup failed: %s\n' "${PROJECT_TYPE}" "${ACTUAL_VERSION}" >&2
        exit 1
    fi

    if [[ "${ACTUAL_VERSION}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL (%s): expected <%s>, got <%s>\n' "${PROJECT_TYPE}" "${EXPECTED_VERSION}" "${ACTUAL_VERSION}" >&2
        exit 1
    fi
}

for LOADER in 'paper' 'spigot' 'bukkit' 'datapack'; do
    PROJECT_TYPE='plugin'
    [[ "${LOADER}" == 'datapack' ]] && PROJECT_TYPE='datapack'
    RESPONSE=$(jq -cn --arg loader "${LOADER}" '[
        {id: "missing"},
        {id: "empty", loaders: []},
        {id: "incompatible", loaders: ["fabric"]},
        {id: "newest", loaders: [$loader]},
        {id: "older", loaders: [$loader]}
    ]')
    assert_version "${PROJECT_TYPE}" 'newest' "${RESPONSE}"
done

RESPONSE=$(jq -cn '[range(0; 20000) | {id: ("version-" + tostring), loaders: ["spigot", "datapack"]}]')
for PROJECT_TYPE in 'plugin' 'datapack'; do
    assert_version "${PROJECT_TYPE}" 'version-0' "${RESPONSE}"
    assert_version "${PROJECT_TYPE}" '' '[]'
    assert_version "${PROJECT_TYPE}" '' '[{"id":"incompatible","loaders":["fabric"]}]'
done

assert_version 'other' 'newest' '[{"id":"newest"},{"id":"older"}]'
assert_version 'other' 'null' '[]'
printf 'All Modrinth version lookup tests passed.\n'