#!/bin/bash
source '/srv/papermc/scripts/common/paths.sh'
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

CURRENCY_SYMBOL='€'
TOTAL_WEALTH=0
DESIRED_TOTAL_WEALTH=3000000

ensure_bin_is_installed 'bc'

CURRENCY_SYMBOL="$(get_yml_value $(get_plugin_dir Essentials)/config.yml currency-symbol)"
[ -z "${CURRENCY_SYMBOL}" ] && CURRENCY_SYMBOL='€'

echo 'Retrieving the wealth of all players...'
for ESSENTIALS_USERDATA_FILE in "$(get_plugin_dir Essentials)/userdata"/*; do
    USER_WEALTH="$(get_yml_value ${ESSENTIALS_USERDATA_FILE} money)"
    TOTAL_WEALTH=$(echo "${TOTAL_WEALTH} + ${USER_WEALTH}" | bc)
done

echo "There's a total of ${CURRENCY_SYMBOL}${TOTAL_WEALTH} circulating in the server's economy"

if (( $(echo "${TOTAL_WEALTH} < ${DESIRED_TOTAL_WEALTH}" | bc -l) )); then
    DEFICIT=$(echo "${DESIRED_TOTAL_WEALTH} - ${TOTAL_WEALTH}" | bc)
    echo "Injecting ${CURRENCY_SYMBOL}${DEFICIT} into the economy, to cover the deficit"
    run_server_command "eco give ${SERVER_NAME} ${DEFICIT}"
fi
