#!/bin/bash
# shellcheck disable=SC2046,SC2086
source "/srv/papermc/scripts/common/paths.sh"

sh "${SERVER_SCRIPTS_DIR}/configure-settings.sh"
sh "${SERVER_SCRIPTS_DIR}/configure-localisation.sh"
