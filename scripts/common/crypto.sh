#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

if ! function_exists "get_player_username"; then
    source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
fi

function decrypt_authme_password() {
    local PLAYER_UUID="${1}"
    local PLAYER_USERNAME=$(get_player_username "${PLAYER_UUID}")
    local CREDENTIAL_VALUE=$(sqlite3 "${AUTHME_DATABASE_FILE}" "SELECT password FROM authme WHERE realname='${PLAYER_USERNAME}';")

    local SALT=""
    local ACTUAL_HASH=""
    local EXPECTED_HASH=""
    local PASSWORD_HASH=""

    for PASSWORD_CANDIDATE in $(cat "${PASSWORDS_DICTIONARY_FILE}"); do
        SALT=$(echo "${CREDENTIAL_VALUE}" | awk -F'$' '{print $3}')
        ACTUAL_HASH=$(echo "${CREDENTIAL_VALUE}" | awk -F'$' '{print $4}')
        PASSWORD_HASH=$(printf "${PASSWORD_CANDIDATE}" | sha256sum | awk '{print $1}')
        EXPECTED_HASH=$(printf "${PASSWORD_HASH}${SALT}" | sha256sum | awk '{print $1}')

        if [[ "${ACTUAL_HASH}" == "${EXPECTED_HASH}" ]]; then
            echo "${PASSWORD_CANDIDATE}"
            return
        fi
    done
}
