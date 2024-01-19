#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"

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
    local REGION_NAME="${2}"

    local IS_PRIVATE_REGION=false
    [[ "${REGION_ID}" == player_* ]] && IS_PRIVATE_REGION=true

    if [[ "${LOCALE}" == "ro" ]]; then
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}Nu poți face asta (%what%) în baza lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}Nu poți face asta (%what%) în ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}You can't %what% in ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s base!"
        else
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}You can't %what% in ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}

function set_teleport_message() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"

    local IS_PRIVATE_REGION=false
    [[ "${REGION_ID}" == player_* ]] && IS_PRIVATE_REGION=true

    if [[ "${LOCALE}" == "ro" ]]; then
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Te teleportezi în baza lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Te teleportezi în ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Whisking ye away to ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s base!"
        else
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Whisking ye away to ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}

function set_farewell_message() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"

    local IS_PRIVATE_REGION=false
    [[ "${REGION_ID}" == player_* ]] && IS_PRIVATE_REGION=true

    if [[ "${LOCALE}" == "ro" ]]; then
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}Ai ieșit din baza lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}Ai ieșit din ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}You have left ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s base!"
        else
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}You have left ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}


function set_greeting_message() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"

    local IS_PRIVATE_REGION=false
    [[ "${REGION_ID}" == player_* ]] && IS_PRIVATE_REGION=true

    if [[ "${LOCALE}" == "ro" ]]; then
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}Ai intrat în baza lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}Ai intrat în ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}You have entered ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s base!"
        else
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}You have entered ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}

function set_greeting_messages() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"

    set_farewell_message "${REGION_ID}" "${REGION_NAME}"
    set_greeting_message "${REGION_ID}" "${REGION_NAME}"
}

function set_region_messages() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"
    
    local USE_GREETINGS=true
    local IS_PRIVATE_REGION=false

    [[ "${REGION_ID}" == player_* ]] && IS_PRIVATE_REGION=true
    [[ "${*}" == *"--quiet"* ]] && USE_GREETINGS=false
    [[ "${REGION_ID}" == *enada_* ]] && USE_GREETINGS=false
    [[ "${REGION_ID}" == *_enada* ]] && USE_GREETINGS=false
    [[ "${REGION_ID}" == *solara_* ]] && USE_GREETINGS=false
    [[ "${REGION_ID}" == *_solara* ]] && USE_GREETINGS=false

    if ${IS_PRIVATE_REGION}; then
        REGION_NAME="${COLOUR_TEXT_MENTION_PLAYER}${2}"

        if [ -n "${3}" ]; then
            for COOWNER_NAME in "${@:3:${#@}-3}"; do
                REGION_NAME="${REGION_NAME}${COLOUR_TEXT_MESSAGE}, ${COLOUR_TEXT_MENTION_PLAYER}${COOWNER_NAME}"
            done

            if [[ "${LOCALE}" == "ro" ]]; then
                REGION_NAME="${REGION_NAME}${COLOUR_TEXT_MESSAGE} și ${COLOUR_TEXT_MENTION_PLAYER}${!#}"
            else
                REGION_NAME="${REGION_NAME}${COLOUR_TEXT_MESSAGE} and ${COLOUR_TEXT_MENTION_PLAYER}${!#}"
            fi
        fi
    fi

    if echo "${REGION_NAME}" | grep -qv '[&§,]'; then
        REGION_NAME="${COLOUR_TEXT_MENTION_REGION}${REGION_NAME}"
    fi

    set_deny_message "${REGION_ID}" "${REGION_NAME}"
    set_teleport_message "${REGION_ID}" "${REGION_NAME}"

    if ${USE_GREETINGS}; then
        set_greeting_messages "${REGION_ID}" "${REGION_NAME}"
    else
        set_region_flag "${REGION_ID}" "greeting" ""
        set_region_flag "${REGION_ID}" "farewell" ""
    fi
}

function set_common_region_settings() {
    local REGION_ID="${1}"

    # Natural damage
#    set_region_flag "${REGION_ID}" "block-trampling"    false
#    set_region_flag "${REGION_ID}" "creeper-explosion"  false
#    set_region_flag "${REGION_ID}" "enderman-grief"     false
#    set_region_flag "${REGION_ID}" "fire-spread"        false
#    set_region_flag "${REGION_ID}" "ghast-fireball"     false # Also handles Wither Skulls
#    set_region_flag "${REGION_ID}" "lava-fire"          false
#    set_region_flag "${REGION_ID}" "ravager-grief"      false
#    set_region_flag "${REGION_ID}" "wither-damage"      false

    # Player interactions
    set_region_flag "${REGION_ID}" "pvp"                false
}

