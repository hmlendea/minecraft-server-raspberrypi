#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_DIR}/common/colours.sh"
source "${SERVER_SCRIPTS_DIR}/common/config.sh"

if [ ! -d "${WORLDGUARD_DIR}" ]; then
    echo "ERROR: The WorldGuard plugin is not installed!"
    exit 1
fi

function set_region_flag() {
    local REGION_ID="${1}"
    local FLAG="${2}"
    local VALUE="${3}"

    if ! grep -q "^\s\s*${REGION_ID}:$" "${WORLDGUARD_WORLD_REGIONS_FILE}"; then
        echo "ERROR: The '${REGION_ID}' region does not exits!"
        return
    fi
    
    [[ "${VALUE}" == "false" ]] && VALUE="deny"
    [[ "${VALUE}" == "true" ]] && VALUE="allow"
#    [[ "${VALUE}" == *"&"* ]] && VALUE=$(echo "${VALUE}" | sed 's/&//g')

    set_config_value "${WORLDGUARD_WORLD_REGIONS_FILE}" "regions.${REGION_ID}.flags.${FLAG}" "${VALUE}"
#    run_server_command "region flag -w ${WORLD_NAME} ${REGION_ID} ${FLAG} ${VALUE}"
}

function set_common_region_flags() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"

    [ -z "${REGION_NAME}" ] && REGION_NAME="${REGION_ID}"

    # Natural damage
    set_region_flag "${REGION_ID}" "block-trampling"            false
    set_region_flag "${REGION_ID}" "creeper-explosion"          false
    set_region_flag "${REGION_ID}" "enderdragon-block-damage"   false
    set_region_flag "${REGION_ID}" "enderman-grief"             false
    set_region_flag "${REGION_ID}" "fire-spread"                false
    set_region_flag "${REGION_ID}" "ghast-fireball"             false
    set_region_flag "${REGION_ID}" "lava-fire"                  false
    set_region_flag "${REGION_ID}" "lightning"                  false
    set_region_flag "${REGION_ID}" "ravager-grief"              false
    set_region_flag "${REGION_ID}" "wither-damage"              false

    # Player interactions
    set_region_flag "${REGION_ID}" "pvp"                        false

    # Environment
    set_region_flag "${REGION_ID}" "weather-lock"               "clear"
}

function set_deny_message() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"

    local IS_PRIVATE_REGION=false
    [[ "${REGION_ID}" == player_* ]] && IS_PRIVATE_REGION=true

    if [[ "${LOCALE}" == "ro" ]]; then
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}Nu poți face asta în regiunea lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}Nu poți face asta în ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "deny-message" "${COLOUR_TEXT_DENIED}STOP! ${COLOUR_TEXT_MESSAGE}You can't %what% in ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s region!"
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
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Te teleportezi în regiunea lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Te teleportezi în ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Whisking ye away to ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s region!"
        else
            set_region_flag "${REGION_ID}" "teleport-message" "${COLOUR_TEXT_MESSAGE}Whisking ye away to ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
}

function set_greeting_messages() {
    local REGION_ID="${1}"
    local REGION_NAME="${2}"

    local IS_PRIVATE_REGION=false
    [[ "${REGION_ID}" == player_* ]] && IS_PRIVATE_REGION=true

    if [[ "${LOCALE}" == "ro" ]]; then
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}Ai intrat în regiunea lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}Ai ieșit din regiunea lui ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        else
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}Ai intrat în ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}Ai ieșit din ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    else
        if ${IS_PRIVATE_REGION}; then
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}You have entered ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s region!"
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}You have left ${REGION_NAME}${COLOUR_TEXT_MESSAGE}'s region!"
        else
            set_region_flag "${REGION_ID}" "greeting"   "${COLOUR_TEXT_MESSAGE}You have entered ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
            set_region_flag "${REGION_ID}" "farewell"   "${COLOUR_TEXT_MESSAGE}You have left ${REGION_NAME}${COLOUR_TEXT_MESSAGE}!"
        fi
    fi
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

set_region_messages "enada_forja" "Enada's Forge" --quiet
set_region_messages "enada_magazie" "Enada's Local Public Warehouse" --quiet
set_region_messages "enada_subway" "Enada's Subway" --quiet
set_region_messages "end_portal" "The End Portal"

set_region_messages "player_asunasenko_enada" "AsunaSenko"
set_region_messages "player_beepbeep" "beepbeep"
set_region_messages "player_beepbeep_enada" "beepbeep"
set_region_messages "player_calamithy_kreezcraft1" "CALAMITHY"
set_region_messages "player_cor3q_kreezcraft1" "coR3q"
set_region_messages "player_denisse_enada" "Denisse"
set_region_messages "player_eldestjeans1564" "EldestJeans1564"
set_region_messages "player_elhori_enada" "ElHori"
set_region_messages "player_emilio_enada" "Emilio"
set_region_messages "player_gazz_ysmircraft" "Gazz"
set_region_messages "player_germanlk_bloodcraft" "germanlk"
set_region_messages "player_gerosst_enada" "Gerosst"
set_region_messages "player_hori873_bloodcraft_citadel" "Hori873"
set_region_messages "player_hori873_bloodcraft_main" "Hori873" "Kamikaze" "Azzuro"
set_region_messages "player_hori873_bloodcraft_north" "Hori873" "Kamikaze" "Azzuro"
set_region_messages "player_hori873_bloodcraft_pagoda" "Hori873"
set_region_messages "player_hori873_survivalisland" "Hori873" "Kamikaze" "Azzuro"
set_region_messages "player_hori873_survivalisland2" "Hori873"
set_region_messages "player_hori_castel" "Hori"
set_region_messages "player_hori_continent" "Hori"
set_region_messages "player_hori_continent_forest" "Hori"
set_region_messages "player_kamisarma" "KamiSarma"
set_region_messages "player_mibu_enada" "mibu"
set_region_messages "player_moonsoul02_enada" "MoonSoul02"
set_region_messages "player_ootagsteroo_kreezcraft1" "oOTaGsTeROo"
set_region_messages "player_p1epi3_kreezcraft1" "P1epi3"
set_region_messages "player_qaviis_enada" "qAviis"
set_region_messages "player_radumicro_enada_lac" "radumicro"
#set_region_messages "player_radumicro_enada_sky" "radumicro"
set_region_messages "player_remus_kreezcraft1" "Remus"
set_region_messages "player_seby_kreezcraft1" "Seby"
set_region_messages "player_skonxsi_kreezcraft1" "skonxsi"
set_region_messages "player_sory666_kreezcraft1" "Sory666"
set_region_messages "player_soulsilver_kreezcraft1" "SoulSilver"
set_region_messages "player_xenon_kreezcraft1" "Xenon"

for REGION in $(yq -r '.regions | keys[]' plugins/WorldGuard/worlds/world/regions.yml); do
    set_common_region_flags "${REGION}"
done