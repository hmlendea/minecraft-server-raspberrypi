#!/bin/bash
SERVER_ROOT_DIR=$(pwd)
source "${SERVER_ROOT_DIR}/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/status.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

REASON="${*}"
SECONDS_BEFORE_KICK=30

if ${IS_SERVER_RUNNING}; then
    KICK_REASON="Server shutdown"

    run_server_command 'essentials:broadcast Attention everyone!'

    send_broadcast_message "The server will be shutting down in a moment..."
    if [ -n "${REASON}" ]; then
        send_broadcast_message "Reason: ${REASON}"
        KICK_REASON="${KICK_REASON} due to: ${REASON}"
    fi

    run_server_command "essentials:broadcast All online players will be kicked in ${SECONDS_BEFORE_KICK} seconds!"

    sleep "${SECONDS_BEFORE_KICK}"

    run_server_command kickall "${KICK_REASON}"
    run_server_command save-all
    papermc stop
fi
