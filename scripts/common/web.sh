#!/bin/bash

function download_file() {
    local FILE_URL="${1}"
    local FILE_PATH="${2}"

    [ -f "${FILE_PATH}" ] && return

    sudo wget --quiet "${FILE_URL}" -O "${FILE_PATH}"
    sudo chown papermc:papermc "${FILE_PATH}"
    #sudo chmod +x "${FILE_PATH}"

    if [ -f "${FILE_PATH}" ]; then
        local FILE_SIZE=$(du "${FILE_PATH}" | awk '{print $1}' | head -n 1)
        if [ ${FILE_SIZE} -eq 0 ]; then
            sudo rm "${FILE_PATH}"
        else
            echo " > Downloaded '${FILE_PATH}'"
        fi
    fi
}
