#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"

function get_userdata_prop() {
    local FILE="${1}"
    local PROPERTY="${2}"
    local PROPERTY_ESC=$(echo "${PROPERTY}" | sed -E 's/([^.]+-[^\.\ ]+)(\.|$)/"\1"\2/g')

    yq -r ".${PROPERTY_ESC}" "${FILE}"
}

for USERDATA_FILE in "${ESSENTIALS_DIR}/userdata/"*; do
    PLAYER_UUID=$(basename "${USERDATA_FILE}" .yml)
    PLAYER_NAME=$(get_userdata_prop "${USERDATA_FILE}" "last-account-name")
    PLAYER_LAST_SEEN_TIMESTAMP=$(get_userdata_prop "${USERDATA_FILE}" "timestamps.logout")
    PLAYER_LAST_SEEN_DATE=$(date -u -d @"${PLAYER_LAST_SEEN_TIMESTAMP}" +'%Y-%m-%d %H:%M:%S')
    PLAYER_LAST_IP=$(get_userdata_prop "${USERDATA_FILE}" "ip-address")
    
    echo "${PLAYER_NAME}:"
    echo "   - UUID:      ${PLAYER_UUID}"
    #echo "   - Last seen: ${PLAYER_LAST_SEEN_DATE}"
    echo "   - Last IP:   ${PLAYER_LAST_IP}"
done
