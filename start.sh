PAPER_DIR_PATH=$(pwd)
PAPER_JAR_NAME=$(ls "${PAPER_DIR_PATH}" | grep "paper-[0-9]*.jar" | tail -n 1)
PAPER_JAR_PATH="${PAPER_DIR_PATH}/${PAPER_JAR_NAME}"

TOTAL_RAM=$(cat /proc/meminfo | grep MemTotal | awk '{ print sprintf("%.0f", $2/1024/1024)"G"; }')

if [ "${TOTAL_RAM}" == "8G" ] || \
   [ "${TOTAL_RAM}" == "7G" ]; then
    ALLOCATED_RAM="6G"
elif [ "${TOTAL_RAM}" == "4G" ]; then
    ALLOCATED_RAM="3G"
else
    echo "${TOTAL_RAM} total RAM is not supported!"
    exit 1
fi

function clean-server-properties {
    sleep 2m
    SERVER_PROPERTIES_FILE_PATH="${PAPER_DIR_PATH}/server.properties"
    sed '/^#/d' -i "${SERVER_PROPERTIES_FILE_PATH}"
    sort -o "${SERVER_PROPERTIES_FILE_PATH}" "${SERVER_PROPERTIES_FILE_PATH}"
}

clean-server-properties &

echo "Starting '${PAPER_JAR_PATH}' with ${ALLOCATED_RAM} RAM allocated..."
java \
    -Xms${ALLOCATED_RAM} \
    -Xmx${ALLOCATED_RAM} \
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
    -jar "${PAPER_JAR_PATH}" nogui
