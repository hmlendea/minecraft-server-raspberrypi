#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"

if [ ! -d "${WORLDGUARD_DIR}" ]; then
    echo "ERROR: The WorldGuard plugin is not installed!"
    exit 1
fi

function does_region_exist() {
    local REGION_ID="${1}"
    
    grep -q "^\s*${REGION_ID}:" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" && return 0
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

function set_region_flag() {
    local REGION_ID="${1}"
    local FLAG="${2}"
    local VALUE="${3}"

    if ! does_region_exist "${REGION_ID}"; then
        echo "ERROR: The '${REGION_ID}' region does not exist!"
        return
    fi
    
    [[ "${VALUE}" == "false" ]] && VALUE="deny"
    [[ "${VALUE}" == "true" ]] && VALUE="allow"
#    [[ "${VALUE}" == *"&"* ]] && VALUE=$(echo "${VALUE}" | sed 's/&//g')

    set_config_value "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" "regions.${REGION_ID}.flags.${FLAG}" "${VALUE}"
#    run_server_command "region flag -w ${WORLD_NAME} ${REGION_ID} ${FLAG} ${VALUE}"
}

function set_region_priority() {
    local REGION_ID="${1}"
    local PRIORITY="${2}"

    if ! does_region_exist "${REGION_ID}"; then
        echo "ERROR: The '${REGION_ID}' region does not exist!"
        return
    fi

    set_config_value "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" "regions.${REGION_ID}.priority" "${PRIORITY}"
}

function set_deny_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"

    if [[ "${LOCALE}" == "ro" ]]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}Nu poți să faci asta (%what%) în ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}Nu poți să faci asta (%what%) în ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}Nu poți să faci asta (%what%) în ${REGION_TYPE} ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}You can't %what% in the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}You can't %what% in the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}You can't %what% in the ${REGION_TYPE} of ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}

function set_teleport_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"

    if [[ "${LOCALE}" == "ro" ]]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Te teleportezi la ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Te teleportezi la ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Te teleportezi la ${REGION_TYPE} ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Whisking ye away to the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Whisking ye away to the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Whiskin ye away to the ${REGION_TYPE} of ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}

function set_farewell_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"

    if [[ "${LOCALE}" == "ro" ]]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "farewell" "${COLOUR_TEXT_MESSAGE}Ai ieșit din ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "farewell" "${COLOUR_TEXT_MESSAGE}Ai ieșit din ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "farewell" "${COLOUR_TEXT_MESSAGE}Ai ieșit din ${REGION_TYPE} ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "farewell" "${COLOUR_TEXT_MESSAGE}You have left the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "farewell" "${COLOUR_TEXT_MESSAGE}You have left the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "farewell" "${COLOUR_TEXT_MESSAGE}You have left the ${REGION_TYPE} of ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}