function set_settlement_region_settings() {
    local SETTLEMENT_NAME="${1}"
    local COUNTRY_NAME="${2}"

    local SETTLEMENT_ID=$(region_name_to_id "${SETTLEMENT_NAME}")    
    local REGION_ID="settlement_${SETTLEMENT_ID}_"$(region_name_to_id "${COUNTRY_NAME}")

    set_common_region_settings "${REGION_ID}"

    set_region_flag "${REGION_ID}" "deny-spawn" '["bat", "cave_spider","creeper","drowned","enderman","husk","phantom","skeleton","spider","stray","witch","zombie","zombie_villager"]'

    #set_region_flag "${REGION_ID}" "interact" true
    #set_region_flag "${REGION_ID}" "ride" true
    #set_region_flag "${REGION_ID}" "vehicle-destroy" true
    #set_region_flag "${REGION_ID}" "vehicle-place" true

    set_deny_message        "${REGION_ID}" "${COLOUR_TEXT_MENTION_REGION}${SETTLEMENT_NAME}"
    set_teleport_message    "${REGION_ID}" "${COLOUR_TEXT_MENTION_REGION}${SETTLEMENT_NAME}"
    set_farewell_message    "${REGION_ID}" "${COLOUR_TEXT_MENTION_REGION}${SETTLEMENT_NAME}"
    set_greeting_message    "${REGION_ID}" "${COLOUR_TEXT_MENTION_REGION}${SETTLEMENT_NAME}${COLOUR_TEXT_MESSAGE} (${COLOUR_TEXT_MENTION_SUBREGION}${COUNTRY_NAME}${COLOUR_TEXT_MESSAGE})"

    set_region_priority "${REGION_ID}" 10

    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "arena_deathcube"  "DeathCube"              "DeathCube-ul"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "arena_pvp"        "PvP Arena"              "Arena PvP"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "cemetery"         "Cemetery"               "Cimitirul"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "farms"            "Farms"                  "Fermele"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "farms_raid"       "Raid Farm"              "Ferma de Raiduri"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "farms_sugarcane"  "Sugar Cane Farm"        "Ferma de Trestie"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "farms_xp"         "XP Farm"                "Ferma de XP"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "forge"            "Forge"                  "Forja"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "horarie"          "Horary"                 "Horăria"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "library"          "Library"                "Librăria"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "maze"             "Maze"                   "Labirintul"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "museum"           "Museum"                 "Muzeul"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "museum_art"       "Art Museum"             "Muzeul de Artă"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "museum_history"   "History Museum"         "Muzeul de Istorie"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "museum_village"   "Village Museum"         "Muzeul Satului"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "post"             "Post Office"            "Poșta"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "palace"           "Palace"                 "Palatul"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "palace_chicken"   "Chicken Palace"         "Palatul Găinilor"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "square"           "Public Square"          "Piața Publică"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "station_police"   "Police Station"         "Stația de Poliție"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "station_train"    "Train Station"          "Gara"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "subway"           "Subway"                 "Subway-ul"
    set_settlement_public_building_settings "${SETTLEMENT_NAME}" "warehouse"        "Local Public Warehouse" "Magazia Publică Locală"
}

function set_settlement_public_building_settings() {
    local SETTLEMENT_NAME="${1}"
    local BUILDING_ID="${2}"
    local BUILDING_NAME="${3}"
    local BUILDING_NAME_RO="${4}"
    local REGION_PRIORITY=20

    local SETTLEMENT_ID=$(region_name_to_id "${SETTLEMENT_NAME}")
    local REGION_ID="${SETTLEMENT_ID}_${BUILDING_ID}"

    ! does_region_exist "${REGION_ID}" && return

    REGION_NAME="${COLOUR_TEXT_MENTION_REGION}${SETTLEMENT_NAME}${COLOUR_TEXT_MESSAGE}'s ${COLOUR_TEXT_MENTION_SUBREGION}${BUILDING_NAME}"
    [[ "${LOCALE}" == "ro" ]] && [[ -n "${BUILDING_NAME_RO}" ]] && BUILDING_NAME="${COLOUR_TEXT_MENTION_SUBREGION}${BUILDING_NAME_RO}${COLOUR_TEXT_MESSAGE} din ${COLOUR_TEXT_MENTION_REGION}${SETTLEMENT_NAME}"

    [[ "${REGION_ID}" == *_arena_* ]] && REGION_PRIORITY=30
    [[ "${REGION_ID}" == *_farms_* ]] && REGION_PRIORITY=30

    set_common_region_settings "${REGION_ID}" "${BUILDING_NAME}"
    set_region_messages "${REGION_ID}" "${BUILDING_NAME}" --quiet
    set_region_priority "${REGION_ID}" ${REGION_PRIORITY}

    [[ "${REGION_ID}" == *_arena_pvp ]] && set_region_flag "${REGION_ID}" "pvp" true
}

function set_player_region_settings() {
    local ZONE_ID="${1}" && shift
    local MAIN_PLAYER_NAME="${1}"

    local PLAYER_REGION_ID=$(region_name_to_id "${MAIN_PLAYER_NAME}")
    local REGION_ID="player_${PLAYER_REGION_ID}_${ZONE_ID}"

    set_common_region_settings "${REGION_ID}" "${REGION_NAME}"
    set_region_messages "${REGION_ID}" $@
    set_region_priority "${REGION_ID}" 50
}

