#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

function download_file() {
    local FILE_URL="${1}"
    local FILE_PATH="${2}"

    [ -f "${FILE_PATH}" ] && return

    run_with_privileges wget --quiet "${FILE_URL}" -O "${FILE_PATH}"
    run_with_privileges chown minecraft:minecraft "${FILE_PATH}"

    if [ -f "${FILE_PATH}" ]; then
        local FILE_SIZE=$(du "${FILE_PATH}" | awk '{print $1}' | head -n 1)
        if [ ${FILE_SIZE} -eq 0 ]; then
            run_with_privileges rm "${FILE_PATH}"
        else
            echo " > Downloaded '${FILE_PATH}'"
        fi
    fi
}