function set_greeting_message() {
    local REGION_ID="${1}"
    local REGION_TYPE="${2}"
    local REGION_NAME="${3}"
    local ZONE_NAME="${4}"

    if [[ "${LOCALE}" == "ro" ]]; then
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "greeting" "${COLOUR_TEXT_MESSAGE}Ai intrat în ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "greeting" "${COLOUR_TEXT_MESSAGE}Ai intrat în ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "greeting" "${COLOUR_TEXT_MESSAGE}Ai intrat în ${REGION_TYPE} ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if string_is_null_or_whitespace "${REGION_TYPE}"; then
            set_region_flag "${REGION_ID}" "greeting" "${COLOUR_TEXT_MESSAGE}You have entered the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        elif string_is_null_or_whitespace "${REGION_NAME}"; then
            set_region_flag "${REGION_ID}" "greeting" "${COLOUR_TEXT_MESSAGE}You have entered the ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_TYPE}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "greeting" "${COLOUR_TEXT_MESSAGE}You have entered the ${REGION_TYPE} of ${COLOUR_TEXT_MENTION_SUBREGION}${REGION_NAME}${COLOUR_TEXT_MESSAGE} in ${COLOUR_TEXT_MENTION_REGION}${ZONE_NAME}${COLOUR_TEXT_MESSAGE}!"
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
        [[ "${REGION_TYPE_ID}" == "city" ]] && REGION_TYPE="orașul"
        [[ "${REGION_TYPE_ID}" == "military_base" ]] && REGION_TYPE="baza militară"
        [[ "${REGION_TYPE_ID}" == "town" ]] && REGION_TYPE="orășelul"
        [[ "${REGION_TYPE_ID}" == "player_base" ]] && REGION_TYPE="baza lui"
        [[ "${REGION_TYPE_ID}" == "player_home" ]] && REGION_TYPE="casa lui"
        [[ "${REGION_TYPE_ID}" == "player_home_lake" ]] && REGION_TYPE="casa de pe lac a lui"
        [[ "${REGION_TYPE_ID}" == "player_home_mountain" ]] && REGION_TYPE="casa de pe munte a lui"
        [[ "${REGION_TYPE_ID}" == "village" ]] && REGION_TYPE="satul"
    else
        [[ "${REGION_TYPE_ID}" == "military_base" ]] && REGION_TYPE="military base"
        [[ "${REGION_TYPE_ID}" == "player_base" ]] && REGION_TYPE="base"
        [[ "${REGION_TYPE_ID}" == "player_home" ]] && REGION_TYPE="home"
        [[ "${REGION_TYPE_ID}" == "player_home_lake" ]] && REGION_TYPE="home on the lake"
        [[ "${REGION_TYPE_ID}" == "player_home_mountain" ]] && REGION_TYPE="home on the mountain"
    fi

    set_deny_message "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"
    set_teleport_message "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"

    if ${USE_GREETINGS}; then
        set_greeting_messages "${REGION_ID}" "${REGION_TYPE}" "${REGION_NAME}" "${ZONE_NAME}"
    else
        set_region_flag "${REGION_ID}" "greeting" ""
        set_region_flag "${REGION_ID}" "farewell" ""
    fi
}

function set_location_region_settings() {
    local REGION_TYPE_ID="${1}"
    local LOCATION_NAME="${2}"
    local ZONE_NAME="${3}"

    local LOCATION_ID=$(region_name_to_id "${LOCATION_NAME}")
    local ZONE_ID=$(region_name_to_id "${ZONE_NAME}")
    local REGION_ID="${LOCATION_ID}"

    [[ "${REGION_TYPE_ID}" == "military_base" ]] && REGION_ID="${ZONE_ID}_${REGION_TYPE_ID}_${LOCATION_ID}"
    
    set_region_flag "${REGION_ID}" "deny-spawn" '["bat","blaze","cave_spider","creeper","dolphin","drowned","enderman","husk","phantom","skeleton","spider","squid","stray","witch","zombie","zombie_villager"]'

    #set_region_flag "${REGION_ID}" "interact" true
    #set_region_flag "${REGION_ID}" "ride" true
    #set_region_flag "${REGION_ID}" "vehicle-destroy" true
    #set_region_flag "${REGION_ID}" "vehicle-place" true

    set_region_messages "${REGION_ID}" "${REGION_TYPE_ID}" "${LOCATION_NAME}" "${ZONE_NAME}"
    set_region_priority "${REGION_ID}" 10
}

