#!/bin/bash
SERVER_ROOT_DIR=$(pwd)
source "${SERVER_ROOT_DIR}/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/status.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

REASON="${*}"

if ${IS_SERVER_RUNNING}; then
    KICK_REASON="Server shutdown"
    send_broadcast_message "The server shutting down..."

    if [ -n "${REASON}" ]; then
        send_broadcast_message "Reason: ${REASON}"
        KICK_REASON="${KICK_REASON} due to: ${REASON}"
    fi

    run_server_command kickall "${KICK_REASON}"
    papermc stop
fi
