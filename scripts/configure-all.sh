#!/bin/bash
# shellcheck disable=SC2046,SC2086
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd | sed 's/\/scripts.*//g')/scripts/common/paths.sh"

sh "${SERVER_SCRIPTS_DIR}/configure-settings.sh"
sh "${SERVER_SCRIPTS_DIR}/configure-localisation.sh"