function set_settlement_region_settings() {
    local SETTLEMENT_TYPE="${1}"
    local SETTLEMENT_NAME="${2}"
    local COUNTRY_NAME="${3}"
    local SETTLEMENT_ID=$(region_name_to_id "${SETTLEMENT_NAME}")

    set_location_region_settings "${SETTLEMENT_TYPE}" "${SETTLEMENT_NAME}" "${COUNTRY_NAME}"

    set_building_settings "${SETTLEMENT_NAME}" "arena_deathcube"        "DeathCube"             "DeathCube-ul"
    set_building_settings "${SETTLEMENT_NAME}" "arena_pvp"              "PvP Arena"             "Arena PvP"
    set_building_settings "${SETTLEMENT_NAME}" "cemetery"               "Cemetery"              "Cimitirul"
    set_building_settings "${SETTLEMENT_NAME}" "church"                 "Church"                "Biserica"
    set_building_settings "${SETTLEMENT_NAME}" "consulate_fbu"          "FBU Consulate"         "Consulatul FBU"
    set_building_settings "${SETTLEMENT_NAME}" "consulate_nucilandia"   "Nucilandian Consulate" "Consulatul Nucilandiei"
    set_building_settings "${SETTLEMENT_NAME}" "farms"                  "Farms"                 "Fermele"
    set_building_settings "${SETTLEMENT_NAME}" "farms_animals"          "Animal Farm"           "Ferma de Animale"
    set_building_settings "${SETTLEMENT_NAME}" "farms_blaze"            "Blaze Farm"            "Ferma de Blaze"
    set_building_settings "${SETTLEMENT_NAME}" "farms_gunpowder"        "Gunpowder Farm"        "Ferma de Praf de Pușcă"
    set_building_settings "${SETTLEMENT_NAME}" "farms_raid"             "Raid Farm"             "Ferma de Raiduri"
    set_building_settings "${SETTLEMENT_NAME}" "farms_squid"            "Squid Farm"            "Ferma de Sepii"
    set_building_settings "${SETTLEMENT_NAME}" "farms_sugarcane"        "Sugar Cane Farm"       "Ferma de Trestie"
    set_building_settings "${SETTLEMENT_NAME}" "farms_xp"               "XP Farm"               "Ferma de XP"
    set_building_settings "${SETTLEMENT_NAME}" "forge"                  "Forge"                 "Forja"
    set_building_settings "${SETTLEMENT_NAME}" "hippodrome"             "Hippodrome"            "Hipodromul"
    set_building_settings "${SETTLEMENT_NAME}" "horary"                 "Horary"                "Horăria"
    set_building_settings "${SETTLEMENT_NAME}" "hospital"               "Hospital"              "Spitalul"
    set_building_settings "${SETTLEMENT_NAME}" "library"                "Library"               "Librăria"
    set_building_settings "${SETTLEMENT_NAME}" "mall"                   "Mall"                  "Mall-ul"
    set_building_settings "${SETTLEMENT_NAME}" "maze"                   "Labyrinth"             "Labirintul"
    set_building_settings "${SETTLEMENT_NAME}" "metropolis"             "Metropolis"            "Mitropolia"
    set_building_settings "${SETTLEMENT_NAME}" "museum"                 "Museum"                "Muzeul"
    set_building_settings "${SETTLEMENT_NAME}" "museum_art"             "Art Museum"            "Muzeul de Artă"
    set_building_settings "${SETTLEMENT_NAME}" "museum_history"         "History Museum"        "Muzeul de Istorie"
    set_building_settings "${SETTLEMENT_NAME}" "museum_village"         "Village Museum"        "Muzeul Satului"
    set_building_settings "${SETTLEMENT_NAME}" "park"                   "Park"                  "Parcul"
    set_building_settings "${SETTLEMENT_NAME}" "post"                   "Post"                  "Poșta"
    set_building_settings "${SETTLEMENT_NAME}" "palace"                 "Palace"                "Palatul"
    set_building_settings "${SETTLEMENT_NAME}" "square"                 "Public Square"         "Piața Publică"
    set_building_settings "${SETTLEMENT_NAME}" "station_police"         "Police Station"        "Stația de Poliție"
    set_building_settings "${SETTLEMENT_NAME}" "station_train"          "Train Station"         "Gara"
    set_building_settings "${SETTLEMENT_NAME}" "subway"                 "Subway"                "Subway-ul"
    set_building_settings "${SETTLEMENT_NAME}" "warehouse"              "Warehouse"             "Magazia"

    if grep -q "^\s*${SETTLEMENT_ID}_player_" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}"; then
        for PLAYER_USERNAME in $(get_players_usernames); do
            set_player_region_settings "${SETTLEMENT_NAME}" "${PLAYER_USERNAME}"
        done
    fi
}

