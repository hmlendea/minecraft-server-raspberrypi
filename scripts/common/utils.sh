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
