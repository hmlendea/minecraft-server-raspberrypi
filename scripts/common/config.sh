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

    if [[ "${FILE}" =~ \.(yml|yaml)$ ]]; then
        set_yml_value "${FILE}" "${KEY}" "${VALUE}"
    else
        local KEY_ESC="${KEY}"
        grep -q "\s${KEY}" "${FILE}" && KEY_ESC="\s${KEY}"

        echo "${FILE}: ${KEY}=${VALUE}"
        if [ -w "${FILE}" ]; then
            sed -i 's/^\(\s*\)\('"${KEY_ESC}"'\)\(\s*[=:]\s*\).*$/\1\2\3'"${VALUE}"'/g' "${FILE}"
        else
            sudo sed -i 's/^\(\s*\)\('"${KEY_ESC}"'\)\(\s*[=:]\s*\).*$/\1\2\3'"${VALUE}"'/g' "${FILE}"
        fi
    fi
}

function set_yml_value() {
    local FILE="${1}"
    local KEY="${2}"
    local VALUE="${3}"

    local KEY_ESC="${KEY}"

    KEY_ESC=$(echo "${KEY}" | sed -E 's/([^\.]+)/"\1"/g; s/\./\./g')
    VALUE_ESC="${VALUE}"

    grep -Eqv "^(true|false|[0-9][0-9]*[\.]*[0-9]*)$" <<< "${VALUE}" && VALUE_ESC="\"${VALUE}\""

    if [ ! -f "/usr/bin/yq" ]; then
        echo "ERROR: The 'yq' utility is not installed!. Cannot update '${KEY}' in '${FILE}'"
        return
    fi

    YQ_COMMAND=".${KEY_ESC} = ${VALUE_ESC}"

    if [ -z "${VALUE}" ]; then
        echo "${FILE}: ${KEY} (delete)"
        YQ_COMMAND="del(.${KEY_ESC})"
    else
        echo "${FILE}: ${KEY}=${VALUE}"
    fi

    if [ -w "${FILE}" ]; then
        yq -yi "${YQ_COMMAND}" "${FILE}"
    else
        sudo yq -yi "${YQ_COMMAND}" "${FILE}"
    fi
}

function run_server_command() {
    echo " > Running command: /"$*

    if ! ${IS_SERVER_RUNNING}; then
        echo "    > Error: The server is not running!"
        return
    fi
    
    papermc command "$@" &> /dev/null
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
