#!/bin/bash
SERVER_ROOT_DIR=$(pwd)
source "${SERVER_ROOT_DIR}/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/status.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

REASON="${*}"

if ${IS_SERVER_RUNNING}; then
    send_broadcast_message "The server shutting down..."
    [ -n "${REASON}" ] && send_broadcast_message "Reason: ${REASON}"

    papermc stop
fi
