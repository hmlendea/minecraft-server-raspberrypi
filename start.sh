PAPER_DIR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ALLOCATED_RAM_GB=3

PAPER_BIN_PATH="${PAPER_DIR_PATH}/papermc_server.jar"
[ ! -f "${PAPER_BIN_PATH}" ] && PAPER_BIN_PATH=$(ls "${PAPER_DIR_PATH}" | grep "paper-[0-9]*.jar" | tail -n 1)
[ ! -f "${PAPER_BIN_PATH}" ] && PAPER_BIN_PATH=$(ls "${PAPER_DIR_PATH}" | grep "papermc\.[0-9]\.[0-9]*\.[0-9]+[a-z][0-9]*\.jar" | tail -n 1)
[ -f "${PAPER_DIR_PATH}/${PAPER_BIN_PATH}" ] && PAPER_BIN_PATH=${PAPER_DIR_PATH}/${PAPER_BIN_PATH}

cd "${PAPER_DIR_PATH}"

echo "Starting '${PAPER_BIN_PATH}' with ${ALLOCATED_RAM_GB}GB RAM allocated..."
java \
    -Xms${ALLOCATED_RAM_GB}G \
    -Xmx${ALLOCATED_RAM_GB}G \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar ${PAPER_BIN_PATH} nogui

# Clean server.properties
SERVER_PROPERTIES_FILE_PATH="${PAPER_DIR_PATH}/server.properties"
sed '/^#/d' -i "${SERVER_PROPERTIES_FILE_PATH}"
sort -o "${SERVER_PROPERTIES_FILE_PATH}" "${SERVER_PROPERTIES_FILE_PATH}"
