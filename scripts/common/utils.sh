#!/bin/bash

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

function move-file() {
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
