#!/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd | sed 's/\/scripts.*//g')/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

ID="${1}"
! is_guid "${ID}" && ID=$(get_player_uuid "${ID}")

get_player_info "${ID}"
