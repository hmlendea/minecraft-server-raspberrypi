#!/bin/bash
SERVER_ROOT_DIR=$(pwd)
source "${SERVER_ROOT_DIR}/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/status.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

REASON="${*}"
SECONDS_BEFORE_KICK=30

BROADCAST_HEADER_MESSAGE='Attention everyone'
BROADCAST_SHUTDOWN_MESSAGE="${SERVER_NAME} will shut down in a moment"
BROADCAST_KICK_MESSAGE="All online players will be kicked in ${SECONDS_BEFORE_KICK} seconds"
KICK_REASON="${SERVER_NAME} is shutting down"

if [ "${LOCALE}" = 'ro' ]; then
    BROADCAST_HEADER_MESSAGE='Atenție toată lumea'
    BROADCAST_SHUTDOWN_MESSAGE="${SERVER_NAME} se va opri într-un moment"
    BROADCAST_KICK_MESSAGE="Toți jucătorii online vor fi deconectați în ${SECONDS_BEFORE_KICK} secunde"
    KICK_REASON="${SERVER_NAME} se oprește"
fi

if ${IS_SERVER_RUNNING}; then
    run_server_command "essentials:broadcast ${BROADCAST_HEADER_MESSAGE}!"

    send_broadcast_message "${BROADCAST_SHUTDOWN_MESSAGE}..."
    if [ -n "${REASON}" ]; then
        if [ "${LOCALE}" = 'ro' ]; then
            send_broadcast_message "Motiv: ${REASON}"
            KICK_REASON="${KICK_REASON} pentru: ${REASON}"
        else
            send_broadcast_message "Reason: ${REASON}"
            KICK_REASON="${KICK_REASON} due to: ${REASON}"
        fi
    fi

    run_server_command "essentials:broadcast ${BROADCAST_KICK_MESSAGE}!"

    sleep "${SECONDS_BEFORE_KICK}"

    run_server_command kickall "${KICK_REASON}"
    run_server_command save-all
    papermc stop
fi
