#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"

function convert_ticks_to_seconds() {
    local TICKS="${1}"

    echo $((TICKS/20))
}

function convert_ticks_to_duration() {
    local TICKS="${1}"
    local SECONDS=$(convert_ticks_to_seconds ${TICKS})

    echo "${SECONDS}" | awk '{printf "%d hour%s %d minute%s %d second%s\n", $1/3600, ($1/3600)==1?"":"s", ($1%3600)/60, (($1%3600)/60)==1?"":"s", $1%60, ($1%60)==1?"":"s"}'
}

function convert_seconds_to_ticks() {
    local SECONDS="${1}"

    echo $((SECONDS*20))
}

function run_server_command() {
    echo " > Running command: /"$*

    if ! ${IS_SERVER_RUNNING}; then
        echo "    > Error: The server is not running!"
        return
    fi
    
    papermc command "$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})*)?[m|K]//g"
    tput sgr0
}

function send_broadcast_message() {
    local MESSAGE="${1}"

    run_server_command "broadcast" "${MESSAGE}"
}

function is_guid() {
    local GUID="${1}"

    if [[ "${GUID}" =~ ^[[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}$ ]]; then
        return 0 # True
    else
        return 1 # False
    fi
}

function function_exists() {
    local FUNCTION_NAME="${1}"
    
    if ! declare -f "${FUNCTION_NAME}" > /dev/null; then
        return 0
    fi
    
    local SOURCING_FILE=$(declare -f "${FUNCTION_NAME}" | grep -oP "(?<=^# Source file: ).*")

    if [[ -z "${SOURCING_FILE}" ]]; then
        return 0
    fi

    return 1
}

function string_is_null_or_whitespace() {
    [[ -z "${1// }" ]] && return 0
    return 1
}

function find_in_logs() {
    find "${SERVER_LOGS_DIR}" -name "*.log.gz" -exec zgrep -a --color --text "$*" {} +
    grep -a --color --text "$@" "${SERVER_LOGS_DIR}"/*.log
}

function move_file() {
    local OLD_FILE="${1}"
    local NEW_FILE="${2}"

    if [ ! -f "${OLD_FILE}" ]; then
        echo "There is no such file '${OLD_FILE}'!"
        return
    fi

    if [ -f "${NEW_FILE}" ]; then
        echo "The file '${NEW_FILE}' already exists!"
        return
    fi

    echo "Moving '${OLD_FILE}' to '${NEW_FILE}'..."
    sudo mv "${OLD_FILE}" "${NEW_FILE}"
}

function copy_file() {
    local SOURCE_FILE="${1}"
    local TARGET_FILE="${2}"

    if [ ! -f "${SOURCE_FILE}" ]; then
        echo "There is no such file '${SOURCE_FILE}'!"
        return
    fi

    if [ -f "${TARGET_FILE}" ]; then
        echo "The file '${TARGET_FILE}' already exists!"
        return
    fi

    echo "Copying '${SOURCE_FILE}' to '${TARGET_FILE}'..."
    sudo cp "${SOURCE_FILE}" "${TARGET_FILE}"
}

function copy_file_if_needed() {
    local SOURCE_FILE="${1}"
    local TARGET_FILE="${2}"

    if [ ! -f "${SOURCE_FILE}" ]; then
        echo "There is no such file '${SOURCE_FILE}'!"
        return
    fi

    if [ -f "${TARGET_FILE}" ]; then
        return
    fi

    copy_file "${SOURCE_FILE}" "${TARGET_FILE}"
    sudo chown papermc:papermc "${TARGET_FILE}"
}

function create_file() {
    local FILE_PATH="${*}"

    [ -z "${FILE_PATH}" ] && return
    [ -f "${FILE_PATH}" ] && return

    local DIRECTORY_PATH="$(dirname ${FILE_PATH})"

    mkdir -p "${DIRECTORY_PATH}"
    if [ -w "${DIRECTORY_PATH}" ]; then
        touch "${FILE_PATH}"
    else
        sudo touch "${FILE_PATH}"
    fi
}

function ensure_su_access() {
    sudo echo "SU access achieved!"
}

function ensure_bin_is_installed() {
    local BIN_NAME="${1}"

    if [ ! -f "/usr/bin/${BIN_NAME}" ]; then
        echo "ERROR: ${BIN_NAME} is not installed on this system"
        exit 2
    fi
}