function set_building_settings() {
    local SETTLEMENT_NAME="${1}"
    local BUILDING_ID="${2}"
    local BUILDING_NAME="${3}"
    local BUILDING_NAME_RO="${4}"
    local REGION_PRIORITY=20

    local SETTLEMENT_ID=$(region_name_to_id "${SETTLEMENT_NAME}")
    local REGION_ID="${SETTLEMENT_ID}_${BUILDING_ID}"

    ! does_region_exist "${REGION_ID}" && return

    if [[ "${BUILDING_ID}" == "mall" ]]; then
        for ((I=1; I<=50; I++)); do
            ! does_region_exist "${SETTLEMENT_ID}_mall_shop${I}" && break
            set_building_settings "${SETTLEMENT_NAME}" "${BUILDING_ID}_shop${I}" "Mall Shop #${I}" "Magazinul #${I} din Mall"
        done
    fi

    if [[ "${LOCALE}" == "ro" ]]; then
        set_region_messages "${REGION_ID}" "" "${BUILDING_NAME_RO}" "${SETTLEMENT_NAME}" --quiet
    else
        set_region_messages "${REGION_ID}" "" "${BUILDING_NAME}" "${SETTLEMENT_NAME}" --quiet
    fi
    
    if [[ "${REGION_ID}" == *_arena_* ]]; then
        REGION_PRIORITY=30
        [[ "${REGION_ID}" == *_deathcube ]] && set_region_flag "${REGION_ID}" "fall-damage" false
        [[ "${REGION_ID}" == *_pvp ]] && set_region_flag "${REGION_ID}" "pvp" true
    fi
    
    if [[ "${REGION_ID}" == *_farms_* ]]; then
        REGION_PRIORITY=30
        [[ "${REGION_ID}" == *_blaze ]] && set_region_flag "${REGION_ID}" "deny-spawn" '["bat","cave_spider","creeper","dolphin""drowned","enderman","husk","phantom","skeleton","spider","squid","stray","witch","zombie","zombie_villager"]'
        [[ "${REGION_ID}" == *_gunpowder ]] && set_region_flag "${REGION_ID}" "deny-spawn" '["bat","blaze","cave_spider","dolphin","drowned","enderman","husk","phantom","skeleton","spider","squid","stray","zombie","zombie_villager"]'
    fi

    if [[ "${REGION_ID}" == *_hospital ]]; then
        set_region_flag "${REGION_ID}" "heal-amount" 1
        set_region_flag "${REGION_ID}" "heal-delay" 1
    fi

    if [[ "${REGION_ID}" == *_mall_shop* ]]; then
        REGION_PRIORITY=30
    fi

    if [[ "${REGION_ID}" == *_square ]]; then
        REGION_PRIORITY=30
    fi

    if [[ "${REGION_ID}" == *_subway ]]; then
        set_region_flag "${REGION_ID}" "feed-amount" 1
        set_region_flag "${REGION_ID}" "feed-delay" 1
    fi
    
    if [[ "${REGION_ID}" == *_warehouse ]]; then
        set_region_flag "${REGION_ID}" "item-drop" false
        set_region_flag "${REGION_ID}" "item-frame-rotation" false
    fi

    set_region_priority "${REGION_ID}" ${REGION_PRIORITY}
}

