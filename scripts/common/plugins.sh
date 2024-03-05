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

function reload_plugin() {
    local PLUGIN_NAME="${1}"

    ! ${IS_SERVER_RUNNING} && return
    ! is_plugin_installed "${PLUGIN_NAME}" && return
    
    local PLUGIN_CMD="${PLUGIN_NAME,,}"
    local RELOAD_CMD="reload"

    [[ "${PLUGIN_CMD}" == "essentialsx" ]] && PLUGIN_CMD="essentials"
    [[ "${PLUGIN_CMD}" == "invsee++" ]] && PLUGIN_CMD="invsee"
    [[ "${PLUGIN_CMD}" == "votingplugin" ]] && PLUGIN_CMD="av"

    [[ "${PLUGIN_CMD}" == "luckperms" ]] && RELOAD_CMD="reloadconfig"

    run_server_command "${PLUGIN_CMD}" "${RELOAD_CMD}"
}

function configure_plugin() {
    local PLUGIN_NAME="${1}" && shift
	local PLUGIN_CONFIG_FILE="${1}" && shift

    ! is_plugin_installed "${PLUGIN_NAME}" && return
	[ ! -f "${PLUGIN_CONFIG_FILE}" ] && return

	set_config_values "${PLUGIN_CONFIG_FILE}" "${@}"
	reload_plugin "${PLUGIN_NAME}"
}
