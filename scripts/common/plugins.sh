#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"

function is_plugin_installed() {
    local PLUGIN_NAME="${1}"

    for FILE in "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}"*".jar"; do
        [ -e "${FILE}" ] && return 0
    done
    
    return 1
}

function is_plugin_installed_bool() {
    local PLUGIN_NAME="${1}"

    if is_plugin_installed "${PLUGIN_NAME}"; then
        echo "true"
    else
        echo "false"
    fi
}

function is_plugin_not_installed_bool() {
    local PLUGIN_NAME="${1}"

    if is_plugin_installed "${PLUGIN_NAME}"; then
        echo "false"
    else
        echo "true"
    fi
}

function reload_plugin() {
    local PLUGIN_NAME="${1}"

    ! ${IS_SERVER_RUNNING} && return
    ! is_plugin_installed "${PLUGIN_NAME}" && return
    
    local PLUGIN_CMD="${PLUGIN_NAME,,}"
    local RELOAD_CMD="reload"

    [[ "${PLUGIN_NAME}" == "GSit" ]] && PLUGIN_CMD="gsitreload" && RELOAD_CMD=""

    [[ "${PLUGIN_CMD}" == "essentialsx" ]] && PLUGIN_CMD="essentials"
    [[ "${PLUGIN_CMD}" == "invsee++" ]] && PLUGIN_CMD="invsee"
    [[ "${PLUGIN_CMD}" == "votingplugin" ]] && PLUGIN_CMD="av"

    [[ "${PLUGIN_CMD}" == "luckperms" ]] && RELOAD_CMD="reloadconfig"

    run_server_command "${PLUGIN_CMD}" "${RELOAD_CMD}"
}

function configure_plugin() {
    local PLUGIN_NAME="${1}" && shift

    ! is_plugin_installed "${PLUGIN_NAME}" && return

	local PLUGIN_CONFIG_FILE="${1}" && shift

    if [ "${PLUGIN_CONFIG_FILE}" == "config" ]; then
        for FILE_NAME in "config.yml" "Config.yml" "config.json" "main.yml" "options.yml"; do
            if [ -f "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}/${FILE_NAME}" ]; then
                PLUGIN_CONFIG_FILE="${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}/${FILE_NAME}"
                break
            fi
        done
    elif [ "${PLUGIN_CONFIG_FILE}" == "messages" ]; then
        for FILE_NAME in "language.yml" "messages.yml"; do
            if [ -f "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}/${FILE_NAME}" ]; then
                PLUGIN_CONFIG_FILE="${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}/${FILE_NAME}"
                break
            fi
        done
    fi

    [ ! -f "${PLUGIN_CONFIG_FILE}" ] && return

	set_config_values "${PLUGIN_CONFIG_FILE}" "${@}"
	reload_plugin "${PLUGIN_NAME}"
}
