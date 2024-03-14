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

function ensure_plugin_is_installed() {
    local PLUGIN_NAME="${1}"

    if ! is_plugin_installed "${PLUGIN_NAME}"; then
        echo "ERROR: ${PLUGIN_NAME} is not installed!"
        exit 1
    fi
}

function get_plugin_dir() {
    local PLUGIN_NAME="${1}"
    local PLUGIN_DIR_NAME="${PLUGIN_NAME}"

    if [ "${PLUGIN_NAME}" == "Dynmap" ]; then
        PLUGIN_DIR_NAME="dynmap"
    elif [ "${PLUGIN_NAME}" == "EssentialsX" ]; then
        PLUGIN_DIR_NAME="Essentials"
    elif [ "${PLUGIN_NAME}" == "InvSee++" ]; then
        PLUGIN_DIR_NAME="InvSeePlusPlus"
    elif [ "${PLUGIN_NAME}" == "NuVotifier" ]; then
        PLUGIN_DIR_NAME="Votifier"
    elif [ "${PLUGIN_NAME}" == "WolfyUtils" ]; then
        PLUGIN_DIR_NAME="WolfyUtilities"
    fi

    echo "${SERVER_PLUGINS_DIR}/${PLUGIN_DIR_NAME}"
}

function get_plugin_file() {
    local PLUGIN_NAME="${1}" && shift
    ! is_plugin_installed "${PLUGIN_NAME}" && return

    local PLUGIN_DIR="$(get_plugin_dir ${PLUGIN_NAME})"
    [ ! -d "${PLUGIN_DIR}" ] && return

	local PLUGIN_FILE="${1}" && shift

    if [ -f "${PLUGIN_FILE}" ]; then
        PLUGIN_FILE="${PLUGIN_FILE}"
    elif [ -f "${PLUGIN_DIR}/${PLUGIN_FILE}" ]; then
        PLUGIN_FILE="${PLUGIN_DIR}/${PLUGIN_FILE}"
    elif [ "${PLUGIN_FILE}" == "config" ]; then
        for FILE_NAME in "config.yml" "Config.yml" "config.json" "configuration.txt" "main.yml" "options.yml" "Settings.yml"; do
            if [ -f "${PLUGIN_DIR}/${FILE_NAME}" ]; then
                PLUGIN_FILE="${PLUGIN_DIR}/${FILE_NAME}"
                break
            fi
        done
    elif [ "${PLUGIN_FILE}" == "messages" ]; then
        for FILE_NAME in "lang/strings.json" "language.yml" "messages.yml" "Messages.yml"; do
            if [ -f "${PLUGIN_DIR}/${FILE_NAME}" ]; then
                PLUGIN_FILE="${PLUGIN_DIR}/${FILE_NAME}"
                break
            fi
        done
    fi

    echo "${PLUGIN_FILE}"
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

	local PLUGIN_FILE="$(get_plugin_file ${PLUGIN_NAME} ${1})" && shift
    [ ! -f "${PLUGIN_FILE}" ] && return

	set_config_values "${PLUGIN_FILE}" "${@}"
	reload_plugin "${PLUGIN_NAME}"
}
