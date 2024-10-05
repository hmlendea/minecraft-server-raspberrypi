#!/bin/bash
[ -z "${SERVER_ROOT_DIR}" ] && source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/github.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/modrinth.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/jenkins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/web.sh"

function is_datapack_installed() {
    local DATAPACK_NAME="${1}"

    for FILE in "${SERVER_DATAPACKS_DIR}/${DATAPACK_NAME}"*".zip"; do
        [ -e "${FILE}" ] && return 0
    done
    
    return 1
}

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

    if [ "${PLUGIN_NAME}" = 'Dynmap' ]; then
        PLUGIN_DIR_NAME='dynmap'
    elif [ "${PLUGIN_NAME}" = 'EssentialsX' ]; then
        PLUGIN_DIR_NAME='Essentials'
    elif [ "${PLUGIN_NAME}" = 'Geyser' ]; then
        PLUGIN_DIR_NAME='Geyser-Spigot'
    elif [ "${PLUGIN_NAME}" = 'InvSee++' ]; then
        PLUGIN_DIR_NAME='InvSeePlusPlus'
    elif [ "${PLUGIN_NAME}" = 'NuVotifier' ]; then
        PLUGIN_DIR_NAME='Votifier'
    elif [ "${PLUGIN_NAME}" = 'WolfyUtils' ]; then
        PLUGIN_DIR_NAME='WolfyUtilities'
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
        for FILE_NAME in 'config.yml' 'Config.yml' 'config.json' 'configuration.txt' 'main.yml' 'options.yml' 'Settings.yml' 'settings.yml'; do
            if [ -f "${PLUGIN_DIR}/${FILE_NAME}" ]; then
                PLUGIN_FILE="${PLUGIN_DIR}/${FILE_NAME}"
                break
            fi
        done
    elif [ "${PLUGIN_FILE}" = 'messages' ]; then
        for FILE_NAME in 'i18n/en.properties' 'lang/strings.json' 'languages/lang.en.yml' 'language.yml' 'lang_en.yml' 'messages.yml' 'Messages.yml'; do
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
    local RELOAD_CMD='reload'

    [[ "${PLUGIN_NAME}" = 'GSit' ]] && PLUGIN_CMD='gsitreload' && RELOAD_CMD=''
    [[ "${PLUGIN_NAME}" = 'Chatbubbles' ]] && PLUGIN_CMD='cbreload' && RELOAD_CMD=''
    
    [[ "${PLUGIN_CMD}" = 'anarchyexploitfixes' ]] && PLUGIN_CMD='aef'
    [[ "${PLUGIN_CMD}" = 'chestshopnotifier' ]] && PLUGIN_CMD='csn'
    [[ "${PLUGIN_CMD}" = 'essentialsx' ]] && PLUGIN_CMD='essentials'
    [[ "${PLUGIN_CMD}" = 'invsee++' ]] && PLUGIN_CMD='invsee'
    [[ "${PLUGIN_CMD}" = 'keepinventorycost' ]] && PLUGIN_CMD='keepinventoryadmin'
    [[ "${PLUGIN_CMD}" = 'luckperms' ]] && RELOAD_CMD='reloadconfig'
    [[ "${PLUGIN_CMD}" = 'votingplugin' ]] && PLUGIN_CMD='av'

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

function transform_plugin_asset_file_name() {
    local ASSET_FILE_NAME_PATTERN="${1}"
    local NAME="${2}"
    local VERSION="${3}"
    
    echo "${ASSET_FILE_NAME_PATTERN}" | sed \
            -e 's/%dataPackName%/'"${NAME}"'/g' \
            -e 's/%dataPackVersion%/'"${VERSION}"'/g' \
            -e 's/%pluginName%/'"${NAME}"'/g' \
            -e 's/%pluginVersion%/'"${VERSION}"'/g'
}

