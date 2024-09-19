#!/bin/bash
source '/srv/papermc/scripts/common/paths.sh'
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"

DENY_SPAWN_COMMON='"bat","cod","dolphin","drowned","enderman","husk","phantom","salmon","slime","stray","wither","wolf","zombie_villager"'
TELEPORTATION_COMMANDS='"/b","/back","/bed","/home","/homes","/rgtp","rtp","/sethome","/setspawn","/shop","/spawn","/spawnpoint","/tp","/tpa","/tpaccept","/tpahere","/tpask","/tphere","/tpo","/tppos","/tpr","/tprandom","/tpregion","/tprg","/tpyes","/warp","/warps","/wild"'
WORLDGUARD_DIR="$(get_plugin_dir WorldGuard)"

REGIONS_BACKUP_FILE_NAME='regions.bak.yml'
REGIONS_TEMPORARY_FILE_NAME='regions.tmp.yml'
REGIONS_FILE_NAME='regions.yml'

REGIONBOSSBAR_CONFIG_FILE="$(get_plugin_file RegionBossbar config)"

function get_region_ids() {
    local WORLD_NAME="${1}"

    [ -z "${WORLD_NAME}" ] && WORLD_NAME='world'
    local REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_FILE_NAME}"

    grep '^    [a-z][a-z0-9_-]*:$' "${REGIONS_FILE}" | \
        sed 's/^\s*\(.*\):$/\1/g' | \
        sort -h | uniq
}

function get_region_config() {
    local WORLD_NAME="${1}"
    local REGION_ID="${2}"
    local CONFIG_KEY="${3}"

#    CONFIG_KEY=$(sed 's/^\.//g' <<< "${CONFIG_KEY}")

    [ -z "${WORLD_NAME}" ] && WORLD_NAME='world'
    local REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_FILE_NAME}"

    get_config_value "${REGIONS_FILE}" "regions.${REGION_ID}.${CONFIG_KEY}"
}

function does_region_exist() {
    local WORLD_NAME="${1}"
    local REGION_ID="${2}"

    [ -z "${WORLD_NAME}" ] && WORLD_NAME='world'
    local REGIONS_FILE="${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/regions.yml"
    
    grep -q "^\s*${REGION_ID}:" "${REGIONS_FILE}" && return 0
    return 1
}

