#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

PLAYER_USERNAME="${1}"

cat "${SERVER_PLUGINS_DIR}/ChestShop/ChestShop.log" | \
    grep " ${PLAYER_USERNAME} \(bought\|sold\)" | \
    sed 's/\(202[0-9]\/[0-9]*\/[0-9]* [0-9]*\:[0-9]*\)\:[0-9]*/\1/g' | \
    sed 's/\.00\b//g' | \
    grep -v "from ${PLAYER_USERNAME}\b" | \
    sed 's/bought/B/g' | \
    sed 's/sold/S/g' | \
    sed 's/ for / = '"${CURRENCY_SYMBOL}"'/g' | \
    sed 's/ at .*//g' | \
    uniq -c | \
    sed -E 's/^\s*([0-9]+) (.*)/\2 (x\1)/' | \
    tail -n 20
