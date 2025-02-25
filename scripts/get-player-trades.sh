#!/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd | sed 's/\/scripts.*//g')/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"

PLAYER_USERNAME="${1}"

RAN_AS_GAME_COMMAND=false
    
if [ -t 0 ] && [ -t 1 ]; then
    RAN_AS_GAME_COMMAND=false
else
    RAN_AS_GAME_COMMAND=true
fi

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
    tail -n 17 | while read -r TRANSACTION; do
        TRANSACTION_DATE="$(awk '{print $1, $2}' <<< ${TRANSACTION})"
        TRANSACTION_PLAYER="$(awk '{print $3}' <<< ${TRANSACTION})"
        TRANSACTION_PLAYER_OTHER="$(awk -F= '{print $2}' <<< ${TRANSACTION} | awk '{print $3}')"
        TRANSACTION_TYPE="$(awk '{print $4}' <<< ${TRANSACTION})"
        TRANSACTION_ITEM_QUANTITY="$(awk '{print $5}' <<< ${TRANSACTION})"
        TRANSACTION_ITEM_NAME="$(sed 's/.*[A-Za-z0-9_][A-Za-z0-9_]* [BS] [1-9][0-9]* \(.*\) =.*/\1/g' <<< ${TRANSACTION})"
        TRANSACTION_AMOUNT="$(sed 's/.*₦\([1-9][0-9]*\).*/\1/g' <<< ${TRANSACTION})"
        TRANSACTION_TIMES="$(sed 's/.*(x\([1-9][0-9]*\))$/\1/g' <<< ${TRANSACTION})"

        TRANSACTION_DATE="${TRANSACTION_DATE:2}"
        TRANSACTION_ITEM_QUANTITY=$((TRANSACTION_ITEM_QUANTITY * TRANSACTION_TIMES))
        TRANSACTION_AMOUNT=$((TRANSACTION_AMOUNT * TRANSACTION_TIMES))

        TRANSACTION_DIRECTION='from'
        [ "${TRANSACTION_TYPE}" = 'S' ] && TRANSACTION_DIRECTION='to'

        if ${RAN_AS_GAME_COMMAND}; then
            AMOUNT_PREFIX="${COLOUR_MONEY}+"
            [ "${TRANSACTION_TYPE}" = 'B' ] && AMOUNT_PREFIX="${COLOUR_RED}-"
            echo "${COLOUR_MESSAGE}${TRANSACTION_DATE} ${COLOUR_PLAYER}${TRANSACTION_PLAYER_OTHER}${COLOUR_MESSAGE} ${COLOUR_HIGHLIGHT}${TRANSACTION_ITEM_QUANTITY}x ${TRANSACTION_ITEM_NAME} ${COLOUR_MESSAGE}(${AMOUNT_PREFIX}₦${TRANSACTION_AMOUNT}${COLOUR_MESSAGE})${COLOUR_RESET}" | sed 's/§/$CLR/g'
        else
            echo -e "${COLOUR_MESSAGE_SHELL}${TRANSACTION_DATE} ${TRANSACTION_TYPE} ${COLOUR_PLAYER_SHELL}${TRANSACTION_PLAYER_OTHER}${COLOUR_MESSAGE_SHELL} ${TRANSACTION_ITEM_QUANTITY} ${TRANSACTION_ITEM_NAME} = ${COLOUR_MONEY_SHELL}₦${TRANSACTION_AMOUNT}${COLOUR_RESET_SHELL}"
        fi
    done
