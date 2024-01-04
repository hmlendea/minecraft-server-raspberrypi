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

    if [[ "${FILE}" =~ \.(json)$ ]]; then
        set_json_value "${FILE}" "${KEY}" "${VALUE}"
    elif [[ "${FILE}" =~ \.(xml)$ ]]; then
        set_xml_value "${FILE}" "${KEY}" "${VALUE}"
    elif [[ "${FILE}" =~ \.(yml|yaml)$ ]]; then
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

function set_xml_value() {
    local FILE="${1}"
    local NODE_RAW="${2}"
    local VALUE_RAW="${@:3}"

    [ ! -f "${FILE}" ] && return

    local NODE="${NODE_RAW}"
    local NAMESPACE=$(cat "${FILE}" | grep "xmlns=" | sed 's/.*xmlns=\"\([^\"]*\)\".*/\1/g')
    local VALUE=$(echo "${VALUE_RAW}" | sed -e 's/[]\/$*.^|[]/\\&/g')

    if [ -n "${NAMESPACE}" ]; then
        NODE=$(echo "${NODE_RAW}" | sed 's/\/\([^\/]\)/\/x:\1/g')
    fi

    local OLD_VALUE=$(xmlstarlet sel -N x="${NAMESPACE}" -t -v ''"${NODE}"'' -n "${FILE}")

    if [ "${VALUE}" != "${OLD_VALUE}" ]; then
        echo "${FILE} >>> ${NODE_RAW} = ${VALUE}"
        if [ -w "${FILE}" ]; then
            xmlstarlet ed -L -N x="${NAMESPACE}" -u ''"${NODE}"'' -v ''"${VALUE}"'' "${FILE}"
        else
            sudo xmlstarlet ed -L -N x="${NAMESPACE}" -u ''"${NODE}"'' -v ''"${VALUE}"'' "${FILE}"
        fi
    fi
}

function set_yml_value() {
    local FILE="${1}"
    local KEY="${2}"
    local VALUE="${3}"
    
    if [ -z "${VALUE}" ]; then
        delete_yml_setting "${FILE}" "${KEY}"
        return
    fi

    local KEY_ESC="${KEY}"
    local VALUE_ESC="${VALUE}"

    KEY_ESC=$(echo "${KEY}" | sed -E 's/([^\.]+)/"\1"/g; s/\./\./g')
    VALUE_ESC="${VALUE}"

    grep -Eqv "^(\[.*|true|false|[0-9][0-9]*[\.]*[0-9]*)$" <<< "${VALUE}" && VALUE_ESC="\"${VALUE}\""

    echo "${FILE}: ${KEY}=${VALUE}"
    apply_yml_config "${FILE}" ".${KEY_ESC} = ${VALUE_ESC}"
}

function delete_yml_setting() {
    local FILE="${1}"
    local KEY="${2}"

    local KEY_ESC="${KEY}"

    KEY_ESC=$(echo "${KEY}" | sed -E 's/([^\.]+)/"\1"/g; s/\./\./g')

    echo "${FILE}: ${KEY} (delete)"
    apply_yml_config "${FILE}" "del(.${KEY_ESC})"
}

function apply_yml_config() {
    local FILE="${1}"
    local YQ_COMMAND="${2}"

    if [ ! -f "/usr/bin/yq" ]; then
        echo "ERROR: The 'yq' utility is not installed!. Cannot update '${KEY}' in '${FILE}'"
        return
    fi

    if [ -w "${FILE}" ]; then
        yq -yi "${YQ_COMMAND}" "${FILE}"
    else
        sudo yq -yi "${YQ_COMMAND}" "${FILE}"
    fi
}

function set_json_value() {
    local FILE="${1}"
    local KEY="${2}"
    local VALUE="${3}"

    local KEY_ESC="${KEY}"

    KEY_ESC=$(echo "${KEY}" | sed -E 's/([^\.]+)/"\1"/g; s/\./\./g')
    VALUE_ESC="${VALUE}"

    grep -Eqv "^(true|false|[0-9][0-9]*[\.]*[0-9]*)$" <<< "${VALUE}" && VALUE_ESC="\"${VALUE}\""

    if [ ! -f "/usr/bin/jq" ]; then
        echo "ERROR: The 'jq' utility is not installed!. Cannot update '${KEY}' in '${FILE}'"
        return
    fi

    JQ_COMMAND=".${KEY_ESC} = ${VALUE_ESC}"

    if [ -z "${VALUE}" ]; then
        echo "${FILE}: ${KEY} (delete)"
        JQ_COMMAND="del(.${KEY_ESC})"
    else
        echo "${FILE}: ${KEY}=${VALUE}"
    fi

    if [ -w "${FILE}" ]; then
        jq -i "${JQ_COMMAND}" "${FILE}"
    else
        jq "${JQ_COMMAND}" "${FILE}" | sudo tee "${FILE}.tmp" > /dev/null
        cat "${FILE}.tmp" | sudo tee "${FILE}" > /dev/null
        sudo rm "${FILE}.tmp"
    fi
}

function run_server_command() {
    echo " > Running command: /"$*

    if ! ${IS_SERVER_RUNNING}; then
        echo "    > Error: The server is not running!"
        return
    fi
    
    papermc command "$@" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})*)?[m|K]//g"
}

function reload_plugin() {
    local PLUGIN_CMD="${1}"

    ! ${IS_SERVER_RUNNING} && return

    if [[ "${PLUGIN_CMD}" == "luckperms" ]]; then
        run_server_command "${PLUGIN_CMD}" "reloadconfig"
    else
        run_server_command "${PLUGIN_CMD}" "reload"
    fi
}

function set_gamerule() {
    local GAMERULE="${1}"
    local VALUE="${2}"

    #echo " > Setting gamerule '${GAMERULE}' to '${VALUE}'..."
    run_server_command gamerule "${GAMERULE}" "${VALUE}"
}

function get_config_value() {
    local FILE="${1}"
    local KEY="${2}"

    [ ! -f "${FILE}" ] && return

    get_yml_value "${FILE}" "${KEY}"
}

function get_yml_value() {
    local FILE="${1}"
    local KEY="${2}"
    local KEY_ESC=$(echo "${KEY}" | sed -E 's/([^.]+-[^\.\ ]+)(\.|$)/"\1"\2/g')

    yq -r ".${KEY_ESC}" "${FILE}"
}

function check_if_utility_exists() {
    local UTILITY="${1}"

    if [ ! -f "/usr/bin/${UTILITY}" ]; then
        echo "ERROR: The '${UTILITY}' utility must be installed"
        exit 400
    fi
}

check_if_utility_exists "jq"
check_if_utility_exists "xmlstarlet"
check_if_utility_exists "yq"
