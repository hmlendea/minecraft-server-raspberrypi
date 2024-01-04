#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"

MAP_RENDERING_TOGGLE="${1}"

function check_if_webmap_rendering_is_enabled() {
    local MAP_STATUS_RESULT=$(run_server_command map status)

    if grep -q "Actively running renderers" <<< "${MAP_STATUS_RESULT}"; then
        return 0 # True, rendering is enabled
    fi

    return 1 # False, rendering is disabled
}

if $(check_if_webmap_rendering_is_enabled); then
    if [[ "${MAP_RENDERING_TOGGLE}" == "disable" ]]; then
        echo "Disabling webmap rendering..."
        run_server_command map pause
    fi
else
    if [[ "${MAP_RENDERING_TOGGLE}" == "enable" ]]; then
        echo "Enabling webmap rendering..."
        run_server_command map pause
    fi
fi