function begin_transaction() {
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

begin_transaction

for CITY_NAME in "Hokazuro" "Solara"; do
    set_settlement_region_settings "${CITY_NAME}" "Nucilandia"
done

for CITY_NAME in "Naoi"; do
    set_settlement_region_settings "${CITY_NAME}" "FBU"
done

for TOWN_NAME in "Bloodorf" "Cornova" "Cratesia" "Flusseland" "Horidava" "Newport"; do
    set_settlement_region_settings "${TOWN_NAME}" "Nucilandia"
done
for TOWN_NAME in "Enada" "Iahim"; do
    set_settlement_region_settings "${TOWN_NAME}" "FBU"
done
commit_transaction

for VILLAGE_NAME in "Arkala" "Brașovești" "Canopis" "Frigonița" "Nordavia" "Newport" "Nordavia" "Veneței"; do
    set_settlement_region_settings "${VILLAGE_NAME}" "Nucilandia"
done
for VILLAGE_NAME in "Bastonia"; do
    set_settlement_region_settings "${VILLAGE_NAME}" "FBU"
done

commit_transaction

set_settlement_public_building_settings "enada_chicken_palace" "The Chicken's Palace" "Palatul Găinilor din Enada"

set_region_messages "end_portal" "The End Portal"

set_player_region_settings "bloodcraft" "germanlk"
set_player_region_settings "bloodcraft_citadel" "Hori873"
set_player_region_settings "bloodcraft_pagoda" "Hori873"
set_player_region_settings "enada" "AsunaSenko"
set_player_region_settings "enada" "beepbeep"
set_player_region_settings "enada" "Blitzkrieg94"
set_player_region_settings "enada" "Codrea22"
set_player_region_settings "enada" "Denisse"
set_player_region_settings "enada" "ElHori"
set_player_region_settings "enada" "Emilio"
set_player_region_settings "enada" "Gerosst"
set_player_region_settings "enada" "mibu"
set_player_region_settings "enada" "MoonSoul02"
set_player_region_settings "enada" "qAviis"
#set_player_region_settings "enada" "radumicro"
set_player_region_settings "hokazuro" "Hori873"
set_player_region_settings "kreezcraft1" "bvr12345"
set_player_region_settings "kreezcraft1" "Calamithy"
set_player_region_settings "kreezcraft1" "coR3q"
set_player_region_settings "kreezcraft1" "Csaby"
set_player_region_settings "kreezcraft1" "Cucu"
set_player_region_settings "kreezcraft1" "deliric004"
set_player_region_settings "kreezcraft1" "DeZaD1007"
set_player_region_settings "kreezcraft1" "Doctorasshole"
set_player_region_settings "kreezcraft1" "DropDeadCRAIGG"
set_player_region_settings "kreezcraft1" "GeAsPa"
set_player_region_settings "kreezcraft1" "GuessWho"
set_player_region_settings "kreezcraft1" "Halavar105"
set_player_region_settings "kreezcraft1" "Honeydew"
set_player_region_settings "kreezcraft1" "Legomaster"
set_player_region_settings "kreezcraft1" "loadme"
set_player_region_settings "kreezcraft1" "MrNkkiHD"
set_player_region_settings "kreezcraft1" "oOTaGsTeROo"
set_player_region_settings "kreezcraft1" "P1epi3"
set_player_region_settings "kreezcraft1" "poliphocet"
set_player_region_settings "kreezcraft1" "Qurlles"
set_player_region_settings "kreezcraft1" "Remus"
set_player_region_settings "kreezcraft1" "RoLunaris"
set_player_region_settings "kreezcraft1" "Seby"
set_player_region_settings "kreezcraft1" "skonxsi"
set_player_region_settings "kreezcraft1" "Sory666"
set_player_region_settings "kreezcraft1" "SoulSilver"
set_player_region_settings "kreezcraft1" "Sound453"
set_player_region_settings "kreezcraft1" "T3RM1N4TOR"
set_player_region_settings "kreezcraft1" "TnTE_bulan8"
set_player_region_settings "kreezcraft1" "Xenon"
set_player_region_settings "kreezcraft1wilderness" "Remus"
set_player_region_settings "solara" "Blitzkrieg94"
set_player_region_settings "solara" "Denisse"
set_player_region_settings "solara" "ElHori"
set_player_region_settings "solara" "Mary" "Ionut22"
set_player_region_settings "solara" "mibu"
set_player_region_settings "solara" "nnivrim"
set_player_region_settings "solara" "qAviis"
set_player_region_settings "survivalisland" "Hori873" "Kamikaze" "Azzuro"
set_player_region_settings "survivalisland2" "Hori873"
set_player_region_settings "wilderness" "beepbeep"
set_player_region_settings "wilderness" "KamiSarma"
set_player_region_settings "wilderness" "Mary"
set_player_region_settings "ysmircraft" "Gazz"

commit_transaction
