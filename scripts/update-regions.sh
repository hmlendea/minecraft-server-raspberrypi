#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/messages.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/worldguard.sh"

DENY_SPAWN_COMMON='"bat","cod","dolphin","drowned","enderman","husk","phantom","salmon","slime","stray","wither","zombie_villager"'
TELEPORTATION_COMMANDS='"/b","/back","/bed","/home","/homes","/rgtp","/sethome","/setspawn","/shop","/spawn","/spawnpoint","/tp","/tpa","/tpaccept","/tpahere","/tpask","/tphere","/tpo","/tppos","/tpr","/tprandom","/tpregion","/tprg","/tpyes","/warp","/warps","/wild"'

ensure_plugin_is_installed "WorldGuard"

function begin_transaction() {
    #trap 'rollback_transaction' SIGINT
    reload_plugin 'WorldGuard'

    sudo cp "${WORLDGUARD_WORLD_REGIONS_FILE}" "${WORLDGUARD_WORLD_REGIONS_FILE}.bak"
    sudo cp "${WORLDGUARD_WORLD_REGIONS_FILE}" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}"
    echo ''
}

function commit_transaction() {
    sudo cp "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" "${WORLDGUARD_WORLD_REGIONS_FILE}"
    sudo chown papermc:papermc "${WORLDGUARD_WORLD_REGIONS_FILE}"

    reload_plugin 'WorldGuard'
    exit
}

function rollback_transaction() {
    sudo rm "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}"
    exit
}

begin_transaction

set_settlement_region_settings 'settlement_town' 'Kreeztown' 'Nucilandia'
commit_transaction

for CITY_NAME in 'Flusseland' 'Hokazuro' 'Solara'; do
    set_settlement_region_settings 'settlement_city' "${CITY_NAME}" 'Nucilandia'
done
for CITY_NAME in 'Enada' 'Naoi'; do
    set_settlement_region_settings 'settlement_city' "${CITY_NAME}" 'FBU'
done

for TOWN_NAME in 'Bloodorf' 'Cornova' 'Cratesia' 'Çupișan' 'Horidava' 'Kreeztown' 'Newport' 'Witty'; do
    set_settlement_region_settings 'settlement_town' "${TOWN_NAME}" 'Nucilandia'
done
for TOWN_NAME in 'Emeraldia' 'Iahim'; do
    set_settlement_region_settings 'settlement_town' "${TOWN_NAME}" 'FBU'
done

for VILLAGE_NAME in 'Aerolis' 'Arkala' 'Beçina' 'Bercaia' 'Bitong' 'Bradu' 'Canopis' 'Carotis' 'Cerc' 'Çonca' 'Çuntama' 'Çuvei' 'Faun' 'Fleçida' 'Frigonița' \
                    'Ğimbola' 'Grivina' 'Hodor' 'Izmir' 'Loth' 'Lupinis' 'Minas' 'Nordavia' 'Pandora' 'Șaosu' 'Scârțari' 'Șigata' 'Sinço' 'Soçida' 'Sușița' 'Veneței' 'Yvalond'; do
    set_settlement_region_settings 'settlement_village' "${VILLAGE_NAME}" 'Nucilandia'
done
for VILLAGE_NAME in 'Aecrim' 'Bastonia'; do
    set_settlement_region_settings 'settlement_village' "${VILLAGE_NAME}" 'FBU'
done

for MILITARYBASE_NAME in 'Binuca' 'Crișia'; do
    set_location_region_settings_by_name 'military_base' "${MILITARYBASE_NAME}" 'Nucilandia'
done

for NATION in 'FBU' 'Nucilandia'; do
    NATION_ID=$(region_name_to_id "${NATION}")

    for NATION2 in 'FBU' 'Nucilandia'; do
        NATION2_ID=$(region_name_to_id "${NATION2}")

        for BORDER_CROSSING_REGION_ID in $(get_regions_by_pattern "${NATION_ID}_border_crossing_${NATION2_ID}_.*"); do
            set_location_region_settings_by_id "${BORDER_CROSSING_REGION_ID}" "border_crossing" "" "${NATION} ↔ ${NATION2}"
        done
    done

    for STRUCTURE in 'border_watchtower' 'border_wall' 'bridge' 'defence_bunker' 'defence_turret' \
                     'resource_depot' 'road_rail' 'station_weather' 'yacht_diplomatic'; do
        set_structure_region_settings "${NATION}" "${STRUCTURE}"
    done
done

for PLAYER_USERNAME in $(get_players_usernames); do
    PLAYER_REGION_ID=$(region_name_to_id "${PLAYER_USERNAME}")

    ! grep -q "player_${PLAYER_REGION_ID}" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" && continue
    
    for OTHER_REGION in 'BloodCraft' 'KreezCraft 1' 'Wilderness'; do
        set_player_region_settings "${OTHER_REGION}" "${PLAYER_USERNAME}"
    done
done

set_region_messages 'end_portal' 'The End Portal'

set_player_region_settings "bloodcraft_citadel" "Hori873"
set_player_region_settings "bloodcraft_pagoda" "Hori873"
set_player_region_settings "kreezcraft1" 'skonxsi'
set_player_region_settings "kreezcraft1" 'SoulSilver'
set_player_region_settings "kreezcraft1" 'Xenon'
set_player_region_settings 'survivalisland' 'Hori873' 'Kamikaze' 'Azzuro'
set_player_region_settings 'survivalisland2' 'Hori873'

commit_transaction