function region_name_to_id() {
    local REGION_NAME="${1}"
    local REGION_ID="${REGION_NAME}"

    REGION_ID=$(echo "${REGION_NAME}" | \
        iconv -f utf-8 -t ascii//TRANSLIT | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/[_\ ]//g')

    echo "${REGION_ID}"
}

function get_regions_by_pattern() {
    local REGION_ID_PATTERN="${1}"

    cat "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" | \
        grep "^\s*${REGION_ID_PATTERN}:$" | \
        sed 's/\s*\(.*\):$/\1/g'
}

function set_region_bossbar() {
    local WORLD_NAME="${1}"
    local REGION_ID="${2}"
    local REGION_NAME="${3}"
    local REGION_COLOUR="${COLOUR_SETTLEMENT_ALPHANUMERIC}"

    ! is_plugin_installed 'RegionBossbar' && return

    apply_yml_config "${REGIONBOSSBAR_CONFIG_FILE}" 'del(.bossbars[] | select(.regionName == "'"${REGION_ID}"'"))'
    apply_yml_config "${REGIONBOSSBAR_CONFIG_FILE}" '.bossbars += [{color: "'"${REGION_COLOUR}"'", name: "'"${REGION_NAME}"'", regionName: "'"${REGION_ID}"'", style: "SOLID"}]'
}

function set_region_flag() {
    local WORLD_NAME="${1}"
    local REGION_ID="${2}"
    local FLAG="${3}"
    local VALUE="${4}"

    if ! does_region_exist "${WORLD_NAME}" "${REGION_ID}"; then
        echo "ERROR: The '${REGION_ID}' region does not exist!"
        return
    fi
    
    [ "${VALUE}" = 'false' ] && VALUE='deny'
    [ "${VALUE}" = 'true' ] && VALUE='allow'
#    [[ "${VALUE}" == *"&"* ]] && VALUE=$(echo "${VALUE}" | sed 's/&//g')

    set_config_value "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_TEMPORARY_FILE_NAME}" "regions.${REGION_ID}.flags.${FLAG}" "${VALUE}"
#    run_server_command "region flag -w ${WORLD_NAME} ${REGION_ID} ${FLAG} ${VALUE}"
}

function set_region_priority() {
    local WORLD_NAME="${1}"
    local REGION_ID="${2}"
    local PRIORITY="${3}"

    if ! does_region_exist "${WORLD_NAME}" "${REGION_ID}"; then
        echo "ERROR: The '${REGION_ID}' region does not exist!"
        return
    fi

    set_config_value "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_TEMPORARY_FILE_NAME}" "regions.${REGION_ID}.priority" "${PRIORITY}"
}

function get_region_colour() {
    local REGION_TYPE_ID="${1}"
    local COLOUR_REGION="${COLOUR_HIGHLIGHT}"

    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="${REGION_TYPE}"
    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="other"

    if [[ "${REGION_TYPE_ID}" == player_* ]]; then
        COLOUR_REGION="${COLOUR_PLAYER}"
    fi

    if [[ "${REGION_TYPE_ID}" == settlement_* ]]; then
        COLOUR_REGION="${COLOUR_SETTLEMENT}"
    fi

    echo "${COLOUR_REGION}"
}

function get_zone_colour() {
    local REGION_TYPE_ID="${1}"
    local COLOUR_ZONE="${COLOUR_HIGHLIGHT}"

    if [[ "${REGION_TYPE_ID}" == player_* ]]; then
        [[ "${REGION_TYPE_ID}" == player_base ]] && COLOUR_ZONE="${COLOUR_COUNTRY}"
        [[ "${REGION_TYPE_ID}" == player_home* ]] && COLOUR_ZONE="${COLOUR_SETTLEMENT}"
    fi

    if [[ "${REGION_TYPE_ID}" == settlement_* ]]; then
        COLOUR_ZONE="${COLOUR_COUNTRY}"
    fi

    echo "${COLOUR_ZONE}"
}

function set_deny_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"
    local WORLD_NAME='world'

    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="${REGION_TYPE}"
    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="other"

    local COLOUR_REGION="$(get_region_colour ${REGION_TYPE_ID})"
    local COLOUR_ZONE="$(get_zone_colour ${REGION_TYPE_ID})"

    if [ "${LOCALE}" = 'ro' ]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'deny-message' "$(get_formatted_message error ${REGION_TYPE_ID} Nu poți face asta \(${COLOUR_HIGHLIGHT}%what%${COLOUR_MESSAGE}\) în ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'deny-message' "$(get_formatted_message error ${REGION_TYPE_ID} Nu poți face asta \(${COLOUR_HIGHLIGHT}%what%${COLOUR_MESSAGE}\) în ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'deny-message' "$(get_formatted_message error ${REGION_TYPE_ID} Nu poți face asta \(${COLOUR_HIGHLIGHT}%what%${COLOUR_MESSAGE}\) în ${REGION_TYPE} ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'deny-message' "$(get_formatted_message error ${REGION_TYPE_ID} You can\'t ${COLOUR_HIGHLIGHT}%what%${COLOUR_MESSAGE} in the ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'deny-message' "$(get_formatted_message error ${REGION_TYPE_ID} You can\'t ${COLOUR_HIGHLIGHT}%what%${COLOUR_MESSAGE} in the ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'deny-message' "$(get_formatted_message error ${REGION_TYPE_ID} You can\'t f${COLOUR_HIGHLIGHT}%what%${COLOUR_MESSAGE} in the ${REGION_TYPE} of ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    fi
}

function set_teleport_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"
    local WORLD_NAME='world'

    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="${REGION_TYPE}"
    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="teleport"

    local COLOUR_REGION="$(get_region_colour ${REGION_TYPE_ID})"
    local COLOUR_ZONE="$(get_zone_colour ${REGION_TYPE_ID})"

    if [ "${LOCALE}" = 'ro' ]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "teleport-message" "$(get_formatted_message success teleport Te-ai teleportat la ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "teleport-message" "$(get_formatted_message success teleport Te-ai teleportat la ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "teleport-message" "$(get_formatted_message success teleport Te-ai teleportat la ${REGION_TYPE} ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "teleport-message" "$(get_formatted_message success teleport Teleported to the ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "teleport-message" "$(get_formatted_message success teleport Teleported to the ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "teleport-message" "$(get_formatted_message success teleport Teleported to the ${REGION_TYPE} of ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    fi
}

function set_farewell_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"
    local WORLD_NAME='world'

    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="${REGION_TYPE}"
    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="other"

    local COLOUR_REGION="$(get_region_colour ${REGION_TYPE_ID})"
    local COLOUR_ZONE="$(get_zone_colour ${REGION_TYPE_ID})"

    if [[ "${LOCALE}" == "ro" ]]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "farewell" "$(get_formatted_message info ${REGION_TYPE_ID} Ai ieșit din ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "farewell" "$(get_formatted_message info ${REGION_TYPE_ID} Ai ieșit din ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "farewell" "$(get_formatted_message info ${REGION_TYPE_ID} Ai ieșit din ${REGION_TYPE} ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "farewell" "$(get_formatted_message info ${REGION_TYPE_ID} You left the ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "farewell" "$(get_formatted_message info ${REGION_TYPE_ID} You left the ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "farewell" "$(get_formatted_message info ${REGION_TYPE_ID} You left the ${REGION_TYPE} of ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    fi
}

function set_greeting_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"
    local WORLD_NAME='world'

    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="${REGION_TYPE}"
    [ -z "${REGION_TYPE_ID}" ] && REGION_TYPE_ID="other"

    local COLOUR_REGION="$(get_region_colour ${REGION_TYPE_ID})"
    local COLOUR_ZONE="$(get_zone_colour ${REGION_TYPE_ID})"
    
    if [[ "${LOCALE}" == "ro" ]]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'greeting' "$(get_formatted_message info ${REGION_TYPE_ID} Ai intrat în ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'greeting' "$(get_formatted_message info ${REGION_TYPE_ID} Ai intrat în ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'greeting' "$(get_formatted_message info ${REGION_TYPE_ID} Ai intrat în ${REGION_TYPE} ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} din ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'greeting' "$(get_formatted_message info ${REGION_TYPE_ID} You entered the ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'greeting' "$(get_formatted_message info ${REGION_TYPE_ID} You entered the ${COLOUR_REGION}${REGION_TYPE}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        else
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'greeting' "$(get_formatted_message info ${REGION_TYPE_ID} You entered the ${REGION_TYPE} of ${COLOUR_REGION}${REGION_NAME}${COLOUR_MESSAGE} in ${COLOUR_ZONE}${ZONE_NAME})"
        fi
    fi
}

function set_greeting_messages() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"

    set_farewell_message "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"
    set_greeting_message "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"
}

function set_region_messages() {
    local REGION_ID="${1}"
    local REGION_TYPE_ID="${2}"
    local REGION_TYPE="${REGION_TYPE_ID}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"
    
    local USE_GREETINGS=true
    local IS_PRIVATE_REGION=false

    [[ "${*}" == *"--quiet"* ]] && USE_GREETINGS=false

    if [[ "${LOCALE}" == "ro" ]]; then
        [[ "${REGION_TYPE_ID}" == "border_crossing" ]] && REGION_TYPE="punctul vamal"
        [[ "${REGION_TYPE_ID}" == "border_watchtower" ]] && REGION_TYPE="turnul vamal de veghe"
        [[ "${REGION_TYPE_ID}" == "border_wall" ]] && REGION_TYPE="zidul vamal"
        [[ "${REGION_TYPE_ID}" == 'bridge' ]] && REGION_TYPE='podul'
        [[ "${REGION_TYPE_ID}" == "defence_bunker" ]] && REGION_TYPE="buncărul de apărare"
        [[ "${REGION_TYPE_ID}" == "defence_turret" ]] && REGION_TYPE="turela de apărare"
        [[ "${REGION_TYPE_ID}" == "defence_wall" ]] && REGION_TYPE="turela de apărare"
        [[ "${REGION_TYPE_ID}" == "military_base" ]] && REGION_TYPE="baza militară"
        [[ "${REGION_TYPE_ID}" == "player_base" ]] && REGION_TYPE="baza lui"
        [[ "${REGION_TYPE_ID}" == "player_home" ]] && REGION_TYPE="casa lui"
        [[ "${REGION_TYPE_ID}" == "player_home_lake" ]] && REGION_TYPE="casa de pe lac a lui"
        [[ "${REGION_TYPE_ID}" == "player_home_mountain" ]] && REGION_TYPE="casa de pe munte a lui"
        [[ "${REGION_TYPE_ID}" == "road_rail" ]] && REGION_TYPE="calea ferată"
        [[ "${REGION_TYPE_ID}" == "resource_depot" ]] && REGION_TYPE='depozitul de resurse'
        [[ "${REGION_TYPE_ID}" == "settlement_city" ]] && REGION_TYPE="orașul"
        [[ "${REGION_TYPE_ID}" == "settlement_town" ]] && REGION_TYPE="orășelul"
        [[ "${REGION_TYPE_ID}" == "settlement_village" ]] && REGION_TYPE="satul"
        [[ "${REGION_TYPE_ID}" == "station_weather" ]] && REGION_TYPE='stația meteorologică'
        [[ "${REGION_TYPE_ID}" == 'yacht_diplomatic' ]] && REGION_TYPE='iahtul diplomatic'
    else
        [[ "${REGION_TYPE_ID}" == "border_crossing" ]] && REGION_TYPE="border crossing"
        [[ "${REGION_TYPE_ID}" == "border_wall" ]] && REGION_TYPE="border wall"
        [[ "${REGION_TYPE_ID}" == "border_watchtower" ]] && REGION_TYPE="border watchtower"
        [[ "${REGION_TYPE_ID}" == 'bridge' ]] && REGION_TYPE='bridge'
        [[ "${REGION_TYPE_ID}" == "defence_bunker" ]] && REGION_TYPE="defence bunker"
        [[ "${REGION_TYPE_ID}" == "defence_turret" ]] && REGION_TYPE="defence turret"
        [[ "${REGION_TYPE_ID}" == "military_base" ]] && REGION_TYPE="military base"
        [[ "${REGION_TYPE_ID}" == "player_base" ]] && REGION_TYPE="base"
        [[ "${REGION_TYPE_ID}" == "player_home" ]] && REGION_TYPE="home"
        [[ "${REGION_TYPE_ID}" == "player_home_lake" ]] && REGION_TYPE="home on the lake"
        [[ "${REGION_TYPE_ID}" == "player_home_mountain" ]] && REGION_TYPE="home on the mountain"
        [[ "${REGION_TYPE_ID}" == "resource_depot" ]] && REGION_TYPE='resource depot'
        [[ "${REGION_TYPE_ID}" == "road_rail" ]] && REGION_TYPE="railroad"
        [[ "${REGION_TYPE_ID}" == "settlement_city" ]] && REGION_TYPE="city"
        [[ "${REGION_TYPE_ID}" == "settlement_town" ]] && REGION_TYPE="town"
        [[ "${REGION_TYPE_ID}" == 'settlement_village' ]] && REGION_TYPE='village'
        [[ "${REGION_TYPE_ID}" == 'station_weather' ]] && REGION_TYPE='weather station'
        [[ "${REGION_TYPE_ID}" == 'yacht_diplomatic' ]] && REGION_TYPE='diplomatic yacht'
    fi

    set_deny_message "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"
    set_teleport_message "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"

    if ${USE_GREETINGS}; then
        set_greeting_messages "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"
    else
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'greeting' ""
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'farewell' ""
    fi
}

function set_location_region_settings_by_name() {
    local REGION_TYPE_ID="${1}"
    local LOCATION_NAME="${2}"
    local ZONE_NAME="${3}"

    local LOCATION_ID=$(region_name_to_id "${LOCATION_NAME}")
    local ZONE_ID=$(region_name_to_id "${ZONE_NAME}")
    local REGION_ID="${LOCATION_ID}"

    [[ "${REGION_TYPE_ID}" == "military_base" ]] && REGION_ID="${ZONE_ID}_${REGION_TYPE_ID}_${LOCATION_ID}"

    set_location_region_settings_by_id "${REGION_ID}" "${REGION_TYPE_ID}" "${LOCATION_NAME}" "${ZONE_NAME}"
}

function set_location_region_settings_by_id() {
    local REGION_ID="${1}"
    local REGION_TYPE_ID="${2}"
    local LOCATION_NAME="${3}"
    local ZONE_NAME="${4}"

    local WORLD_NAME='world'

    set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'deny-spawn' "[${DENY_SPAWN_COMMON},\"blaze\",\"cave_spider\",\"creeper\",\"skeleton\",\"spider\",\"squid\",\"witch\",\"zombie\"]"

    #set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'ride' true
    #set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'vehicle-destroy' true
    #set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'vehicle-place' true

    if [ -n "${LOCATION_NAME}" ]; then
        set_region_messages "${REGION_ID}" "${REGION_TYPE_ID}" "${LOCATION_NAME}" "${ZONE_NAME}"
    else
        set_region_messages "${REGION_ID}" "${REGION_TYPE_ID}" "" "${ZONE_NAME}" --quiet
    fi

    set_region_priority "${WORLD_NAME}" "${REGION_ID}" 10
}

function set_settlement_region_settings() {
    local WORLD_NAME="${1}"
    local SETTLEMENT_TYPE="${2}"
    local SETTLEMENT_NAME="${3}"
    local COUNTRY_NAME="${4}"
    local SETTLEMENT_ID=$(region_name_to_id "${SETTLEMENT_NAME}")

    set_region_bossbar "${WORLD_NAME}" "${SETTLEMENT_ID}" "${SETTLEMENT_NAME}"

    set_region_flag "${WORLD_NAME}" "${SETTLEMENT_ID}" 'frostwalker' false
    set_region_flag "${WORLD_NAME}" "${SETTLEMENT_ID}" 'sculk-growth' false
    #set_region_flag "${WORLD_NAME}" "${SETTLEMENT_ID}" "interact" true
    set_location_region_settings_by_name "${SETTLEMENT_TYPE}" "${SETTLEMENT_NAME}" "${COUNTRY_NAME}"

    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'airport'                'Airport'                   'Aeroportul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "arena_deathcube"        "DeathCube"                 "DeathCube-ul"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "arena_deathcube_ring"   "DeathCube Ring"            "Ringul DeathCube-ului"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "arena_pvp"              "PvP Arena"                 "Arena PvP"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "arena_pvp_ring"         "PvP Arena Ring"            "Ringul Arenei PvP"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "bank"                   "Bank"                      "Banca"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'baths'                  'Public Baths'              'Băile Publice'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "cemetery"               "Cemetery"                  "Cimitirul"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "church"                 "Church"                    "Biserica"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "consulate_fbu"          "FBU Consulate"             "Consulatul FBU"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "consulate_nucilandia"   "Nucilandian Consulate"     "Consulatul Nucilandiei"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'dock'                   'Docks'                     'Docul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_animals'           "Animal Farm"               "Ferma de Animale"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_chicken'           "Chicken Farm"              "Ferma de Găini"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_crops'             "Crops Farm"                "Ferma Agricolă"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_bambus'            'Bambus Farm'               'Ferma de Bambus'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_blaze'             'Blaze Farm'                'Ferma de Blaze'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_cactus"            "Cactus Farm"               "Ferma de Cactus"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_gunpowder"         "Gunpowder Farm"            "Ferma de Praf de Pușcă"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_iron"              "Iron Farm"                 "Ferma de Fier"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_lava"              "Lava Farm"                 "Ferma de Lavă"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_melon"             "Melon Farm"                "Ferma de Lubenițe"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_pumpkin"           "Pumpkin Farm"              "Ferma de Pumpkin"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_raid"              "Raid Farm"                 "Ferma de Raiduri"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_sniffer"           "Sniffer Farm"              "Ferma de Snifferi"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "farm_squid"             "Squid Farm"                "Ferma de Sepii"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_sugarcane'         'Sugar Cane Farm'           'Ferma de Trestie'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_wool'              'Wool Farm'                 'Ferma de Lână'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_wool'              'Villager Breeder'          'Creșa de Săteni'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_xp'                'XP Farm'                   'Ferma de XP'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_xp_1'              'XP Farm'                   'Ferma de XP'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farm_xp_2'              'XP Farm'                   'Ferma de XP'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'farms'                  'Farms'                     'Fermele'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'forge'                  'Forge'                     'Forja'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'granary'                'Granary'                   'Grânarul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'hall_events'            'Events Hall'               'Sala de Evenimente'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "hall_trading"           "Trading Hall"              "Hala de Comerț"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'hippodrome'             'Hippodrome'                'Hipodromul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "horary"                 "Horary"                    "Horăria"
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'hospital'               'Hospital'                  'Spitalul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'hotel'                  'Hotel'                     'Hotelul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'inn'                    'Inn'                       'Hanul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'library'                'Library'                   'Biblioteca'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'lighthouse'             'Lighthouse'                'Farul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'mall'                   'Mall'                      'Mall-ul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'maze'                   'Labyrinth'                 'Labirintul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'metropolis'             'Metropolis'                'Mitropolia'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'mill'                   'Mill'                      'Moara'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'motel'                  'Motel'                     'Motelul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'museum'                 'Museum'                    'Muzeul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'museum_art'             'Art Museum'                'Muzeul de Artă'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'museum_history'         'History Museum'            'Muzeul de Istorie'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'museum_village'         'Village Museum'            'Muzeul Satului'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'naval_command'          'Naval Command'             'Comandamentul Naval'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'office_post'            'Post Office'               'Oficiul Poștal'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'park'                   'Park'                      'Parcul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'portal_nether'          'Nether Portal'             'Portalul către Nether'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'palace'                 'Palace'                    'Palatul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'prison'                 'Prison'                    'Închisoarea'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'restaurant'             'Restaurant'                'Restaurantul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'school'                 'School'                    'Școala'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'square'                 'Public Square'             'Piața Publică'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'stables'                'Stables'                   'Hedgheria'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'station_fire'           'Fire Station'              'Stația de Pompieri'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'station_national_guard' 'National Guard Station'    'Stația Gărzii Naționale'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'station_police'         'Police Station'            'Stația de Poliție'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'station_train'          'Train Station'             'Gara'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'subway'                 'Subway'                    'Subway-ul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'theatre'                'Theatre'                   'Teatrul'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'courthouse'             'Courthouse'                'Judecătoria'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'university'             'University'                'Universitatea'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'warehouse'              'Warehouse'                 'Magazia'
    set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" 'workshop'               'Workshop'                  'Atelierul'

    if grep -q "^\s*${SETTLEMENT_ID}_player_" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}"; then
        for PLAYER_USERNAME in $(get_players_usernames); do
            set_player_region_settings "${SETTLEMENT_NAME}" "${PLAYER_USERNAME}"
        done
    fi
}

function set_structure_region_settings() {
    local ZONE_NAME="${1}"
    local REGION_TYPE_ID="${2}"
    local ZONE_ID=$(region_name_to_id "${ZONE_NAME}")

    for STRUCTURE_REGION_ID in $(get_regions_by_pattern "${ZONE_ID}_${REGION_TYPE_ID}_.*"); do
        set_location_region_settings_by_id "${STRUCTURE_REGION_ID}" "${REGION_TYPE_ID}" "" "${ZONE_NAME}"
    done
}

function set_building_settings() {
    local WORLD_NAME="${1}"
    local SETTLEMENT_NAME="${2}"
    local BUILDING_ID="${3}"
    local BUILDING_NAME="${4}"
    local BUILDING_NAME_RO="${5}"
    local REGION_PRIORITY=20

    local WORLD_NAME='world'

    local SETTLEMENT_ID=$(region_name_to_id "${SETTLEMENT_NAME}")
    local REGION_ID="${SETTLEMENT_ID}_${BUILDING_ID}"

    ! does_region_exist "${WORLD_NAME}" "${REGION_ID}" && return

    if [ "${BUILDING_ID}" = 'mall' ]; then
        for ((I=1; I<=50; I++)); do
            ! does_region_exist "${WORLD_NAME}" "${SETTLEMENT_ID}_mall_shop${I}" && break
            set_building_settings "${WORLD_NAME}" "${SETTLEMENT_NAME}" "${BUILDING_ID}_shop${I}" "Mall Shop #${I}" "Magazinul #${I} din Mall-ul"
        done
    fi

    if [ "${LOCALE}" = 'ro' ]; then
        set_region_messages "${REGION_ID}" "" "${BUILDING_NAME_RO}" "${SETTLEMENT_NAME}" --quiet
        set_region_bossbar "${WORLD_NAME}" "${REGION_ID}" "${BUILDING_NAME_RO} din ${SETTLEMENT_NAME}"
    else
        set_region_messages "${REGION_ID}" "" "${BUILDING_NAME}" "${SETTLEMENT_NAME}" --quiet
        set_region_bossbar "${WORLD_NAME}" "${REGION_ID}" "The ${BUILDING_NAME} of ${SETTLEMENT_NAME}"
    fi
    
    if [[ "${REGION_ID}" == *_arena_* ]]; then
        REGION_PRIORITY=30

        if [[ "${REGION_ID}" == *_ring ]]; then
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'exit-via-teleport' true
#            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "blocked-cmds" '[${TELEPORTATION_COMMANDS}]'
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "enderpearl" false
            set_region_flag "${WORLD_NAME}" "${REGION_ID}" "chorus-fruit-teleport" false

            REGION_PRIORITY=35

            [[ "${REGION_ID}" == *_deathcube_* ]] && set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'fall-damage' false

            if [[ "${REGION_ID}" == *_pvp_* ]]; then
                set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'keep-exp' true
                set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'keep-inventory' true
                set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'pvp' true
            fi
        fi
    fi

    if [[ "${REGION_ID}" == *_bank* ]]; then
        REGION_PRIORITY=30
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'allow-shop' true
    fi
    
    if [[ "${REGION_ID}" == *_farm_* ]]; then
        REGION_PRIORITY=30
        [[ "${REGION_ID}" == *_blaze ]] && set_region_flag "${WORLD_NAME}" "${REGION_ID}" "deny-spawn" '['"${DENY_SPAWN_COMMON}"',"cave_spider","creeper","skeleton","spider","squid","witch","zombie"]'
        [[ "${REGION_ID}" == *_gunpowder ]] && set_region_flag "${WORLD_NAME}" "${REGION_ID}" "deny-spawn" '['"${DENY_SPAWN_COMMON}"',"blaze","cave_spider","skeleton","spider","squid","zombie"]'
        [[ "${REGION_ID}" =~ _xp$ ]] && set_region_flag "${WORLD_NAME}" "${REGION_ID}" "deny-spawn" '['"${DENY_SPAWN_COMMON}"',"blaze","creeper","squid","witch"]'
        [[ "${REGION_ID}" =~ _xp_[0-9]$ ]] && set_region_flag "${WORLD_NAME}" "${REGION_ID}" "deny-spawn" '['"${DENY_SPAWN_COMMON}"',"blaze","creeper","squid","witch"]'
    fi

    if [[ "${REGION_ID}" == *_hospital ]]; then
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'heal-amount' 1
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'heal-delay' 1
    fi

    if [[ "${REGION_ID}" == *_mall_shop* ]]; then
        REGION_PRIORITY=30
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'allow-shop' true
    fi

    if [[ "${REGION_ID}" == *_square ]]; then
        REGION_PRIORITY=30
    fi

    if [[ "${REGION_ID}" == *_subway ]]; then
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'feed-amount' 1
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'feed-delay' 1
    fi
    
    if [[ "${REGION_ID}" == *_warehouse ]]; then
        #set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'item-drop' false
        set_region_flag "${WORLD_NAME}" "${REGION_ID}" 'item-frame-rotation' false
    fi

    set_region_priority "${WORLD_NAME}" "${REGION_ID}" ${REGION_PRIORITY}
}

function set_player_region_settings() {
    local ZONE_NAME="${1}" && shift
    local MAIN_PLAYER_NAME="${1}" && shift

    local WORLD_NAME='world'

    local ZONE_ID=$(region_name_to_id "${ZONE_NAME}") 

    local PLAYER_REGION_ID=$(region_name_to_id "${MAIN_PLAYER_NAME}")
    local REGION_ID="${ZONE_ID}_player_${PLAYER_REGION_ID}"

    ! does_region_exist "${WORLD_NAME}" "${REGION_ID}" && return

    local PLAYER_NAMES="${MAIN_PLAYER_NAME}"

    while ! string_is_null_or_whitespace "${1}"; do
        PLAYER_NAMES="${PLAYER_NAMES}, ${1}"
        shift
    done

    set_region_bossbar "${WORLD_NAME}" "${REGION_ID}" "Casa lui ${PLAYER_NAMES}"

    if [[ "${ZONE_NAME}" == "Wilderness" ]]; then
        set_region_messages "${REGION_ID}" "player_base" "${PLAYER_NAMES}" "${ZONE_NAME}"
    else
        set_region_messages "${REGION_ID}" "player_home" "${PLAYER_NAMES}" "${ZONE_NAME}" --quiet

        if does_region_exist "${WORLD_NAME}" "${REGION_ID}_lake"; then
            set_region_messages "${REGION_ID}_lake" "player_home_lake" "${PLAYER_NAMES}" "${ZONE_NAME}" --quiet
            set_region_priority "${WORLD_NAME}" "${REGION_ID_lake}" 50
        fi

        if does_region_exist "${WORLD_NAME}" "${REGION_ID}_mountain"; then
            set_region_messages "${REGION_ID}_mountain" "player_home_mountain" "${PLAYER_NAMES}" "${ZONE_NAME}" --quiet
            set_region_priority "${WORLD_NAME}" "${REGION_ID}_mountain" 50
        fi
    fi

    set_region_priority "${WORLD_NAME}" "${REGION_ID}" 50
}