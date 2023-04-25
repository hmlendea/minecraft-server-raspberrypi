#!/bin/bash
source "/srv/papermc/scripts/common/status.sh"

function set_config_values() {
    local FILE="${1}" && shift

    [ ! -f "${FILE}" ] && return

    if [ "$(( $# % 2 ))" -ne 0 ]; then
        echo "ERROR: Invalid arguments count: $# for set_config_values: ${*}" >$2
        return
    fi

    local PAIRS_COUNT=$(($# / 2))

    for PAIR_INDEX in $(seq 1 ${PAIRS_COUNT}); do
        local KEY="${1}" && shift
        local VAL="${1}" && shift

        if [ -n "${KEY}" ]; then
            set_config_value "${FILE}" "${KEY}" "${VAL}"
        fi
    done
}

function set_config_value() {
    local FILE="${1}"
    local KEY="${2}"
    local VALUE="${3}"

    [ ! -f "${FILE}" ] && return

    local KEY_ESC="${KEY}"

    if grep -q "\." <<< "${KEY}"; then
        KEY_ESC=$(echo "${KEY}" | sed -E 's/([^.]+-[^\.\ ]+)(\.|$)/"\1"\2/g')
        
        if [ ! -f "/usr/bin/yq" ]; then
            echo "ERROR: The 'yq' utility is not installed!. Cannot update '${KEY}' in '${FILE}'"
            return
        fi

        echo "${FILE}: ${KEY}=${VALUE}"
        sudo yq -yi ".${KEY_ESC} = ${VALUE}" "${FILE}"
    else
        grep -q "\s${KEY}" "${FILE}" && KEY_ESC="\s${KEY}"

        echo "${FILE}: ${KEY}=${VALUE}"
        sudo sed -i 's/^\(\s*\)\('"${KEY_ESC}"'\)\(\s*[=:]\s*\).*$/\1\2\3'"${VALUE}"'/g' "${FILE}"
    fi
}

function run_server_command() {
    echo " > Running command: /"$*

    if ! ${IS_SERVER_RUNNING}; then
        echo "    > Error: The server is not running!"
        return
    fi
    
    papermc command $* &> /dev/null
}

function reload_plugin() {
    local PLUGIN_CMD="${1}"

    ! ${IS_SERVER_RUNNING} && return

    run_server_command "${PLUGIN_CMD}" "reload"
}

function set_gamerule() {
    local GAMERULE="${1}"
    local VALUE="${2}"

    #echo " > Setting gamerule '${GAMERULE}' to '${VALUE}'..."
    run_server_command gamerule "${GAMERULE}" "${VALUE}"
}
