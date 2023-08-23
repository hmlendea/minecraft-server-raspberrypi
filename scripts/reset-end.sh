#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/colours.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

sudo mv "${WORLD_END_DIR}/DIM1/region" "${WORLD_END_DIR}/DIM1/region_${TIMESTAMP}"
sudo mkdir "${WORLD_END_DIR}/DIM1/region"

for REGION_FILE_NAME in "r.-1.-1.mca" "r.-1.0.mca" "r.0.-1.mca" "r.0.0.mca"; do
    sudo cp "${WORLD_END_DIR}/DIM1/region_${TIMESTAMP}/${REGION_FILE_NAME}" "${WORLD_END_DIR}/DIM1/region/${REGION_FILE_NAME}"
done