function download_datapack() {
    local ASSET_URL="${1}"
    local DATAPACK_NAME="${2}"
    local DATAPACK_VERSION="${3}"
    local DATAPACK_FILE_NAME="${DATAPACK_NAME}-${DATAPACK_VERSION}.zip"
    local DATAPACK_FILE_PATH="${SERVER_DATAPACKS_DIR}/${DATAPACK_FILE_NAME}"

    if [ -f "${SERVER_DATAPACKS_DIR}/${DATAPACK_NAME}-"*".zip" ] && \
       [ ! -f "${DATAPACK_FILE_PATH}" ]; then
        sudo rm "${SERVER_DATAPACKS_DIR}/${DATAPACK_NAME}-"*".zip"
    fi

    download_file "${ASSET_URL}" "${DATAPACK_FILE_PATH}"
}

function download_plugin() {
    local ASSET_URL="${1}"
    local PLUGIN_NAME="${2}"
    local PLUGIN_VERSION="${3}"
    local PLUGIN_FILE_NAME="${PLUGIN_NAME}-${PLUGIN_VERSION}.jar"
    local PLUGIN_FILE_TEMP_PATH="${SERVER_PLUGINS_TEMP_DIR}/${PLUGIN_FILE_NAME}"
    local PLUGIN_FILE_PATH="${SERVER_PLUGINS_DIR}/${PLUGIN_FILE_NAME}"

    [ -f "${PLUGIN_FILE_PATH}" ] && return
    [ ! -d "${SERVER_PLUGINS_TEMP_DIR}" ] && sudo mkdir -p "${SERVER_PLUGINS_TEMP_DIR}"

    download_file "${ASSET_URL}" "${PLUGIN_FILE_TEMP_PATH}"

    if [ -f "${PLUGIN_FILE_TEMP_PATH}" ]; then
        if ls "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}-"*'.jar' 1> /dev/null 2>&1; then
            sudo rm "${SERVER_PLUGINS_DIR}/${PLUGIN_NAME}-"*'.jar'
        fi

        sudo mv "${PLUGIN_FILE_TEMP_PATH}" "${PLUGIN_FILE_PATH}"
        sudo chown papermc:papermc "${PLUGIN_FILE_PATH}"
        sudo chmod +x "${PLUGIN_FILE_PATH}"
    fi
}

function update_datapack() {
    local DATAPACK_NAME="${1}"

    ! is_datapack_installed "${DATAPACK_NAME}" && return

    local URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"
    [ -z "${ASSET_FILE_NAME_PATTERN}" ] && ASSET_FILE_NAME_PATTERN="%datapackName%-%datapackVersion%.zip"

    echo "Checking for updates for datapack '${DATAPACK_NAME}'..."
    if [[ ${URL} == *"modrinth"* ]]; then
        update_datapack_modrinth "${DATAPACK_NAME}" "${URL}" "${ASSET_FILE_NAME_PATTERN}"
    fi
}

function update_plugin() {
    local PLUGIN_NAME="${1}"

    ! is_plugin_installed "${PLUGIN_NAME}" && return

    local URL="${2}"
    local ASSET_FILE_NAME_PATTERN="${3}"
    [ -z "${ASSET_FILE_NAME_PATTERN}" ] && ASSET_FILE_NAME_PATTERN="%pluginName%-%pluginVersion%.jar"

    echo "Checking for updates for plugin '${PLUGIN_NAME}'..."
    if [[ ${URL} == *'github'* ]]; then
        update_plugin_github "${PLUGIN_NAME}" "${URL}" "${ASSET_FILE_NAME_PATTERN}"
    elif [[ ${URL} == *'modrinth'* ]]; then
        update_plugin_modrinth "${PLUGIN_NAME}" "${URL}" "${ASSET_FILE_NAME_PATTERN}"
    else
        update_plugin_jenkins "${PLUGIN_NAME}" "${URL}" "${ASSET_FILE_NAME_PATTERN}"
    fi
}