function set_player_region_settings() {
    local ZONE_NAME="${1}" && shift
    local MAIN_PLAYER_NAME="${1}" && shift

    local ZONE_ID=$(region_name_to_id "${ZONE_NAME}") 

    local PLAYER_REGION_ID=$(region_name_to_id "${MAIN_PLAYER_NAME}")
    local REGION_ID="${ZONE_ID}_player_${PLAYER_REGION_ID}"

    ! does_region_exist "${REGION_ID}" && return

    local PLAYER_NAMES="${MAIN_PLAYER_NAME}"

    while ! string_is_null_or_whitespace "${1}"; do
        PLAYER_NAMES="${PLAYER_NAMES}, ${1}"
        shift
    done

    if [[ "${ZONE_NAME}" == "Wilderness" ]]; then
        set_region_messages "${REGION_ID}" "player_base" "${PLAYER_NAMES}" "${ZONE_NAME}"
    else
        set_region_messages "${REGION_ID}" "player_home" "${PLAYER_NAMES}" "${ZONE_NAME}" --quiet

        if does_region_exist "${REGION_ID}_lake"; then
            set_region_messages "${REGION_ID}_lake" "player_home_lake" "${PLAYER_NAMES}" "${ZONE_NAME}" --quiet
            set_region_priority "${REGION_ID_lake}" 50
        fi

        if does_region_exist "${REGION_ID}_mountain"; then
            set_region_messages "${REGION_ID}_mountain" "player_home_mountain" "${PLAYER_NAMES}" "${ZONE_NAME}" --quiet
            set_region_priority "${REGION_ID_mountain}" 50
        fi
    fi

    set_region_priority "${REGION_ID}" 50
}

function begin_transaction() {
    #trap 'rollback_transaction' SIGINT
    reload_plugin "worldguard"

    sudo cp "${WORLDGUARD_WORLD_REGIONS_FILE}" "${WORLDGUARD_WORLD_REGIONS_FILE}.bak"
    sudo cp "${WORLDGUARD_WORLD_REGIONS_FILE}" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}"
}

function commit_transaction() {
    sudo cp "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" "${WORLDGUARD_WORLD_REGIONS_FILE}"
    sudo chown papermc:papermc "${WORLDGUARD_WORLD_REGIONS_FILE}"

    reload_plugin "worldguard"
    exit
}

function rollback_transaction() {
    sudo rm "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}"
    exit
}

begin_transaction

for CITY_NAME in "Flusseland" "Hokazuro" "Solara"; do
    set_settlement_region_settings "city" "${CITY_NAME}" "Nucilandia"
done
for CITY_NAME in "Enada" "Naoi"; do
    set_settlement_region_settings "city" "${CITY_NAME}" "FBU"
done

for TOWN_NAME in "Bloodorf" "Cornova" "Cratesia" "Horidava" "Izmir" "Newport"; do
    set_settlement_region_settings "town" "${CITY_NAME}" "Nucilandia"
done
for TOWN_NAME in "Iahim"; do
    set_settlement_region_settings "town" "${CITY_NAME}" "FBU"
done

for VILLAGE_NAME in "Arkala" "Brașovești" "Canopis" "Faun" "Frigonița" "Nordavia" "Veneței"; do
    set_settlement_region_settings "village" "${CITY_NAME}" "Nucilandia"
done
for VILLAGE_NAME in "Bastonia"; do
    set_settlement_region_settings "village" "${CITY_NAME}" "FBU"
done

for MILITARYBASE_NAME in "Crișia"; do
    set_location_region_settings "military_base" "baza militară" "${MILITARYBASE_NAME}" "Nucilandia"
done

for PLAYER_USERNAME in $(get_players_usernames); do
    PLAYER_REGION_ID=$(region_name_to_id "${PLAYER_USERNAME}")

    ! grep -q "player_${PLAYER_REGION_ID}" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" && continue
    
    for OTHER_REGION in 'BloodCraft' 'KreezCraft 1' 'Wilderness'; do
        set_player_region_settings "${OTHER_REGION}" "${PLAYER_USERNAME}"
    done
done

commit_transaction

set_region_messages "end_portal" "The End Portal"

set_player_region_settings "bloodcraft_citadel" "Hori873"
set_player_region_settings "bloodcraft_pagoda" "Hori873"
set_player_region_settings "kreezcraft1" "skonxsi"
set_player_region_settings "kreezcraft1" "SoulSilver"
set_player_region_settings "kreezcraft1" "Xenon"
set_player_region_settings "survivalisland" "Hori873" "Kamikaze" "Azzuro"
set_player_region_settings "survivalisland2" "Hori873"

commit_transaction
