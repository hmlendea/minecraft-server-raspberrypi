#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/colours.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="${WORLD_END_DIR}/DIM1/region_${TIMESTAMP}"

function clear_region() {
    local X="${1}"
    local Y="${2}"
    
    local REGION_X=$((X / 512))
    local REGION_Y=$((Y / 512))

    [ ${X} -lt 0 ] && REGION_X=$((REGION_X - 1))
    [ ${Y} -lt 0 ] && REGION_X=$((REGION_Y - 1))

    local REGION_FILE_NAME="r.${REGION_X}.${REGION_Y}.mca"

    [ X == "-1" ] && [ Y == "-1" ] && return
    [ X == "-1" ] && [ Y == "0" ] && return
    [ X == "0" ] && [ Y == "-1" ] && return
    [ X == "0" ] && [ Y == "0" ] && return

    local REGION_FILE="${WORLD_END_DIR}/DIM1/region/${REGION_FILE_NAME}"

    #echo "${X} ${Y} is ${REGION_X}.${REGION_Y} from the End dimension..."
    [ ! -f "${REGION_FILE}" ] && return

    echo "Removing region ${REGION_X}.${REGION_Y} from the End dimension..."
    [ ! -d "${BACKUP_DIR}" ] && sudo mkdir "${BACKUP_DIR}"
    sudo mv "${REGION_FILE}" "${BACKUP_DIR}/${REGION_FILE_NAME}"
}

# End cities
clear_region "-2210" "2325"
clear_region "-1230" "2036"
clear_region "-1555" "335"
clear_region "-550" "1080"
clear_region "-300" "-1500"
clear_region "450" "3315"
clear_region "735" "1380"
clear_region "1635" "2645"
clear_region "1665" "2600"
clear_region "2325" "760"
clear_region "2330" "750"
clear_region "2900" "4565"
