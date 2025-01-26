#!/bin/bash
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/messages.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/players.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/worldguard.sh"

REGIONS_BACKUP_FILE_NAME='regions.bak.yml'
REGIONS_TEMPORARY_FILE_NAME='regions.tmp.yml'
REGIONS_FILE_NAME='regions.yml'

ensure_plugin_is_installed "WorldGuard"

function begin_transaction() {
    #trap 'rollback_transaction' SIGINT
    reload_plugin 'WorldGuard'

    sudo cp "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_FILE_NAME}" "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_BACKUP_FILE_NAME}"
    sudo cp "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_FILE_NAME}" "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_TEMPORARY_FILE_NAME}"
    echo ''
}

function commit_transaction() {
    sudo cp "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_TEMPORARY_FILE_NAME}" "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_FILE_NAME}"
    sudo cp "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" "${WORLDGUARD_WORLD_REGIONS_FILE}"
    sudo chown papermc:papermc "${WORLDGUARD_WORLD_REGIONS_FILE}"

    reload_plugin 'WorldGuard'
    reload_plugin 'RegionBossbar'
    exit
}

function rollback_transaction() {
    sudo rm "${WORLDGUARD_DIR}/worlds/${WORLD_NAME}/${REGIONS_TEMPORARY_FILE_NAME}"
    exit
}

begin_transaction

for VOIVODESHIP_NAME in 'Flusseland' 'Kreezland' 'Pontica' 'Solara'; do
    set_administrative_region_settings "${WORLD_NAME}" 'voivodeship' "${VOIVODESHIP_NAME}" 'Nucilandia'
done

for CITY_NAME in 'Flusseland' 'Hokazuro' 'Solara'; do
    set_settlement_region_settings "${WORLD_NAME}" 'settlement_city' "${CITY_NAME}" 'Nucilandia'
done
for CITY_NAME in 'Enada' 'Naoi'; do
    set_settlement_region_settings "${WORLD_NAME}" 'settlement_city' "${CITY_NAME}" 'FBU'
done

for TOWN_NAME in 'Bloodorf' 'Cornova' 'Cratesia' 'Çupișan' 'Horidava' 'Kreeztown' 'Newport' 'Witty'; do
    set_settlement_region_settings "${WORLD_NAME}" 'settlement_town' "${TOWN_NAME}" 'Nucilandia'
done
for TOWN_NAME in 'Emeraldia' 'Iahim'; do
    set_settlement_region_settings "${WORLD_NAME}" 'settlement_town' "${TOWN_NAME}" 'FBU'
done

for VILLAGE_NAME in 'Aerolis' 'Arkala' 'Azuralis' 'Beçina' 'Bercaia' 'Bitong' 'Bradu' 'Cabola' 'Canopis' 'Carotis' 'Çonca' 'Çuntama' 'Çuvei' 'Faun' 'Fleçida' 'Frigonița' \
                    'Ğimbola' 'Grivina' 'Hodor' 'Izmir' 'Loth' 'Lupinis' 'Minas' 'Nirvada' 'Nordavia' 'Omagad' 'Pandora' 'Râșcota' 'Șaosu' 'Scârțari' 'Sinço' 'Soçida' 'Sușița' 'Veneței' 'Yvalond'; do
    set_settlement_region_settings "${WORLD_NAME}" 'settlement_village' "${VILLAGE_NAME}" 'Nucilandia'
done
for VILLAGE_NAME in 'Aecrim' 'Bastonia'; do
    set_settlement_region_settings "${WORLD_NAME}" 'settlement_village' "${VILLAGE_NAME}" 'FBU'
done

for MILITARYBASE_NAME in 'Binuca' 'Crișia' 'Flusseland'; do
    set_location_region_settings_by_name "${WORLD_NAME}" 'base_military' "${MILITARYBASE_NAME}" 'Nucilandia'
done

for NATION in 'FBU' 'Nucilandia'; do
    NATION_ID=$(region_name_to_id "${NATION}")

    for NATION2 in 'FBU' 'Nucilandia'; do
        NATION2_ID=$(region_name_to_id "${NATION2}")

        for BORDER_CROSSING_REGION_ID in $(get_regions_by_pattern "${NATION_ID}_border_crossing_${NATION2_ID}_.*"); do
            set_location_region_settings_by_id "${WORLD_NAME}" "${BORDER_CROSSING_REGION_ID}" 'border_crossing' '' "${NATION} ↔ ${NATION2}"
        done
    done

    for STRUCTURE in 'border_watchtower' 'border_wall' 'bridge' 'defence_bunker' 'defence_turret' \
                     'portal_end' 'resource_depot' 'road_rail' 'station_weather' 'yacht_diplomatic'; do
        set_structure_region_settings "${WORLD_NAME}" "${NATION}" "${STRUCTURE}"
    done

    for PLAYER_USERNAME in $(get_players_usernames); do
        PLAYER_REGION_ID=$(region_name_to_id "${PLAYER_USERNAME}")
        
        for ZONE_NAME in 'FBU' 'Nucilandia'; do
            ! grep -q "${NATION_ID}_base_player_${PLAYER_REGION_ID}" "${WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE}" && continue
    
            set_player_region_settings "${WORLD_NAME}" "${ZONE_NAME}" "${PLAYER_USERNAME}"
        done
    done
done

commit_transaction
