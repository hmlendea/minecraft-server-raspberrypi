#!/bin/bash
# shellcheck disable=SC2046,SC2086
source "/srv/papermc/scripts/common/paths.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/colours.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/config.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/messages.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/plugins.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/specs.sh"
source "${SERVER_SCRIPTS_COMMON_DIR}/utils.sh"

ensure_su_access

WEBMAP_PAGE_TITLE="${SERVER_NAME} World Map"

PLACEHOLDER_ARG0='{0}'
PLACEHOLDER_ARG1='{1}'
PLACEHOLDER_ARG1_PERCENT='%1%'
PLACEHOLDER_ARG2='{2}'
PLACEHOLDER_ACHIEVEMENT_PERCENT='%achievement%'
PLACEHOLDER_ARROWS_BRACKETS="{arrows}"
PLACEHOLDER_BLOCKS_BRACKETS="{blocks}"
PLACEHOLDER_BRAND_PERCENT="%brand%"
PLACEHOLDER_BUYER_SINGLEPERCENT="%buyer"
PLACEHOLDER_CITY_PERCENT="%city%"
PLACEHOLDER_COUNT_SINGLEPERCENT="%count"
PLACEHOLDER_COUNTRY_PERCENT="%country%"
PLACEHOLDER_CROPS_BRACKETS="{crops}"
PLACEHOLDER_DAMAGE_BRACKETS="{damage}"
PLACEHOLDER_DATE_BRACKETS="{date}"
PLACEHOLDER_DISPLAYNAME_BRACKETS='{DISPLAYNAME}'
PLACEHOLDER_FISH_BRACKETS="{fish}"
PLACEHOLDER_ITEM_SINGLEPERCENT='%item'
PLACEHOLDER_KILLS_BRACKETS="{kills}"
PLACEHOLDER_NAME_POINTY="<name>"
PLACEHOLDER_OWNER_SINGLEPERCENT='%owner'
PLACEHOLDER_PLAYER="{PLAYER}"
PLACEHOLDER_PLAYER_BRACKETS='{player}'
PLACEHOLDER_PLAYER_PERCENT='%player%'
PLACEHOLDER_PLAYER_SINGLEPERCENT='%player'
PLACEHOLDER_PLAYERCOUNT_PERCENT='%playercount%'
PLACEHOLDER_PRICE_SINGLEPERCENT='%price'
PLACEHOLDER_REASON_PERCENT="%reason%"
PLACEHOLDER_SELLER_SINGLEPERCENT="%seller"
PLACEHOLDER_MESSAGE="{MESSAGE}"
PLACEHOLDER_MESSAGE_PERCENT="%message%"
PLACEHOLDER_MESSAGE_POINTY="<message>"
PLACEHOLDER_NAME_PERCENT="%name%"
PLACEHOLDER_REPLY_PERCENT="%reply%"
PLACEHOLDER_SALES_BRACKETS='{sales}'
PLACEHOLDER_SECONDS_PERCENT="%seconds%"
PLACEHOLDER_SHEEP_BRACKETS='{sheep}'
PLACEHOLDER_STATE_PERCENT='%state%'
PLACEHOLDER_USERNAME_PERCENT='%username%'

if [ "${LOCALE}" = 'ro' ]; then
    WEBMAP_PAGE_TITLE="Harta ${SERVER_NAME}"
    INVALID_ACTION_MESSAGE="$(get_formatted_message error command Nu se poate efectua)"
    DISCONNECTED_MESSAGE='Conexiunea a fost întreruptă'
    NOT_ENOUGH_MONEY_MESSAGE="$(get_formatted_message error money Nu ai destui bani. Află mai multe cu $(get_command_mention /info bani))"
    JOIN_MESSAGE="$(get_action_message ${PLACEHOLDER_PLAYER} a intrat în joc)"
    QUIT_MESSAGE="$(get_action_message ${PLACEHOLDER_PLAYER} a ieșit din joc)"

    set_config_value "${BUKKIT_CONFIG_FILE}" 'settings.shutdown-message' "${SERVER_NAME} s-a oprit"
    set_config_value "${PAPER_GLOBAL_CONFIG_FILE}" 'messages.connection-throttled' 'Te-ai reconectat prea repede. Te rugăm să aștepți puțin.'
    set_config_value "${PURPUR_CONFIG_FILE}" "settings.messages.cannot-ride-mob" "$(get_formatted_message error mount Acest mob nu se poate călări)"
else
    WEBMAP_PAGE_TITLE="${SERVER_NAME} Map"
    INVALID_ACTION_MESSAGE="$(get_formatted_message error command This can\'t be done)"
    DISCONNECTED_MESSAGE='The connection got interrupted'
    NOT_ENOUGH_MONEY_MESSAGE="$(get_formatted_message error money You don\'t have enough money. Find out more with $(get_command_mention /info money))"
    JOIN_MESSAGE="$(get_action_message ${PLACEHOLDER_PLAYER} joined the game)"
    QUIT_MESSAGE="$(get_action_message ${PLACEHOLDER_PLAYER} left the game)"

    set_config_value "${BUKKIT_CONFIG_FILE}" 'settings.shutdown-message' "${SERVER_NAME} shut down"
    set_config_value "${PAPER_GLOBAL_CONFIG_FILE}" 'messages.connection-throttled' 'You reconnected too quickly. Please wait a moment.'
    set_config_value "${PURPUR_CONFIG_FILE}" "settings.messages.cannot-ride-mob" "$(get_formatted_message error mount This mob can\'t be mounted)"
fi
KICK_MESSAGE="${DISCONNECTED_MESSAGE}"
KICK_MESSAGE_MINIMESSAGE="$(convert_message_to_minimessage ${KICK_MESSAGE})"
INVALID_COMMAND_MESSAGE="${INVALID_ACTION_MESSAGE}"
INVALID_COMMAND_MINIMESSAGE="$(convert_message_to_minimessage ${INVALID_COMMAND_MESSAGE})"
NO_PERMISSION_MESSAGE="${INVALID_COMMAND_MESSAGE}"
NO_PERMISSION_MINIMESSAGE="${INVALID_COMMAND_MINIMESSAGE}"
NOT_ENOUGH_MONEY_MINIMESSAGE="$(convert_message_to_minimessage ${NOT_ENOUGH_MONEY_MESSAGE})"
JOIN_MINIMESSAGE="$(convert_message_to_minimessage ${JOIN_MESSAGE})"
QUIT_MINIMESSAGE="$(convert_message_to_minimessage ${QUIT_MESSAGE})"

set_config_value "${SPIGOT_CONFIG_FILE}"        'messages.unknown-command'  "${INVALID_COMMAND_MESSAGE}"
set_config_value "${PAPER_GLOBAL_CONFIG_FILE}"  'messages.no-permission'    "${INVALID_COMMAND_MINIMESSAGE}"

if is_plugin_installed 'PurpurExtras'; then
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'PurpurExtras' config \
            'settings.protect-blocks-with-loot.message' "$(get_formatted_message_minimessage error break_block Poți sparge cuferele cu comori doar dacă stai $(get_highlighted_message aplecat))"
            'settings.protect-blocks-with-loot.message' "$(get_formatted_message_minimessage error break_block Poți sparge spawnerele doar dacă stai $(get_highlighted_message aplecat))"
    else
        configure_plugin 'PurpurExtras' config \
            'settings.protect-blocks-with-loot.message' "$(get_formatted_message_minimessage error break_block You can only break loot chests while $(get_highlighted_message sneaking))"
            'settings.protect-spawners.message' "$(get_formatted_message_minimessage error break_block You can only break spawners while $(get_highlighted_message sneaking))"
    fi
fi

if is_plugin_installed 'AdvancedHelp'; then
    configure_plugin 'AdvancedHelp' config \
        'messages.no-permission' "${NO_PERMISSION_MESSAGE}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'AdvancedHelp' config \
            'messages.category-not-found' "$(get_formatted_message error help Categoria specificată nu există. Folosește $(get_command_mention /ajutor))" \
            'messages.page-not-found' "$(get_formatted_message error help Pagina specificată nu există)"
    else
        configure_plugin 'AdvancedHelp' config \
            'messages.category-not-found' "$(get_formatted_message error help The specified category doesn\' exist. Use $(get_command_mention /help))" \
            'messages.page-not-found' "$(get_formatted_message error help The specified page doesn\'t exist)"
    fi
fi

if is_plugin_installed 'AnarchyExploitFixes'; then
    configure_plugin 'AnarchyExploitFixes' config \
        'language.auto-language' false \
        'language.default-language' 'en_us'

    configure_plugin 'AnarchyExploitFixes' 'lang/en_us.yml' \
        'commands.command-whitelist.bad-command' "${INVALID_COMMAND_MINIMESSAGE}" \
        'commands.failed-argument-parse' "${INVALID_COMMAND_MINIMESSAGE}" \
        'commands.invalid-syntax' "${INVALID_COMMAND_MINIMESSAGE}" \
        'commands.no-permission' "${NO_PERMISSION_MINIMESSAGE}" \
        'join-leave-messages.join' "${JOIN_MINIMESSAGE}" \
        'join-leave-messages.leave' "${QUIT_MINIMESSAGE}" \
        'kicks.masked-kick-message' "${KICK_MINIMESSAGE}"
fi

if is_plugin_installed 'AuthMe'; then
#        "settings.customJoinMessage" "$(sed 's/PLAYER/DISPLAYNAMENOCOLOR/g' <<< ${JOIN_MESSAGE})" \
    configure_plugin 'AuthMe' config 'settings.messagesLanguage' "${LOCALE}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'AuthMe' "$(get_plugin_dir AuthMe)/messages/messages_ro.yml" \
            'error.denied_chat' "$(get_formatted_message error auth Trebuie să te autentifici pentru a putea vorbi)" \
            'error.denied_command' "${INVALID_COMMAND_MESSAGE}" \
            'error.logged_in' "$(get_formatted_message error auth Ești autentificat deja)" \
            'login.command_usage' "$(get_formatted_message info auth Utilizare: ${COLOUR_COMMAND}/auth ${COLOUR_COMMAND}'<Parolă>')" \
            'login.login_request' "$(get_formatted_message error auth Pentru a putea juca, autentifică-te cu $(get_command_mention /auth ${COLOUR_COMMAND_ARGUMENT}'<Parolă>'))" \
            'login.success' "$(get_formatted_message success auth Te-ai autentificat)" \
            'login.wrong_password' "$(get_formatted_message error auth Parola este greșită)" \
            'misc.accounts_owned_other' "$(get_formatted_message info auth $(get_player_mention ${PLACEHOLDER_PLAYER_SINGLEPERCENT}) are $(get_highlighted_message ${PLACEHOLDER_COUNT_SINGLEPERCENT}) username-uri)" \
            'misc.logout' "$(get_formatted_message success auth Te-ai deautentificat)" \
            'misc.password_changed' "$(get_formatted_message success auth Parola a fost schimbată)" \
            'misc.reload' "$(get_reload_message AuthMe)" \
            'password.match_error' "$(get_formatted_message error auth Parola de confirmare nu se potrivește)" \
            'registration.register_request' "$(get_formatted_message error auth Pentru a putea juca, înregistrează-te cu $(get_command_mention /register ${COLOUR_COMMAND_ARGUMENT}'<Parolă>' '<ConfirmareaParolei>'))" \
            'registration.success' "$(get_formatted_message success auth Te-ai înregistrat)" \
            'session.invalid_session' "$(get_formatted_message error auth Sesiunea de autentificare a expirat datorită schimbării adresei IP)" \
            'session.valid_session' "$(get_formatted_message success auth Te-ai autentificat automat de data trecută)"
    else
        configure_plugin 'AuthMe' "$(get_plugin_dir AuthMe)/messages/messages_en.yml" \
            'error.denied_chat' "$(get_formatted_message error auth You must authenticate in order to chat)" \
            'error.denied_command' "${INVALID_COMMAND_MESSAGE}" \
            'error.logged_in' "$(get_formatted_message error auth You are already authenticated)" \
            'login.command_usage' "$(get_formatted_message info auth Usage: ${COLOUR_COMMAND}/auth ${COLOUR_COMMAND}'<Parolă>')" \
            'login.login_request' "$(get_formatted_message error auth In order to able to play, login using $(get_command_mention /auth ${COLOUR_COMMAND_ARGUMENT}'<Password>'))" \
            'login.success' "$(get_formatted_message success auth You are now authenticated)" \
            'login.wrong_password' "$(get_formatted_message error auth The password is incorrect)" \
            'misc.accounts_owned_other' "$(get_formatted_message info auth $(get_player_mention ${PLACEHOLDER_PLAYER_SINGLEPERCENT}) has $(get_highlighted_message ${PLACEHOLDER_COUNT_SINGLEPERCENT}) usernames)" \
            'misc.logout' "$(get_formatted_message success auth You are now deauthenticated)" \
            'misc.password_changed' "$(get_formatted_message success auth The password was changed)" \
            'misc.reload' "$(get_reload_message AuthMe)" \
            'password.match_error' "$(get_formatted_message error auth The confirmation password does not match)" \
            'registration.register_request' "$(get_formatted_message error auth You must register in order to play.\\n${BULLETPOINT_LIST_MARKER}Use ${COLOUR_COMMAND}/register ${COLOUR_COMMAND_ARGUMENT}'<Password>' '<ConfirmPassword>'${COLOUR_MESSAGE})" \
            'registration.success' "$(get_formatted_message success auth You are now registered)" \
            'session.invalid_session' "$(get_formatted_message error auth The authentication session has expired due to your IP address having changed)" \
            'session.valid_session' "$(get_formatted_message success auth You authenticated automatically from the previous session)"
    fi
fi

if is_plugin_installed 'BestTools'; then
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'BestTools' config \
            'message-besttools-enabled' "$(get_formatted_message success tool Selectarea automată a uneltelor a fost $(get_enablement_message activată))" \
            'message-besttools-disabled' "$(get_formatted_message success tool Selectarea automată a uneltelor a fost $(get_enablement_message dezactivată))"
    else
        configure_plugin 'BestTools' config \
            'message-besttools-enabled' "$(get_formatted_message success tool Automatic tool selection has been $(get_enablement_message enabled))" \
            'message-besttools-disabled' "$(get_formatted_message success tool Automatic tool selection has been $(get_enablement_message disabled))"
    fi
fi

if is_plugin_installed 'ChatBubbles'; then
    configure_plugin 'ChatBubbles' messages 'Reload_Success' "$(get_reload_message ChatBubbles)"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'ChatBubbles' messages \
            'Toggle_Off'    "$(get_formatted_message success chat Afișarea mesajelor deasupra jucătorilor a fost $(get_enablement_message dezactivată))" \
            'Toggle_On'     "$(get_formatted_message success chat Afișarea mesajelor deasupra jucătorilor a fost $(get_enablement_message activată))"
    else
        configure_plugin 'ChatBubbles' messages \
            'Toggle_Off'    "$(get_formatted_message success chat Chat messages above player heads have been $(get_enablement_message disabled))" \
            'Toggle_On'     "$(get_formatted_message success chat Chat messages above player heads have been $(get_enablement_message enabled))"
    fi
fi

if is_plugin_installed 'ChestShop'; then
    configure_plugin 'ChestShop' messages \
        'prefix' "${COLOUR_RESET}" \
        'NOT_ENOUGH_MONEY'  "${NOT_ENOUGH_MONEY_MESSAGE}" \
        'NO_PERMISSION'     "${NO_PERMISSION_MESSAGE}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'ChestShop' messages \
            'CANNOT_CREATE_SHOP_HERE'           "$(get_formatted_message error trade Nu poți crea oferte de vânzare în afara zonelor special amenajate)" \
            'INCORRECT_ITEM_ID'                 "$(get_formatted_message error trade Obiectul alocat ofertei nu este valid)" \
            'NO_BUYING_HERE'                    "$(get_formatted_message error trade Această ofertă permite doar vânzarea $(get_obscured_message \(click stânga\)))" \
            'NO_CHEST_DETECTED'                 "$(get_formatted_message error trade Nu a fost găsit nici un container)" \
            'NO_SELLING_HERE'                   "$(get_formatted_message error trade Această ofertă permite doar cumpărarea $(get_obscured_message \(click dreapta\)))" \
            'NO_SHOP_FOUND'                     "$(get_formatted_message error trade Nu s-a găsit nici o ofertă)" \
            'NOT_ENOUGH_MONEY_SHOP'             "$(get_formatted_message error trade Proprietarul nu are destui bani)" \
            'NOT_ENOUGH_ITEMS_TO_SELL'          "$(get_formatted_message error trade Nu ai destule obiecte pentru a le vinde)" \
            'NOT_ENOUGH_SPACE_IN_CHEST'         "$(get_formatted_message error inventory Oferta are inventarul plin)" \
            'NOT_ENOUGH_SPACE_IN_INVENTORY'     "$(get_formatted_message error inventory Ai inventarul plin)" \
            'NOT_ENOUGH_SPACE_IN_YOUR_SHOP'     "$(get_formatted_message error inventory Magazinul tău are inventarul de $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) plin)" \
            'NOT_ENOUGH_STOCK'                  "$(get_formatted_message error trade Oferta nu are stoc suficient)" \
            'NOT_ENOUGH_STOCK_IN_YOUR_SHOP'     "$(get_formatted_message error trade Magazinul tău a rămas fără stoc de $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}))" \
            'PLAYER_NOT_FOUND'                  "$(get_formatted_message error trade Jucătorul nu există)" \
            'SHOP_CREATED'                      "$(get_formatted_message success trade Oferta de vânzare a fost creată)" \
            'SOMEBODY_BOUGHT_FROM_YOUR_SHOP'    "$(get_formatted_message info trade $(get_player_mention ${PLACEHOLDER_BUYER_SINGLEPERCENT}) a cumpărat $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) cu $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}) de la magazinul tău)" \
            'SOMEBODY_SOLD_TO_YOUR_SHOP'        "$(get_formatted_message info trade $(get_player_mention ${PLACEHOLDER_SELLER_SINGLEPERCENT}) a vândut $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) cu $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}) la magazinul tău)" \
            'TOGGLE_ACCESS_OFF'                 "$(get_formatted_message info trade Tranzacționarea cu propriile oferte a fost $(get_enablement_message activată))" \
            'TOGGLE_ACCESS_ON'                  "$(get_formatted_message info trade Tranzacționarea cu propriile oferte a fost $(get_enablement_message dezactivată))" \
            'TOGGLE_MESSAGES_OFF'               "$(get_formatted_message info trade Notificările cu tranzacții de la magazin au fost $(get_enablement_message dezactivate))" \
            'TOGGLE_MESSAGES_ON'                "$(get_formatted_message info trade Notificările cu tranzacții de la magazin au fost $(get_enablement_message activate))" \
            'TRADE_DENIED_ACCESS_PERMS'         "$(get_formatted_message error trade Nu poți tranzacționa cu propriile oferte. Folosește $(get_command_mention /csaccess))" \
            'YOU_BOUGHT_FROM_SHOP'              "$(get_formatted_message success trade Ai cumpărat $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) cu $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}))" \
            'YOU_SOLD_TO_SHOP'                  "$(get_formatted_message success trade Ai vândut $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) cu $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}))"
    else
        configure_plugin 'ChestShop' messages \
            'CANNOT_CREATE_SHOP_HERE'           "$(get_formatted_message error trade You can\'t create trade offers outside of the designated areas)" \
            'INCORRECT_ITEM_ID'                 "$(get_formatted_message error trade The item assigned to the offer is not valid)" \
            'NO_BUYING_HERE'                    "$(get_formatted_message error trade This offer only allows selling $(get_obscured_message \(left click\)))" \
            'NO_CHEST_DETECTED'                 "$(get_formatted_message error trade No container found)" \
            'NO_SELLING_HERE'                   "$(get_formatted_message error trade This offer only allows buying $(get_obscured_message \(right-click\)))" \
            'NO_SHOP_FOUND'                     "$(get_formatted_message error trade No trade offer found)" \
            'NOT_ENOUGH_ITEMS_TO_SELL'          "$(get_formatted_message error trade You don\'t have enough items to sell)" \
            'NOT_ENOUGH_MONEY_SHOP'             "$(get_formatted_message error trade The offer doesn\'t have enough money)" \
            'NOT_ENOUGH_SPACE_IN_CHEST'         "$(get_formatted_message error inventory The offer1s inventory is full)" \
            'NOT_ENOUGH_SPACE_IN_INVENTORY'     "$(get_formatted_message error inventory Your inventory is full)" \
            'NOT_ENOUGH_SPACE_IN_YOUR_SHOP'     "$(get_formatted_message error inventory Your shop1s $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) inventory is full)" \
            'NOT_ENOUGH_STOCK'                  "$(get_formatted_message error trade The offer is out of stock)" \
            'NOT_ENOUGH_STOCK_IN_YOUR_SHOP'     "$(get_formatted_message error trade Your shop ran out of $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) stock)" \
            'PLAYER_NOT_FOUND'                  "$(get_formatted_message error trade That player doesn\'t exist)" \
            'SHOP_CREATED'                      "$(get_formatted_message success trade The offer was set up)" \
            'SOMEBODY_BOUGHT_FROM_YOUR_SHOP'    "$(get_formatted_message info trade $(get_player_mention ${PLACEHOLDER_BUYER_SINGLEPERCENT}) bought $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) for $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}) from your shop)" \
            'SOMEBODY_SOLD_TO_YOUR_SHOP'        "$(get_formatted_message info trade $(get_player_mention ${PLACEHOLDER_SELLER_SINGLEPERCENT}) sold $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) for $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}) to your shop)" \
            'TOGGLE_ACCESS_OFF'                 "$(get_formatted_message info trade Transacting with your own trades has been $(get_enablement_message enabled))" \
            'TOGGLE_ACCESS_ON'                  "$(get_formatted_message info trade Transacting with your own trades has been $(get_enablement_message disabled))" \
            'TOGGLE_MESSAGES_OFF'               "$(get_formatted_message info trade The trade notifications have been $(get_enablement_message disabled))" \
            'TOGGLE_MESSAGES_ON'                "$(get_formatted_message info trade The trade notifications have been $(get_enablement_message enabled))" \
            'TRADE_DENIED_ACCESS_PERMS'         "$(get_formatted_message error trade You can\'t trade with your own shops. Use $(get_command_mention /csaccess))" \
            'YOU_BOUGHT_FROM_SHOP'              "$(get_formatted_message success trade You bought $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) for $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}))" \
            'YOU_SOLD_TO_SHOP'                  "$(get_formatted_message success trade You sold $(get_highlighted_message ${PLACEHOLDER_ITEM_SINGLEPERCENT}) for $(get_highlighted_message ${PLACEHOLDER_PRICE_SINGLEPERCENT}))"
    fi

    if is_plugin_installed 'ChestShopNotifier'; then
        configure_plugin 'ChestShopNotifier' config \
            'messages.history-others-not-allowed' "${INVALID_COMMAND_MESSAGE}" \
            'messages.reload-success' "$(get_reload_message ChestShopNotifier)"

        if [ "${LOCALE}" = 'ro' ]; then
            configure_plugin 'ChestShopNotifier' config \
                'messages.history-clear' "$(get_formatted_message success trade Istoricul tranzacțiilor a fost golit)" \
                'messages.history-cmd' "$(get_formatted_message info trade Verifică istoricul tranzacțiilor cu $(get_command_mention /shoplog))" \
                'messages.history-footer-clear' "$(get_formatted_message info trade Poți să îl golești cu $(get_command_mention /shoplog golire))" \
                'messages.sales' "$(get_formatted_message info trade În magazinul tău s-au efectuat $(get_highlighted_message ${PLACEHOLDER_SALES_BRACKETS} tranzacții) de când ai ieșit)"
        else
            configure_plugin 'ChestShopNotifier' config \
                'messages.history-clear' "$(get_formatted_message success trade Your transaction log has been cleared)" \
                'messages.history-cmd' "$(get_formatted_message info trade See the trades log using $(get_command_mention /shoplog))" \
                'messages.history-footer-clear' "$(get_formatted_message info trade You can clear it by using $(get_command_mention /shoplog clear))" \
                'messages.sales' "$(get_formatted_message info trade Your shop made $(get_highlighted_message ${PLACEHOLDER_SALES_BRACKETS}) trades since you last checked)"
        fi
    fi
fi

if is_plugin_installed 'ChestSort'; then
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'ChestSort' config \
            'message-container-sorted' "$(get_formatted_message success inventory Containerul a fost sortat)" \
            'message-inv-sorting-disabled' "$(get_formatted_message sccess inventory Sortarea automată a fost $(get_enablement_message dezactivată) pentru $(get_highlighted_message inventar))" \
            'message-inv-sorting-enabled' "$(get_formatted_message success inventory Sortarea automată a fost $(get_enablement_message activată) pentru $(get_highlighted_message inventar))" \
            'message-player-inventory-sorted' "$(get_formatted_message success inventory Inventarul tău a fost sortat)" \
            'message-sorting-disabled' "$(get_formatted_message success inventory Sortarea automată a fost $(get_enablement_message dezactivată) pentru $(get_highlighted_message containere))" \
            'message-sorting-enabled' "$(get_formatted_message success inventory Sortarea automată a fost $(get_enablement_message activată) pentru $(get_highlighted_message containere))" \
            'message-when-using-chest' "$(get_info_message Poți $(get_enablement_message porni) sortarea automată a $(get_highlighted_message containerelor) cu $(get_command_mention /csort on))" \
            'message-when-using-chest2' "$(get_info_message Poți $(get_enablement_message opri) sortarea automată a $(get_highlighted_message containerelor) cu $(get_command_mention /csort off))"
    else
        configure_plugin 'ChestSort' config \
            'message-container-sorted' "$(get_formatted_message success inventory The container has been sorted)" \
            'message-inv-sorting-disabled' "$(get_formatted_message success inventory Automatic $(get_highlighted_message inventory) sorting has been $(get_enablement_message disabled))" \
            'message-inv-sorting-enabled' "$(get_formatted_message success inventory Automatic $(get_highlighted_message inventory) sorting has been $(get_enablement_message enabled))" \
            'message-player-inventory-sorted' "$(get_formatted_message success inventory Your inventory has been sorted)" \
            'message-sorting-disabled' "$(get_formatted_message success inventory Automatic $(get_highlighted_message container) sorting has been $(get_enablement_message disabled))" \
            'message-sorting-enabled' "$(get_formatted_message success inventory Automatic $(get_highlighted_message container) sorting has been $(get_enablement_message enabled))" \
            'message-when-using-chest' "$(get_info_message Automatic sorting for $(get_highlighted_message containers) can be $(get_enablement_message enabled) using $(get_command_mention /csort on))" \
            'message-when-using-chest2' "$(get_info_message Automatic sorting for $(get_highlighted_message containers) can be $(get_enablement_message disabled) using $(get_command_mention /csort off))"
    fi
fi

if is_plugin_installed 'DeathMessages'; then
    configure_plugin 'DeathMessages' config 'Add-Prefix-To-All-Messages' false

    configure_plugin "DeathMessages" messages \
        "Commands.DeathMessages.No-Permission" "${NO_PERMISSION_MESSAGE}" \
        "Commands.DeathMessages.Sub-Commands.Reload.Reloaded" "$(get_reload_message DeathMessages)" \
        "Discord.DeathMessage.Color" "BLACK" \
        "Discord.DeathMessage.Content" " " \
        "Discord.DeathMessage.Description" " " \
        "Discord.DeathMessage.Footer.Text" " " \
        "Discord.DeathMessage.Image" " " \
        "Discord.DeathMessage.Remove-Plugin-Prefix" true \
        "Discord.DeathMessage.Timestamp" false \
        "Discord.DeathMessage.Title" " " \
        "Prefix" "${COLOUR_RESET}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'DeathMessages' messages \
            'Mobs.Bat' 'Liliac' \
            'Mobs.Skeleton' 'Schelet' \
    else
        configure_plugin 'DeathMessages' messages \
            'Mobs.Bat' 'Bat' \
            'Mobs.Skeleton' 'Skeleton'
    fi
fi

if is_plugin_installed 'DiscordSRV'; then
    if is_plugin_installed 'Dynmap'; then
        configure_plugin 'DiscordSRV' messages \
            'DynmapNameFormat' "${PLACEHOLDER_USERNAME_PERCENT}"
    fi

    configure_plugin 'DiscordSRV' messages \
        'DiscordToMinecraftChatMessageFormat' "$(get_player_mention ${PLACEHOLDER_NAME_PERCENT})${COLOUR_CHAT}:${COLOUR_MESSAGE}${PLACEHOLDER_REPLY_PERCENT} ${COLOUR_CHAT}${PLACEHOLDER_MESSAGE_PERCENT}" \

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'DiscordSRV' messages \
            'DiscordChatChannelListCommandFormatNoOnlinePlayers' "**Nu sunt jucători online.**" \
            'DiscordChatChannelListCommandFormatOnlinePlayers' "**Sunt ${PLACEHOLDER_PLAYERCOUNT_PERCENT} jucători online:**" \
            'MinecraftPlayerAchievementMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} a realizat ${PLACEHOLDER_ACHIEVEMENT_PERCENT}!" \
            'MinecraftPlayerFirstJoinMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} a intrat în joc pentru prima dată!" \
            'MinecraftPlayerJoinMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} a intrat în joc!" \
            'MinecraftPlayerLeaveMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} a ieșit din joc!"
    else
        configure_plugin 'DiscordSRV' messages \
            'DiscordChatChannelListCommandFormatNoOnlinePlayers' "**There are no online players.**" \
            'DiscordChatChannelListCommandFormatOnlinePlayers' "**There are ${PLACEHOLDER_PLAYERCOUNT_PERCENT} online players:**" \
            'MinecraftPlayerAchievementMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} achieved ${PLACEHOLDER_ACHIEVEMENT_PERCENT}!" \
            'MinecraftPlayerFirstJoinMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} joined the game for the first time!" \
            'MinecraftPlayerJoinMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} joined the game!" \
            'MinecraftPlayerLeaveMessage.Embed.Author.Name' "${PLACEHOLDER_USERNAME_PERCENT} left the game!"
    fi
fi

if is_plugin_installed 'DynamicLights'; then
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'DynamicLights' messages \
            'language.disable-lock'          "$(get_formatted_message_minimessage success light Plasarea luminilor din mâna stângă a fost $(get_enablement_message activată))" \
            'language.enable-lock'           "$(get_formatted_message_minimessage success light Plasarea luminilor din mâna stângă a fost $(get_enablement_message dezactivată))" \
            'language.prevent-block-place'   "$(get_formatted_message_minimessage error light Plasarea luminilor din mâna stângă este $(get_enablement_message dezactivată))" \
            'language.reload'                "$(get_reload_message_minimessage DynamicLights)" \
            'language.toggle-off'            "$(get_formatted_message_minimessage success light Randarea luminilor dinamice a fost $(get_enablement_message dezactivată))" \
            'language.toggle-on'             "$(get_formatted_message_minimessage success light Randarea luminilor dinamice a fost $(get_enablement_message activată))"
    else
        configure_plugin 'DynamicLights' messages \
            'language.disable-lock'          "$(get_formatted_message_minimessage success light Placing light sources from the off-hand has been $(get_enablement_message enabled))" \
            'language.enable-lock'           "$(get_formatted_message_minimessage success light Placing light sources from the off-hand has been $(get_enablement_message disabled))" \
            'language.prevent-block-place'   "$(get_formatted_message_minimessage error light Placing items from the off-hand is currently $(get_enablement_message disabled))" \
            'language.reload'                "$(get_reload_message_minimessage DynamicLights)" \
            'language.toggle-off'            "$(get_formatted_message_minimessage success light The rendering of dynamic lights has been $(get_enablement_message disabled))" \
            'language.toggle-on'             "$(get_formatted_message_minimessage success light The rendering of dynamic lights has been $(get_enablement_message enabled))"
    fi
fi

configure_plugin 'Dynmap' config \
    'webpage-title' "${WEBMAP_PAGE_TITLE}"

if is_plugin_installed 'EssentialsX'; then
    configure_plugin 'EssentialsX' config \
        'chat.format'                           "$(get_player_mention ${PLACEHOLDER_DISPLAYNAME_BRACKETS}): ${COLOUR_CHAT}${PLACEHOLDER_MESSAGE}" \
        'custom-join-message'                   "${JOIN_MESSAGE}" \
        'custom-new-username-message'           "${JOIN_MESSAGE}" \
        'custom-quit-message'                   "${QUIT_MESSAGE}" \
        'locale'                                "${LOCALE}" \
        'message-colors.primary'                "${COLOUR_MESSAGE_HEX}" \
        'message-colors.secondary'              "${COLOUR_HIGHLIGHT_HEX}"

    configure_plugin 'EssentialsX' "${ESSENTIALS_DIR}/messages/messages_${LOCALE}.properties" \
        'balanceTopLine'    "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER} $(get_obscured_message ${PLACEHOLDER_ARG0}) $(get_player_mention ${PLACEHOLDER_ARG1}) ${PLACEHOLDER_ARG2})" \
        'errorWithMessage'  "${PLACEHOLDER_ARG0}" \
        'noAccessCommand'   "${NO_PERMISSION_MINIMESSAGE}" \
        'noPerm'            "${NO_PERMISSION_MINIMESSAGE}" \
        'notEnoughMoney'    "${NOT_ENOUGH_MONEY_MINIMESSAGE}" \
        'orderBalances'     '' \
        'vanished'          '' \
        'whoisAFK'          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}AFK: $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
        'whoisIPAddress'    "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}IP: $(get_highlighted_message ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0}))" \
        'youAreHealed'      ''

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'EssentialsX' config \
            'newbies.announce-format'       "$(get_announcement_message Bun venit $(get_player_mention ${PLACEHOLDER_DISPLAYNAME_BRACKETS}) ${COLOUR_ANNOUNCEMENT}pe ${COLOUR_HIGHLIGHT}${SERVER_NAME})"

        create_file "${ESSENTIALS_DIR}/messages/messages_ro.properties"
        configure_plugin "EssentialsX" "${ESSENTIALS_DIR}/messages/messages_ro.properties" \
            'action'                            "$(get_action_message_minimessage ${PLACEHOLDER_ARG0} ${PLACEHOLDER_ARG1})" \
            'addedToAccount'                    "$(get_formatted_message_minimessage info money Ți s-au adăugat $(get_highlighted_message ${PLACEHOLDER_ARG0}) în cont)" \
            'addedToOthersAccount'              "$(get_formatted_message_minimessage info money S-au adăugat $(get_highlighted_message ${PLACEHOLDER_ARG0}) în contul bancar al lui $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'backAfterDeath'                    "$(get_info_minimessage Te poți întoarce unde ai murit cu $(get_command_mention /back))" \
            'backOther'                         "$(get_formatted_message_minimessage success teleport $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}s-a întors la locația anterioară)" \
            'backUsageMsg'                      "$(get_formatted_message_minimessage success teleport Te-ai întors la locația anterioară)" \
            'balance'                           "$(get_formatted_message_minimessage info money Soldul contului tău bancar este de $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'balanceOther'                      "$(get_formatted_message_minimessage info money $(get_player_mention ${PLACEHOLDER_ARG0}) are în cont $(get_highlighted_message ${PLACEHOLDER_ARG1}))" \
            'balanceTop'                        "$(get_formatted_message_minimessage info money Top cei mai bogați jucători: $(get_obscured_message \(${PLACEHOLDER_ARG0}\)))" \
            'broadcast'                         "$(get_announcement_message_minimessage ${PLACEHOLDER_ARG0})" \
            'commandCooldown'                   "$(get_formatted_message_minimessage error command You must wait $(get_highlighted_message ${PLACEHOLDER_ARG0}) before running that command again)" \
            'createdKit'                        "$(get_formatted_message_minimessage success kit Created kit $(get_highlighted_message ${PLACEHOLDER_ARG0}) with $(get_highlighted_message ${PLACEHOLDER_ARG1} items) and a delay of $(get_highlighted_message ${PLACEHOLDER_ARG2}))" \
            'deleteHome'                        "$(get_formatted_message_minimessage success home Casa ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}a fost ștearsă)" \
            'deleteWarp'                        "$(get_formatted_message_minimessage success warp Warp-ul $(get_location_mention ${PLACEHOLDER_ARG0}) a fost șters)" \
            'enchantmentApplied'                "$(get_formatted_message_minimessage success enchant Farmecul $(get_highlighted_message ${PLACEHOLDER_ARG0}) a fost aplicat)" \
            'enchantmentNotFound'               "$(get_formatted_message_minimessage error enchant Farmecul $(get_highlighted_message ${PLACEHOLDER_ARG0}) nu este valid)" \
            'enchantmentRemoved'                "$(get_formatted_message_minimessage success enchant Farmecul $(get_highlighted_message ${PLACEHOLDER_ARG0}) a fost scos)" \
            'essentialsReload'                  "$(get_reload_message_minimessage EssentialsX ${PLACEHOLDER_ARG0})" \
            'false'                             "$(convert_message_to_minimessage ${COLOUR_RED_DARK}nu${COLOUR_MESSAGE})" \
            'flying'                            "$(convert_message_to_minimessage $(get_highlighted_message zbor))" \
            'flyMode'                           "$(get_formatted_message_minimessage success movement Zborul ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}pentru $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'gameMode'                          "$(get_formatted_message_minimessage success gamemode $(get_player_mention ${PLACEHOLDER_ARG1}) joacă acum în modul $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'godModeDisabledFor'                "$(convert_message_to_minimessage $(get_enablement_message dezactivat) pentru $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'godModeEnabledFor'                 "$(convert_message_to_minimessage $(get_enablement_message activat) pentru $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'godMode'                           "$(get_formatted_message_minimessage success gamemode Modul invincibil a fost $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'healOther'                         "$(get_formatted_message_minimessage success health $(get_player_mention ${PLACEHOLDER_ARG0}) a fost vindecat)" \
            'homes'                             "$(get_formatted_message_minimessage info home Case: $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'homeSet'                           "$(get_formatted_message_minimessage success home Casa a fost setată la locația curentă)" \
            'inventoryClearingAllArmor'         "$(get_formatted_message_minimessage success inventory Inventarul și armurile lui $(get_player_mention ${PLACEHOLDER_ARG0}) au fost golite)" \
            'inventoryClearingAllItems'         "$(get_formatted_message_minimessage success inventory Inventarul lui $(get_player_mention ${PLACEHOLDER_ARG0}) a fost golit)" \
            'itemloreClear'                     "$(get_formatted_message_minimessage success name Descrierile obiectului din mână au fost șterse)" \
            'itemloreNoLine'                    "$(get_formatted_message_minimessage success name Obiectul din mână nu are o descriere pe $(get_highlighted_message linia ${PLACEHOLDER_ARG0}))" \
            'itemloreNoLore'                    "$(get_formatted_message_minimessage success name Obiectul din mână nu are nici o descriere)" \
            'itemloreSuccess'                   "$(get_formatted_message_minimessage success name Descrierea \"$(get_highlighted_message ${PLACEHOLDER_ARG0})\" a fost adăugată obiectului din mână)" \
            'itemloreSuccessLore'               "$(get_formatted_message_minimessage success name Descrierea \"$(get_highlighted_message ${PLACEHOLDER_ARG1})\" a fost setată pe $(get_highlighted_message linia ${PLACEHOLDER_ARG0}) a obiectului din mână)" \
            'itemnameClear'                     "$(get_formatted_message_minimessage success name Numele obiectului din mână a fost resetat)" \
            'itemnameSuccess'                   "$(get_formatted_message_minimessage success name Obiectul din mână a fost redenumit în \"$(get_highlighted_message ${PLACEHOLDER_ARG0})\")" \
            'kitOnce'                           "$(get_formatted_message_minimessage error kit Nu mai poți obține acest kit din nou)" \
            'kitReceive'                        "$(get_formatted_message_minimessage success kit Ai primit kit-ul $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'kitReset'                          "$(get_formatted_message_minimessage success kit Timpul de așteptare al kit-ului $(get_highlighted_message ${PLACEHOLDER_ARG0}) a fost resetat)" \
            'kitResetOther'                     "$(get_formatted_message_minimessage success kit Timpul de așteptare al kit-ului $(get_highlighted_message ${PLACEHOLDER_ARG0}) a fost resetat pentru $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'listAmount'                        "$(get_formatted_message_minimessage info inspect Sunt $(get_highlighted_message ${PLACEHOLDER_ARG0}) jucători online)" \
            'listAmountHidden'                  "$(get_formatted_message_minimessage info inspect Sunt $(get_highlighted_message ${PLACEHOLDER_ARG0}) jucători online)" \
            'maxHomes'                          "$(get_formatted_message_minimessage error home Nu poți seta mai mult de $(get_highlighted_message ${PLACEHOLDER_ARG0} case))" \
            'meRecipient'                       "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}eu)" \
            'meSender'                          "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}eu)" \
            'moveSpeed'                         "$(get_formatted_message_minimessage success movement Viteza de $(get_highlighted_message ${PLACEHOLDER_ARG0}) a fost schimbată la $(get_highlighted_message ${PLACEHOLDER_ARG1}) pentru $(get_player_mention ${PLACEHOLDER_ARG2}))" \
            'moneyRecievedFrom'                 "$(get_formatted_message_minimessage info money Ai primit $(get_highlighted_message ${PLACEHOLDER_ARG0}) de la $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'moneySentTo'                       "$(get_formatted_message_minimessage success money Ai trimis $(get_highlighted_message ${PLACEHOLDER_ARG0}) la $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'msgFormat'                         "$(get_formatted_message_minimessage info message $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_CHAT_PRIVATE}→ $(get_player_mention ${PLACEHOLDER_ARG1})${COLOUR_CHAT_PRIVATE}: ${COLOUR_CHAT_PRIVATE}${PLACEHOLDER_ARG2})" \
            'noPendingRequest'                  "$(get_formatted_message_minimessage error player Nu ai nici o cerere în așteptare)" \
            'payOffline'                        "$(get_formatted_message_minimessage error money Nu poți trimite bani unui jucător offline)" \
            'pendingTeleportCancelled'          "$(get_formatted_message_minimessage error player Cererea de teleportare a fost anulată)" \
            'playerNeverOnServer'               "$(get_formatted_message_minimessage error inspect $(get_player_mention ${PLACEHOLDER_ARG0}) nu a jucat niciodată pe $(get_highlighted_message ${SERVER_NAME}))" \
            'playerNotFound'                    "$(get_formatted_message_minimessage error other Jucătorul specificat nu este online)" \
            'playtime'                          "$(get_formatted_message_minimessage info inspect Ai petrecut $(get_highlighted_message ${PLACEHOLDER_ARG0}) pe $(get_highlighted_message ${SERVER_NAME}))" \
            'playtimeOther'                     "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG1}) a petrecut $(get_highlighted_message ${PLACEHOLDER_ARG0}) pe $(get_highlighted_message ${SERVER_NAME}))" \
            'readNextPage'                      "$(get_formatted_message_minimessage info info Poți citi următoarea pagină cu $(get_command_mention /${PLACEHOLDER_ARG0} ${PLACEHOLDER_ARG1}))" \
            'requestAccepted'                   "$(get_formatted_message_minimessage success player Cererea de teleportare a fost acceptată)" \
            'requestAcceptedFrom'               "$(get_formatted_message_minimessage success player $(get_player_mention ${PLACEHOLDER_ARG0}) a acceptat cererea de telportare)" \
            'requestDenied'                     "$(get_formatted_message_minimessage error player Cererea de teleportare a fost respinsă)" \
            'requestDeniedFrom'                 "$(get_formatted_message_minimessage error player $(get_player_mention ${PLACEHOLDER_ARG0}) a respins cererea de teleportare)" \
            'requestSent'                       "$(get_formatted_message_minimessage info player Cererea de teleportare a fost trimisă către $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'requestSentAlready'                "$(get_formatted_message_minimessage error player Ai trimis deja o cerere de teleportare către $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'requestTimedOut'                   "$(get_formatted_message_minimessage error player Cererea de teleportare a expirat)" \
            'requestTimedOutFrom'               "$(get_formatted_message_minimessage error player Cererea de teleportare de la $(get_player_mention ${PLACEHOLDER_ARG0}) a expirat)" \
            'second'                            'secundă' \
            'seenAccounts'                      "$(get_formatted_message_minimessage info inspect Asociat cu: $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'seenOffline'                       "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) este ${COLOUR_RED_DARK}offline ${COLOUR_MESSAGE}de $(get_highlighted_message ${PLACEHOLDER_ARG1}))" \
            'seenOnline'                        "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) este ${COLOUR_GREEN_LIGHT}online ${COLOUR_MESSAGE}de $(get_highlighted_message ${PLACEHOLDER_ARG1}))" \
            'serverTotal'                       "$(get_formatted_message_minimessage info money În economia $(get_highlighted_message ${SERVER_NAME}) circulă $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'setBal'                            "$(get_formatted_message_minimessage success money Contul tău bancar a fost setat la $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'setBalOthers'                      "$(get_formatted_message_minimessage success money Contul bancar al lui $(get_player_mention ${PLACEHOLDER_ARG0}) a fost setat la $(get_highlighted_message ${PLACEHOLDER_ARG1}))" \
            'sudoRun'                           "$(get_formatted_message_minimessage info command $(get_player_mention ${PLACEHOLDER_ARG0}) a fost forțat să execute $(get_command_mention /${PLACEHOLDER_ARG1}))" \
            'takenFromAccount'                  "$(get_formatted_message_minimessage info money Ți s-au retras $(get_highlighted_message ${PLACEHOLDER_ARG0}) din cont)" \
            'takenFromOthersAccount'            "$(get_formatted_message_minimessage info money S-au retras $(get_highlighted_message ${PLACEHOLDER_ARG0}) din contul bancar al lui $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'teleportationEnabled'              "$(get_formatted_message_minimessage info player Cererile de teleportare au fost $(get_enablement_message activate))" \
            'teleportationDisabled'             "$(get_formatted_message_minimessage info player Cererile de teleportare au fost $(get_enablement_message dezactivate))" \
            'teleportBottom'                    "$(get_formatted_message_minimessage success teleport Te-ai teleportat la cel mai de $(get_highlighted_message jos) loc al locației tale)" \
            'teleportDisabled'                  "$(get_formatted_message_minimessage error player $(get_player_mention ${PLACEHOLDER_ARG0}) are cererile de teleportare $(get_enablement_message dezactivate))" \
            'teleportHereRequest'               "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) ți-a cerut să te teleportezi la locația sa)" \
            'teleportHome'                      "$(get_formatted_message_minimessage success home Te-ai teleportat la $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'teleporting'                       "$(get_formatted_message_minimessage success teleport Teleportarea s-a realizat)" \
            'teleportRequest'                   "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) ți-a cerut să se teleporteze la locația ta)" \
            'teleportRequestSpecificCancelled'  "$(get_formatted_message_minimessage info player Cererea de teleportare către $(get_player_mention ${PLACEHOLDER_ARG0}) a fost anulată)" \
            'teleportRequestTimeoutInfo'        "$(get_formatted_message_minimessage info player Această cerere va expira după $(get_highlighted_message ${PLACEHOLDER_ARG0} secunde))" \
            'teleportTop'                       "$(get_formatted_message_minimessage success teleport Te-ai teleportat la cel mai de $(get_highlighted_message sus) loc al locației tale)" \
            'teleportToPlayer'                  "$(get_formatted_message_minimessage success player Te-ai teleportat la $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'timeBeforeTeleport'                "$(get_formatted_message_minimessage error teleport Așteaptă $(get_highlighted_message ${PLACEHOLDER_ARG0}) înainte să te teleportezi din nou)" \
            'timeWorldSet'                      "$(get_formatted_message_minimessage success time Timpul în $(get_highlighted_message ${PLACEHOLDER_ARG1}) este acum $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'tprSuccess'                        "$(get_formatted_message_minimessage success teleport Te-ai teleportat la o locație aleatorie)" \
            'true'                              "$(convert_message_to_minimessage ${COLOUR_GREEN_LIGHT}da${COLOUR_MESSAGE})" \
            'typeTpacancel'                     "$(get_formatted_message_minimessage info player O poți anula cu $(get_command_mention /tpacancel))" \
            'typeTpaccept'                      "$(get_formatted_message_minimessage info player O poți aproba cu $(get_command_mention /tpda))" \
            'typeTpdeny'                        "$(get_formatted_message_minimessage info player O poți respinge cu $(get_command_mention /tpnu))" \
            'unsafeTeleportDestination'         "$(get_formatted_message_minimessage error teleport Casele nu pot fi setate în locații nesigure)" \
            'userIsAwaySelf'                    "$(get_formatted_message_minimessage success player Modul AFK a fost $(get_enablement_message activat))" \
            'vanish'                            "$(get_formatted_message_minimessage success gamemode Modul invizibil $(get_highlighted_message ${PLACEHOLDER_ARG1}) pentru $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'walking'                           "$(convert_message_to_minimessage $(get_highlighted_message mers))" \
            'warpingTo'                         "$(get_formatted_message_minimessage success warp Te-ai teleportat la $(get_location_mention ${PLACEHOLDER_ARG0}))" \
            'warpsCount'                        "$(get_formatted_message_minimessage info warp Există $(get_highlighted_message ${PLACEHOLDER_ARG0}) warp-uri. Pagina $(get_highlighted_message ${PLACEHOLDER_ARG1})/$(get_highlighted_message ${PLACEHOLDER_ARG2}))" \
            'warpNotExist'                      "$(get_formatted_message_minimessage error warp Destinația specificată nu este validă)" \
            'warpSet'                           "$(get_formatted_message_minimessage success warp Warp-ul $(get_location_mention ${PLACEHOLDER_ARG0}) a fost setat la locația curentă)" \
            'warpUsePermission'                 "$(get_formatted_message_minimessage error warp Destinația specificată nu este validă)" \
            'weatherStorm'                      "$(get_formatted_message_minimessage success weather Vremea în $(get_highlighted_message ${PLACEHOLDER_ARG0}) este de acum $(get_highlighted_message furtunoasă))" \
            'weatherStormFor'                   "$(get_formatted_message_minimessage success weather Vremea în $(get_highlighted_message ${PLACEHOLDER_ARG0}) va fi $(get_highlighted_message furtunoasă) pentru $(get_highlighted_message ${PLACEHOLDER_ARG1} secunde))" \
            'weatherSun'                        "$(get_formatted_message_minimessage success weather Vremea în $(get_highlighted_message ${PLACEHOLDER_ARG0}) este de acum $(get_highlighted_message însorită))" \
            'weatherSunFor'                     "$(get_formatted_message_minimessage success weather Vremea în $(get_highlighted_message ${PLACEHOLDER_ARG0}) va fi $(get_highlighted_message însorită) pentru $(get_highlighted_message ${PLACEHOLDER_ARG1} secunde))" \
            'whoisTop'                          "$(get_formatted_message_minimessage success inspect Informații despre $(get_player_mention ${PLACEHOLDER_ARG0}):)" \
            'whoisExp'                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Experiență: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisFly'                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Zbor: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisGamemode'                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Mod de joc: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisGod'                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Invincibilitate: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisHealth'                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Viață: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisHunger'                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Foame: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisJail'                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Arestat: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisLocation'                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Locație: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisMoney'                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Bani: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisNick'                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Nume: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisOp'                           "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Operator: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisPlaytime'                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Timp petrecut în joc: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisSpeed'                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Viteză: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisUuid'                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Identificator: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})"
    else
        configure_plugin 'EssentialsX' "${ESSENTIALS_CONFIG_FILE}" \
            'newbies.announce-format'       "$(get_announcement_message Welcome $(get_player_mention ${PLACEHOLDER_DISPLAYNAME_BRACKETS}) ${COLOUR_ANNOUNCEMENT}to $(get_highlighted_message ${SERVER_NAME}))"

        create_file "${ESSENTIALS_DIR}/messages/messages_en.properties"
        configure_plugin "EssentialsX" "${ESSENTIALS_DIR}/messages/messages_en.properties" \
            'action'                            "$(get_action_message_minimessage ${PLACEHOLDER_ARG0} ${PLACEHOLDER_ARG1})!" \
            'addedToAccount'                    "$(get_formatted_message_minimessage info money $(get_highlighted_message ${PLACEHOLDER_ARG0}) were added to your bank account)" \
            'addedToOthersAccount'              "$(get_formatted_message_minimessage info money $(get_highlighted_message ${PLACEHOLDER_ARG0}) were added to $(get_player_mention ${PLACEHOLDER_ARG1})\'s bank account)" \
            'backAfterDeath'                    "$(get_info_minimessage Use ${COLOUR_COMMAND}/b ${COLOUR_MESSAGE}to return to your death location)" \
            'backOther'                         "$(get_formatted_message_minimessage success teleport Returned $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}to their preivous location)" \
            'backUsageMsg'                      "$(get_formatted_message_minimessage success teleport Returned to your previous location)" \
            'balance'                           "$(get_formatted_message_minimessage info money Your bank account\'s balance is $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'balanceOther'                      "$(get_formatted_message_minimessage info money $(get_player_mention ${PLACEHOLDER_ARG0}) has $(get_highlighted_message ${PLACEHOLDER_ARG1}) in their bank account)" \
            'balanceTop'                        "$(get_formatted_message_minimessage info money Top richest players: $(get_obscured_message \(${PLACEHOLDER_ARG0}\)))" \
            'broadcast'                         "$(get_announcement_message_minimessage ${PLACEHOLDER_ARG0})" \
            'commandCooldown'                   "$(get_formatted_message_minimessage error command Trebuie să aștepți $(get_highlighted_message ${PLACEHOLDER_ARG0}) pentru a folosi comanda din nou)" \
            'createdKit'                        "$(get_formatted_message_minimessage success kit A fost creat kit-ul $(get_highlighted_message ${PLACEHOLDER_ARG0}) cu $(get_highlighted_message ${PLACEHOLDER_ARG1} obiecte) și timp de așteptare de $(get_highlighted_message ${PLACEHOLDER_ARG2}))" \
            'deleteHome'                        "$(get_formatted_message_minimessage success home Home ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}has been deleted)" \
            'deleteWarp'                        "$(get_formatted_message_minimessage success warp Warp $(get_location_mention ${PLACEHOLDER_ARG0}) has been deleted)" \
            'enchantmentApplied'                "$(get_formatted_message_minimessage success enchant The $(get_highlighted_message ${PLACEHOLDER_ARG0}) enchantment has been applied)" \
            'enchantmentNotFound'               "$(get_formatted_message_minimessage error enchant The $(get_highlighted_message ${PLACEHOLDER_ARG0}) enchantment is not valid)" \
            'enchantmentRemoved'                "$(get_formatted_message_minimessage success enchant The $(get_highlighted_message ${PLACEHOLDER_ARG0}) enchantment has been removed)" \
            'essentialsReload'                  "$(get_reload_message_minimessage EssentialsX ${PLACEHOLDER_ARG0})" \
            'false'                             "$(convert_message_to_minimessage ${COLOUR_RED_DARK}no${COLOUR_MESSAGE})" \
            'flying'                            "$(convert_message_to_minimessage $(get_highlighted_message flight))" \
            'flyMode'                           "$(get_formatted_message_minimessage success movement Flight ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'gameMode'                          "$(get_formatted_message_minimessage success gamemode Game mode changed to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'godModeDisabledFor'                "$(convert_message_to_minimessage $(get_enablement_status disabled) for $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'godModeEnabledFor'                 "$(convert_message_to_minimessage $(get_enablement_status enabled) for $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'godMode'                           "$(get_formatted_message_minimessage success gamemode Invincibility ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'healOther'                         "$(get_formatted_message_minimessage success health $(get_player_mention ${PLACEHOLDER_ARG0}) was healed)" \
            'homes'                             "$(get_formatted_message_minimessage success home Homes: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'homeSet'                           "$(get_formatted_message_minimessage success home Home set at the current location)" \
            'inventoryClearingAllArmor'         "$(get_formatted_message_minimessage success inventory $(get_player_mention ${PLACEHOLDER_ARG0})\'s inventory and armours have been cleared)" \
            'inventoryClearingAllItems'         "$(get_formatted_message_minimessage success inventory $(get_player_mention ${PLACEHOLDER_ARG0})\'s inventory has been cleared)" \
            'itemloreClear'                     "$(get_formatted_message_minimessage success name The descriptions of the held item were removed)" \
            'itemloreNoLine'                    "$(get_formatted_message_minimessage success name The held item has no description on $(get_highlighted_message line ${PLACEHOLDER_ARG0}))" \
            'itemloreNoLore'                    "$(get_formatted_message_minimessage success name The held item has no descriptions)" \
            'itemloreSuccess'                   "$(get_formatted_message_minimessage success name The \"$(get_highlighted_message ${PLACEHOLDER_ARG0})\" description was added to the held item)" \
            'itemloreSuccessLore'               "$(get_formatted_message_minimessage success name The \"$(get_highlighted_message ${PLACEHOLDER_ARG1})\" description was set on $(get_highlighted_message line ${PLACEHOLDER_ARG0}) of the held item)" \
            'itemnameClear'                     "$(get_formatted_message_minimessage success name The name of the held item was reset)" \
            'itemnameSuccess'                   "$(get_formatted_message_minimessage success name The held item has been renamed to $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'kitOnce'                           "$(get_formatted_message_minimessage error kit You can\'t get that kit anymore)" \
            'kitReceive'                        "$(get_formatted_message_minimessage success kit You have received the $(get_highlighted_message ${PLACEHOLDER_ARG0}) kit)" \
            'kitReset'                          "$(get_formatted_message_minimessage success kit The cooldown for kit $(get_highlighted_message ${PLACEHOLDER_ARG0}) has been reset)" \
            'kitResetOther'                     "$(get_formatted_message_minimessage success kit The cooldown for kit $(get_highlighted_message ${PLACEHOLDER_ARG0}) has been reset for $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'listAmount'                        "$(get_formatted_message_minimessage info inspect There are $(get_highlighted_message ${PLACEHOLDER_ARG0} players) online)" \
            'listAmountHidden'                  "$(get_formatted_message_minimessage info inspect There are $(get_highlighted_message ${PLACEHOLDER_ARG0} players) online)" \
            'maxHomes'                          "$(get_formatted_message_minimessage error home You can\'t set more than $(get_highlighted_message ${PLACEHOLDER_ARG0} homes))" \
            'meRecipient'                       "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}me)" \
            'meSender'                          "$(convert_message_to_minimessage ${COLOUR_HIGHLIGHT}me)" \
            'moneyRecievedFrom'                 "$(get_formatted_message_minimessage info money You received $(get_highlighted_message ${PLACEHOLDER_ARG0}) from $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'moneySentTo'                       "$(get_formatted_message_minimessage success money You sent $(get_highlighted_message ${PLACEHOLDER_ARG0}) to $(get_player_mention ${PLACEHOLDER_ARG1}))" \
            'moveSpeed'                         "$(get_formatted_message_minimessage success movement $(get_player_mention ${PLACEHOLDER_ARG2})\'s $(get_highlighted_message ${PLACEHOLDER_ARG0}) speed has been set to $(get_highlighted_message ${PLACEHOLDER_ARG1}))" \
            'msgFormat'                         "$(get_formatted_message_minimessage info message $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_CHAT_PRIVATE}→ $(get_player_mention ${PLACEHOLDER_ARG1})${COLOUR_CHAT_PRIVATE}: ${COLOUR_CHAT_PRIVATE}${PLACEHOLDER_ARG2})" \
            'noPendingRequest'                  "$(get_formatted_message_minimessage error player There are no pending requests)" \
            'pendingTeleportCancelled'          "$(get_formatted_message_minimessage error player Cererea de teleportare în așteptare a fost anulată)" \
            'payOffline'                        "$(get_formatted_message_minimessage error money You can\'t send money to offline players)" \
            'playerNeverOnServer'               "$(get_formatted_message_minimessage error inspect $(get_player_mention ${PLACEHOLDER_ARG0}) never played on $(get_highlighted_message ${SERVER_NAME}))" \
            'playerNotFound'                    "$(get_formatted_message_minimessage error other The specified player is not online)" \
            'playtime'                          "$(get_formatted_message_minimessage info inspect You spent $(get_highlighted_message ${PLACEHOLDER_ARG0}) on $(get_highlighted_message ${SERVER_NAME}))" \
            'playtimeOther'                     "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG1}) spent $(get_highlighted_message ${PLACEHOLDER_ARG0}) on $(get_highlighted_message ${SERVER_NAME}))" \
            'readNextPage'                      "$(get_formatted_message_minimessage info info You can read the next page using $(get_command_mention /${PLACEHOLDER_ARG0} ${PLACEHOLDER_ARG1}))" \
            'requestAccepted'                   "$(get_formatted_message_minimessage success player Teleportation request accepted)" \
            'requestAcceptedFrom'               "$(get_formatted_message_minimessage success player $(get_player_mention ${PLACEHOLDER_ARG0}) accepted your teleportation request)" \
            'requestDenied'                     "$(get_formatted_message_minimessage error player Teleportation request denied)" \
            'requestDeniedFrom'                 "$(get_formatted_message_minimessage error player $(get_player_mention ${PLACEHOLDER_ARG0}) denied your teleportation request)" \
            'requestSent'                       "$(get_formatted_message_minimessage info player Teleportation request sent to $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'requestSentAlready'                "$(get_formatted_message_minimessage error player You have already sent a teleportatin request to $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'requestTimedOut'                   "$(get_formatted_message_minimessage error player The teleportation request has timed out)" \
            'requestTimedOutFrom'               "$(get_formatted_message_minimessage error player The teleportation request from $(get_player_mention ${PLACEHOLDER_ARG0}) ${COLOUR_MESSAGE}has timed out)" \
            'seenAccounts'                      "$(get_formatted_message_minimessage info inspect Associated with: $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'seenOffline'                       "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) has been ${COLOUR_RED_DARK}offline ${COLOUR_MESSAGE}for ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1})" \
            'seenOnline'                        "$(get_formatted_message_minimessage info inspect $(get_player_mention ${PLACEHOLDER_ARG0}) has been ${COLOUR_GREEN_LIGHT}online ${COLOUR_MESSAGE}for ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1})" \
            'serverTotal'                       "$(get_formatted_message_minimessage info money There are $(get_highlighted_message ${PLACEHOLDER_ARG0}) circulating in $(get_highlighted_message ${SERVER_NAME})\'s economy)" \
            'setBal'                            "$(get_formatted_message_minimessage success money Your bank account has been set to $(get_highlighted_message ${PLACEHOLDER_ARG1}))" \
            'setBalOthers'                      "$(get_formatted_message_minimessage success money $(get_player_mention ${PLACEHOLDER_ARG0})\'s bank account has been set to $(get_highlighted_message ${PLACEHOLDER_ARG1}))" \
            'sudoRun'                           "$(get_formatted_message_minimessage info command Forced $(get_player_mention ${PLACEHOLDER_ARG0}) to execute $(get_command_mention /${PLACEHOLDER_ARG1}))" \
            'takenFromAccount'                  "$(get_formatted_message_minimessage info money $(get_highlighted_message ${PLACEHOLDER_ARG0}) were taken from your bank account)" \
            'takenFromOthersAccount'            "$(get_formatted_message_minimessage info money $(get_highlighted_message ${PLACEHOLDER_ARG0}) were taken from $(get_player_mention ${PLACEHOLDER_ARG1})\'s bank account)" \
            'teleportationEnabled'              "$(get_formatted_message_minimessage info player The teleportation requests have been $(get_enablement_message enabled))" \
            'teleportationDisabled'             "$(get_formatted_message_minimessage info player The teleportation requests have been $(get_enablement_message disabled))" \
            'teleportBottom'                    "$(get_formatted_message_minimessage success teleport Teleported to the $(get_highlighted_message lowest) empty space at your current location)" \
            'teleportDisabled'                  "$(get_formatted_message_minimessage error player $(get_player_mention ${PLACEHOLDER_ARG0}) has $(get_enablement_message disabled) their teleportation requests)" \
            'teleportHereRequest'               "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) asked you to teleport to them)" \
            'teleporting'                       "$(get_formatted_message_minimessage success teleport Teleported successfully)" \
            'teleportRequestSpecificCancelled'  "$(get_formatted_message_minimessage info player Teleportation request with $(get_player_mention ${PLACEHOLDER_ARG0}) cancelled)" \
            'teleportRequestTimeoutInfo'        "$(get_formatted_message_minimessage info player This request will time out after $(get_highlighted_message ${PLACEHOLDER_ARG0} seconds))" \
            'teleportHome'                      "$(get_formatted_message_minimessage success home Teleported to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'teleportRequest'                   "$(get_formatted_message_minimessage info player $(get_player_mention ${PLACEHOLDER_ARG0}) asked you to let them teleport to you)" \
            'teleportTop'                       "$(get_formatted_message_minimessage success teleport Teleported to the $(get_highlighted_message highest) empty space at your current location)" \
            'teleportToPlayer'                  "$(get_formatted_message_minimessage success player Teleported to $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'timeBeforeTeleport'                "$(get_formatted_message_minimessage error teleport You need to wait $(get_highlighted_message ${PLACEHOLDER_ARG0}) before teleporting again)" \
            'timeWorldSet'                      "$(get_formatted_message_minimessage success time The time in $(get_highlighted_message ${PLACEHOLDER_ARG1}) is now $(get_highlighted_message ${PLACEHOLDER_ARG0}))" \
            'tprSuccess'                        "$(get_formatted_message_minimessage success teleport Teleported to a random location)" \
            'true'                              "$(convert_message_to_minimessage ${COLOUR_GREEN_LIGHT}yes${COLOUR_MESSAGE})" \
            'typeTpacancel'                     "$(get_formatted_message_minimessage info player To cancel it, use $(get_command_mention /tpacancel))" \
            'typeTpaccept'                      "$(get_formatted_message_minimessage info player To approve it, use $(get_command_mention /tpyes))" \
            'typeTpdeny'                        "$(get_formatted_message_minimessage info player To deny this request, use $(get_command_mention /tpno))" \
            'unsafeTeleportDestination'         "$(get_formatted_message_minimessage error teleport Homes cannot be set in unsafe locations)" \
            'userIsAwaySelf'                    "$(get_formatted_message_minimessage success player The AFK mode was $(get_enablement_message enabled))" \
            'vanish'                            "$(get_formatted_message_minimessage success gamemode Invisible mode ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1} ${COLOUR_MESSAGE}for $(get_player_mention ${PLACEHOLDER_ARG0}))" \
            'walking'                           "$(convert_message_to_minimessage $(get_highlighted_message walk))" \
            'warpingTo'                         "$(get_formatted_message_minimessage success warp Teleported to $(get_location_mention ${PLACEHOLDER_ARG0}))" \
            'warpNotExist'                      "$(get_formatted_message_minimessage error warp The specified warp is invalid)" \
            'warpsCount'                        "$(get_formatted_message_minimessage info warp There are ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} ${COLOUR_MESSAGE}warps. Page ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG1}${COLOUR_MESSAGE}/${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG2})" \
            'warpSet'                           "$(get_formatted_message_minimessage success warp Warp $(get_location_mention ${PLACEHOLDER_ARG0}) set at the current location)" \
            'warpUsePermission'                 "$(get_formatted_message_minimessage error warp The specified warp is invalid)" \
            'weatherStorm'                      "$(get_formatted_message_minimessage success weather The weather in $(get_highlighted_message ${PLACEHOLDER_ARG0}) is now $(get_highlighted_message stormy))" \
            'weatherStormFor'                   "$(get_formatted_message_minimessage success weather The weather in $(get_highlighted_message ${PLACEHOLDER_ARG0}) will be $(get_highlighted_message stormy) for $(get_highlighted_message ${PLACEHOLDER_ARG1} seconds))" \
            'weatherSun'                        "$(get_formatted_message_minimessage success weather The weather in $(get_highlighted_message ${PLACEHOLDER_ARG0}) is now $(get_highlighted_message sunny))" \
            'weatherSunFor'                     "$(get_formatted_message_minimessage success weather The weather in $(get_highlighted_message ${PLACEHOLDER_ARG0}) will be $(get_highlighted_message sunny) for $(get_highlighted_message ${PLACEHOLDER_ARG1} seconds))" \
            'whoisTop'                          "$(get_formatted_message_minimessage success inspect Informații despre $(get_player_mention ${PLACEHOLDER_ARG0}):)" \
            'whoisExp'                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Experience: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisFly'                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Flight: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisGamemode'                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Gamemode: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisGod'                          "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Invincibility: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisHealth'                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Health: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisHunger'                       "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Hunger: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisJail'                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Jailed: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisLocation'                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Location: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisMoney'                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Money: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisNick'                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Name: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisOp'                           "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Operator: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisPlaytime'                     "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Time spent in-game: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisSpeed'                        "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Speed: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            'whoisUuid'                         "$(convert_message_to_minimessage ${BULLETPOINT_LIST_MARKER}Identifier: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})"
    fi
fi

if is_plugin_installed 'GrimAC'; then
    configure_plugin 'GrimAC' messages \
        'prefix' '§r§e⌀§r§7'

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'GrimAC' messages \
            'alerts-disabled' "$(get_formatted_message info anticheat Notificările $(get_plugin_mention GrimAC) au fost $(get_enablement_message dezativate))" \
            'alerts-enabled' "$(get_formatted_message info anticheat Notificările $(get_plugin_mention GrimAC) au fost $(get_enablement_message activate))" \
            'client-brand-format' "$(get_formatted_message info anticheat Brand-ul clientului Minecraft al lui $(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT}) este $(get_highlighted_message ${PLACEHOLDER_BRAND_PERCENT}))" \
            'player-not-found' "$(get_formatted_message error anticheat Jucătorul specificat este scutit sau offline)"
    else
        configure_plugin 'GrimAC' messages \
            'alerts-disabled' "$(get_formatted_message info anticheat The $(get_plugin_mention GrimAC) notifications have been $(get_enablement_message disabled))" \
            'alerts-enabled' "$(get_formatted_message info anticheat The $(get_plugin_mention GrimAC) notifications have been $(get_enablement_message enabled))" \
            'client-brand-format' "$(get_formatted_message info anticheat $(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT})\'s Minecraft client brand is $(get_highlighted_message ${PLACEHOLDER_BRAND_PERCENT}))" \
            'player-not-found' "$(get_formatted_message error anticheat The specified player is exempt or offline)"
    fi
fi

if is_plugin_installed 'GSit'; then
    configure_plugin 'GSit' config 'Lang.client-lang' false

    configure_plugin 'GSit' "$(get_plugin_dir GSit)/lang/en_en.yml" \
        'Messages.command-permission-error' "${NO_PERMISSION_MINIMESSAGE}" \
        'Messages.command-sender-error' "${INVALID_COMMAND_MINIMESSAGE}" \
        'Plugin.plugin-disabled' "$(get_plugin_enablement_minimessage GSit disabled)" \
        'Plugin.plugin-enabled' "$(get_plugin_enablement_minimessage GSit enabled)" \
        'Plugin.plugin-linked' "$(get_plugin_linked_minimessage GSit WorldGuard)" \
        'Plugin.plugin-reload' "$(get_reload_message_minimessage GSit)"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'GSit' "$(get_plugin_dir GSit)/lang/en_en.yml" \
            'Messages.command-gsit-playertoggle-off' "$(get_formatted_message_minimessage info player Intracțiunile fizice cu ceilalți jucători au fost $(get_enablement_message dezactivate))" \
            'Messages.command-gsit-playertoggle-on'  "$(get_formatted_message_minimessage info player Intracțiunile fizice cu ceilalți jucători au fost $(get_enablement_message activate))"
    else
        configure_plugin 'GSit' "$(get_plugin_dir GSit)/lang/en_en.yml" \
            'Messages.command-gsit-playertoggle-off' "$(get_formatted_message_minimessage info player The physical interactions with other players have been $(get_enablement_message disabled))" \
            'Messages.command-gsit-playertoggle-on'  "$(get_formatted_message_minimessage info player The physical interactions with other players have been $(get_enablement_message enabled))"
    fi
fi

configure_plugin 'InteractionVisualizer' config \
    'Messages.NoPermission' "${NO_PERMISSION_MESSAGE}" \
    'Messages.Reload' "$(get_reload_message InteractionVisualizer)"

if is_plugin_installed 'InvUnload'; then
    INVUNLOAD_COOLDOWN=2
    configure_plugin 'InvUnload' config 'message-prefix' "${COLOUR_RESET}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'InvUnload' config \
            'message-cooldown' "$(get_formatted_message error inventory Așteaptă $(get_highlighted_message ${INVUNLOAD_COOLDOWN} secunde) de la ultima golire)" \
            'message-could-not-unload' "$(get_formatted_message error inventory Nu au fost găsite containere pentru restul obiectelor)" \
            'message-error-not-a-number' "$(get_formatted_message error inventory Distanța specificată nu este un număr valid)" \
            'message-inventory-empty' "$(get_formatted_message error inventory Inventarul tău este deja gol)" \
            'message-no-chests-nearby' "$(get_formatted_message error inventory Nu există containere de depozitare în apropriere)" \
            'message-radius-too-high' "$(get_formatted_message error inventory Distanța poate să fie maximum ${COLOUR_HIGHLIGHT}%d${COLOUR_MESSAGE} blocuri)"
    else
        configure_plugin "InvUnload" config \
            "message-cooldown" "$(get_formatted_message error inventory You must wait ${COLOUR_HIGHLIGHT}${INVUNLOAD_COOLDOWN} seconds${COLOUR_MESSAGE} since the last unload)" \
            "message-could-not-unload" "$(get_formatted_message error inventory There are no containers for the remaining items)" \
            "message-error-not-a-number" "$(get_formatted_message error inventory The specified distance is not a valid number)" \
            "message-inventory-empty" "$(get_formatted_message error inventory Your inventory is already empty)" \
            "message-no-chests-nearby" "$(get_formatted_message error inventory There are no storage containers nearby)" \
            "message-radius-too-high" "$(get_formatted_message error inventory The distance can be at most ${COLOUR_HIGHLIGHT}%d${COLOUR_MESSAGE} blocks)"
    fi
fi

if is_plugin_installed 'KauriVPN'; then
    configure_plugin 'KauriVPN' config \
        'messages.command-reload-complete' "$(get_reload_message KauriVPN)" \
        'messages.no-permission' "${NO_PERMISSION_MESSAGE}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'KauriVPN' config \
            'alerts.message'                    "$(get_formatted_message error network $(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT}) s-a conectat cu un VPN/Proxy \($(get_highlighted_message ${PLACEHOLDER_REASON_PERCENT})\) din $(get_highlighted_message ${PLACEHOLDER_COUNTRY_PERCENT}) \($(get_highlighted_message ${PLACEHOLDER_CITY_PERCENT})\))" \
            'kickMessage'                       'Conectarea prin Proxy este interzisă' \
            'messages.command-alerts-toggled'   "$(get_formatted_message info network Alertele tale pentru conectări prin VPN/Proxy sunt $(get_highlighted_message ${PLACEHOLDER_STATE_PERCENT}))"
    else
        configure_plugin 'KauriVPN' messages \
            'alerts.message'                    "$(get_formatted_message_legacy error network $(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT}) connected through a VPN/Proxy \($(get_highlighted_message ${PLACEHOLDER_REASON_PERCENT})\) from $(get_highlighted_message ${PLACEHOLDER_COUNTRY_PERCENT}) \($(get_highlighted_message ${PLACEHOLDER_CITY_PERCENT})\))" \
            'kickMessage'                       'Connecting through a Proxy is forbidden'
            'messages.command-alerts-toggled'   "$(get_formatted_message info network Your alerts for VPN/Proxy connections are now $(get_highlighted_message ${PLACEHOLDER_STATE_PERCENT}))"
    fi
fi

if is_plugin_installed 'KeepInventoryCost'; then
    configure_plugin 'KeepInventoryCost' config \
        'message.prefix' "${COLOUR_RESET_MINIMESSAGE}" \
        'message.reload' "$(get_reload_message_minimessage KeepInventoryCost)"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'KeepInventoryCost' config \
            'message.disabled' "$(get_enablement_message oprită)" \
            'message.enabled' "$(get_enablement_message pornită)" \
            'message.setting..get' "$(get_formatted_message info inventory Păstrarea inventarului la moarte e %s)" \
            'message.setting..set' "$(get_formatted_message success inventory Păstrarea inventarului la moarte a fost %s)" \
            'message.setting..set_refuse' "$(get_formatted_message error inventory Păstrarea inventarului la moarte e deja %s)" \
            'message.death..no_money' "$(get_formatted_message error_minimessage inventory Nu ai avut destui bani pentru a păstra inventarul)" \
            'message.death..paid' "$(get_formatted_message succes inventory Ai plătit $(get_coloured_message ${COLOUR_GREEN_LIGHT} %s) pentru a păstra inventarul)"
    else
        configure_plugin 'KeepInventoryCost' config \
            'message.disabled' "$(get_enablement_message disabled)" \
            'message.enabled' "$(get_enablement_message enabled)" \
            'message.setting..get' "$(get_formatted_message info inventory Keeping the inventory on death is %s)" \
            'message.setting..set' "$(get_formatted_message success inventory Keeping the inventory on death has been %s)" \
            'message.setting..set_refuse' "$(get_formatted_message error inventory Keeping the inventory on death is already %s)" \
            'message.death..no_money' "$(get_formatted_message error_minimessage inventory You didn\'t have enough money to keep your inventory)" \
            'message.death..paid' "$(get_formatted_message succes inventory You paid %s to keep your inventory)"
    fi
fi

if is_plugin_installed 'LuckPerms'; then
    if [ "${LOCALE}" = 'ro' ]; then
        copy_file_if_needed "${LUCKPERMS_DIR}/translations/repository/ro_RO.properties" "${LUCKPERMS_DIR}/translations/custom/en.properties"
        configure_plugin 'LuckPerms' "${LUCKPERMS_DIR}/translations/custom/en.properties" \
            'luckperms.command.generic.permission.info.title' "$(get_formatted_message info permission Permisiunile lui $(get_player_mention ${PLACEHOLDER_ARG0}))"
    fi
fi

if is_plugin_installed 'OldCombatMechanics'; then
    configure_plugin 'OldCombatMechanics' config 'message-prefix' "§"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'OldCombatMechanics' config \
            'disable-offhand.denied-message' "$(get_formatted_message error combat Modul de luptă actual nu permite obiecte în mâna stângă)" \
            'mode-messages.invalid-modeset' "$(get_formatted_message error combat Modul de luptă specificat nu este valid)" \
            'mode-messages.invalid-player' "$(get_formatted_message error combat Jucătorul specificat nu este valid)" \
            'mode-messages.message-usage' "$(get_formatted_message info combat Poți schimba modul de luptă cu $(get_command_mention /ocm mode ${COLOUR_COMMAND_ARGUMENT}'<Mod>' [Jucător]))" \
            'mode-messages.mode-set' "$(get_formatted_message error combat Modul de luptă a fost schimbat la ${COLOUR_HIGHLIGHT}%s)" \
            'mode-messages.mode-status' "$(get_formatted_message info combat Modul de luptă actual: ${COLOUR_HIGHLIGHT}%s)" \
            'old-golden-apples.message-enchanted' "$(get_formatted_message error combat Așteaptă $(get_highlighted_message ${PLACEHOLDER_SECONDS_PERCENT}) înainte să mănânci alt ${COLOUR_PINK}Măr Auriu Fermecat)" \
            'old-golden-apples.message-normal' "$(get_formatted_message error combat Așteaptă $(get_highlighted_message ${PLACEHOLDER_SECONDS_PERCENT}) înainte să mănânci alt ${COLOUR_AQUA}Măr Auriu)"
    else
        configure_plugin 'OldCombatMechanics' config \
            'disable-offhand.denied-message' "$(get_formatted_message error combat The current combat mode does not allow items in the off-hand slot)" \
            'mode-messages.invalid-modeset' "$(get_formatted_message error combat The specified combat mode is invalid)" \
            'mode-messages.invalid-player' "$(get_formatted_message error combat The specified player is invalid)" \
            'mode-messages.message-usage' "$(get_formatted_message info combat You can change your combat mode using ${COLOUR_COMMAND}/ocm mode ${COLOUR_COMMAND_ARGUMENT}'<Mode>' [Player])" \
            'mode-messages.mode-set' "$(get_formatted_message success combat Your combat mode has been set to ${COLOUR_HIGHLIGHT}%s)" \
            'mode-messages.mode-status' "$(get_formatted_message info combat Your current combat mode is ${COLOUR_HIGHLIGHT}%s)" \
            'old-golden-apples.message-enchanted' "$(get_formatted_message error combat You must wait ${COLOUR_HIGHLIGHT}%seconds% ${COLOUR_MESSAGE}before eating another ${COLOUR_PINK}Enchanted Golden Apple)" \
            'old-golden-apples.message-normal' "$(get_formatted_message error combat You must wait ${COLOUR_HIGHLIGHT}%seconds% ${COLOUR_MESSAGE}before eating another ${COLOUR_AQUA}Golden Apple)"
    fi
fi

if is_plugin_installed 'PaperTweaks'; then
    configure_plugin 'PaperTweaks' messages \
        'commands.reload.all.reloaded.success' "$(get_reload_message PaperTweaks)"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'PaperTweaks' messages \
            'commands.disable.success' "$(get_formatted_message success plugin Modulul $(get_highlighted_message ${PLACEHOLDER_ARG0}) a fost $(get_enablement_message dezactivat))" \
            'commands.enable.success' "$(get_formatted_message success plugin Modulul $(get_highlighted_message ${PLACEHOLDER_ARG0}) a fost $(get_enablement_message activat))"
    else
        configure_plugin 'PaperTweaks' messages \
            'commands.disable.success' "$(get_formatted_message success plugin $(get_enablement_message Disabled) the $(get_highlighted_message ${PLACEHOLDER_ARG0}) module)" \
            'commands.enable.success' "$(get_formatted_message success plugin $(get_enablement_message Enabled) the $(get_highlighted_message ${PLACEHOLDER_ARG0}) module)"
    fi
fi

if is_plugin_installed 'Pl3xmap'; then
    PLEXMAP_PLAYERS_LABEL="<online> Players"
    PLEXMAP_LOCALE="${LOCALE_FALLBACK}"

    if [ "${LOCALE}" = 'ro' ]; then
        PLEXMAP_PLAYERS_LABEL="<online> Jucători"
    fi
    if [ -f "${PLEXMAP_DIR}/locale/lang-${LOCALE}.yml" ]; then
        PLEXMAP_LOCALE="${LOCALE}"
    fi

    set_config_values "${PLEXMAP_DIR}/locale/lang-${PLEXMAP_LOCALE}.yml" \
        "ui.title"              "${WEBMAP_PAGE_TITLE}" \
        "ui.players.label"      "${PLEXMAP_PLAYERS_LABEL}" \
        "ui.blockinfo.value"    "${SERVER_NAME}<br />Powered by Raspberry Pi 4" \
        "ui.coords.value"       "<x>, <z>"
    set_config_value "${PLEXMAP_CONFIG_FILE}" "settings.language-file" "lang-${PLEXMAP_LOCALE}.yml"

    configure_plugin "Pl3xmap" "${PLEXMAP_CLAIMS_WORLDGUARD_CONFIG_FILE}" \
        "settings.claim.popup.flags" "Protected Region" \
        "settings.layer.label" "Regions"
fi

if is_plugin_installed 'ProAntiTab'; then
    configure_plugin 'ProAntiTab' config \
        'cancel-blocked-commands.enabled' true \
        'cancel-blocked-commands.message' "[\"${INVALID_COMMAND_MESSAGE}\"]" \
        'custom-server-brand.enabled' true \
        'custom-server-brand.brands' "[\"$(get_coloured_message ${COLOUR_SERVER} ${SERVER_NAME})\"]" \
        'custom-unknown-command.enabled' true \
        'custom-unknown-command.message' "[\"${INVALID_COMMAND_MESSAGE}\"]"
fi

configure_plugin 'RegionBossbar' config \
    'noPermission' "${NO_PERMISSION_MESSAGE}" \
    'reloadMessage' "$(get_reload_message RegionBossbar)"

if is_plugin_installed 'SkinsRestorer'; then
    if [ "${LOCALE}" = 'ro' ]; then
        copy_file_if_needed "${SKINSRESTORER_DIR}/locales/repository/locale_ro.json" "${SKINSRESTORER_DIR}/locales/custom/locale_ro.json"
        configure_plugin "SkinsRestorer" "${SKINSRESTORER_DIR}/locales/custom/locale.json" \
            "skinsrestorer..prefix_format" "$(convert_message_to_minimessage ${COLOUR_MESSAGE}${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_generic" "$(get_formatted_message_minimessage error skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_invalid_urlskin" "$(get_formatted_message_minimessage error skin URL-ul sau formatul skin-ului este invalid. Asigură-te că se termină cu ${COLOUR_HIGHLIGHT}.png${COLOUR_MESSAGE})" \
            "skinsrestorer..ms_uploading_skin" "$(get_formatted_message_minimessage info skin Se încarcă skin-ul...)" \
            "skinsrestorer..success_admin_reload" "$(get_reload_message_minimessage SkinsRestorer)" \
            "skinsrestorer..success_generic" "$(get_formatted_message_minimessage success skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..success_skin_change" "$(get_formatted_message_minimessage success skin Skin-ul tău a fost schimbat)" \
            "skinsrestorer..success_skin_change_other" "$(get_formatted_message_minimessage success skin Skin-ul lui $(get_player_mention ${PLACEHOLDER_NAME_POINTY}) a fost schimbat)" \
            "skinsrestorer..success_skin_clear" "$(get_formatted_message_minimessage success skin Skin-ul tău a fost scos)" \
            "skinsrestorer..success_updating_skin" "$(get_formatted_message_minimessage success skin Skin-ul tău a fost actualizat)" \
            "skinsrestorer..success_updating_skin_other" "$(get_formatted_message_minimessage success skin Skin-ul lui $(get_player_mention ${PLACEHOLDER_NAME_POINTY}) a fost actualizat)"
    else
        copy_file_if_needed "${SKINSRESTORER_DIR}/locales/repository/locale.json" "${SKINSRESTORER_DIR}/locales/custom/locale.json"
        configure_plugin "SkinsRestorer" "${SKINSRESTORER_DIR}/locales/custom/locale.json" \
            "skinsrestorer..prefix_format" "$(convert_message_to_minimessage ${COLOUR_MESSAGE}${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_generic" "$(get_formatted_message_minimessage error skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..error_invalid_urlskin" "$(get_formatted_message_minimessage error skin The skin\'s URL or format is invalid. Make sure it ends with ${COLOUR_HIGHLIGHT}.png${COLOUR_MESSAGE})" \
            "skinsrestorer..ms_uploading_skin" "$(get_formatted_message_minimessage info skin Uploading the skin...)" \
            "skinsrestorer..success_admin_reload" "$(get_reload_message_minimessage SkinsRestorer)" \
            "skinsrestorer..success_generic" "$(get_formatted_message_minimessage success skin ${PLACEHOLDER_MESSAGE_POINTY})" \
            "skinsrestorer..success_skin_change" "$(get_formatted_message_minimessage success skin Your skin has been changed)" \
            "skinsrestorer..success_skin_change_other" "$(get_formatted_message_minimessage success skin $(get_player_mention ${PLACEHOLDER_NAME_POINTY})\'s skin has been changed)" \
            "skinsrestorer..success_skin_clear" "$(get_formatted_message_minimessage success skin Your skin has been cleared)" \
            "skinsrestorer..success_updating_skin" "$(get_formatted_message_minimessage success skin Your skin has been updated)" \
            "skinsrestorer..success_updating_skin_other" "$(get_formatted_message_minimessage success skin $(get_player_mention ${PLACEHOLDER_NAME_POINTY})\'s skin has been updated)"
    fi
fi

configure_plugin 'Sonar' messages \
    'commands.no-permission' "${NO_PERMISSION_MINIMESSAGE}" \
    'commands.reload.finish' "$(get_reload_message_minimessage Sonar)" \
    'commands.reload.start' "$(get_reloading_message_minimessage Sonar)"

if is_plugin_installed 'SuperbVote'; then
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'SuperbVote' config \
            'vote-reminder.message' "$(get_formatted_message info vote ${COLOUR_GREEN_LIGHT}Memo: ${COLOUR_MESSAGE}Ia-ți recompensele zilnice votând $(get_highlighted_message ${SERVER_NAME}) cu $(get_command_mention /vot))"
    else
        configure_plugin 'SuperbVote' config \
            'vote-reminder.message' "$(get_formatted_message info vote ${COLOUR_GREEN_LIGHT}Reminder: ${COLOUR_MESSAGE}Claim your daily rewards by voting $(get_highlighted_message ${SERVER_NAME}) with $(get_command_mention /vote))"
    fi
fi

configure_plugin 'TAB' messages \
    'no-permission' "${NO_PERMISSION_MESSAGE}" \
    'reload-success' "$(get_reload_message TAB)"

if is_plugin_installed 'ToolStats'; then
    configure_plugin 'ToolStats' config \
        'date-format' 'dd/MM/yyyy' \
        'number-formats.comma-separator' '.' \
        'number-formats.decimal-separator' ','

    # Changing the messages breaks existing ones, so beware language switching
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'ToolStats' config \
            'messages.arrows-shot' "$(get_itemlore_message Trageri: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_ARROWS_BRACKETS})" \
            'messages.blocks-mined' "$(get_itemlore_message Blocuri sparte: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_BLOCKS_BRACKETS})" \
            'messages.created.created-by' "$(get_itemlore_message Făcut de $(get_player_mention ${PLACEHOLDER_PLAYER_BRACKETS}))" \
            'messages.created.created-on' "$(get_itemlore_message Făcut pe ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_DATE_BRACKETS})" \
            'messages.crops-harvested' "$(get_itemlore_message Recolte culese: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_CROPS_BRACKETS})" \
            'messages.damage-taken' "$(get_itemlore_message Daune primite: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_DAMAGE_BRACKETS})" \
            'messages.dropped-by' "$(get_itemlore_message Aruncat de $(get_player_mention ${PLACEHOLDER_PLAYER_BRACKETS}))" \
            'messages.fished.caught-by' "$(get_itemlore_message Pescuit de $(get_player_mention ${PLACEHOLDER_PLAYER_BRACKETS}))" \
            'messages.fished.caught-on' "$(get_itemlore_message Pescuit pe ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_DATE_BRACKETS})" \
            'messages.fished.fish-caught' "$(get_itemlore_message Pești prinși: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_FISH_BRACKETS})" \
            'messages.kills.mob' "$(get_itemlore_message Mobi uciși: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_KILLS_BRACKETS})" \
            'messages.kills.player' "$(get_itemlore_message Jucători uciși: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_KILLS_BRACKETS})" \
            'messages.looted.looted-by' "$(get_itemlore_message Prădat de $(get_player_mention ${PLACEHOLDER_PLAYER_BRACKETS}))" \
            'messages.looted.looted-on' "$(get_itemlore_message Prădat pe ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_DATE_BRACKETS})" \
            'messages.looted.found-by' "$(get_itemlore_message Găsit de $(get_player_mention ${PLACEHOLDER_PLAYER_BRACKETS}))" \
            'messages.looted.found-on' "$(get_itemlore_message Găsit pe ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_DATE_BRACKETS})" \
            'messages.sheep-sheared' "$(get_itemlore_message Oi tunse: ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_SHEEP_BRACKETS})" \
            'messages.shift-click-warning.crafting' "$(get_formatted_message warning craft Craftarea obiectelor cu shift-click poate să nu le aplice toate statisticile)" \
            'messages.shift-click-warning.trading' "$(get_formatted_message warning trade Cumpărarea obiectelor cu shift-click poate să nu le aplice toate statisticile)" \
            'messages.traded.created-by' "$(get_itemlore_message Cumpărat de $(get_player_mention ${PLACEHOLDER_PLAYER_BRACKETS}))" \
            'messages.traded.created-on' "$(get_itemlore_message Cumpărat pe ${COLOUR_ITEMLORE_INFO}${PLACEHOLDER_DATE_BRACKETS})"
    else
        configure_plugin 'ToolStats' config \
            'messages.shift-click-warning.crafting' "$(get_formatted_message warning craft Crafting items with shift-click might not fully apply statistics to them)" \
            'messages.shift-click-warning.trading' "$(get_formatted_message warning trade Buying items with shift-click might not fully apply statistics to them)"
    fi
fi

if is_plugin_installed 'TradeShop'; then
    configure_plugin 'TradeShop' config \
        "language-options.message-prefix" '§' \
        "language-options.shop-bad-colour" "${COLOUR_ERROR}" \
        "language-options.shop-good-colour" "${COLOUR_SUCCESS}" \
        "language-options.shop-incomplete-colour" "${COLOUR_ERROR}" \
        "global-options.allowed-shops" '["BARREL","CHEST","TRAPPED_CHEST","SHULKER"]'
#        "shop-sign-options.sign-default-colours.birch-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.cherry-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.crimson-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.oak-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.mangrove-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.spruce-sign" "${COLOUR_WHITE}" \
#        "shop-sign-options.sign-default-colours.warped-sign" "${COLOUR_WHITE}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'TradeShop' config \
            "language-options.shop-closed-status" "${COLOUR_ERROR}<Închis>" \
            "language-options.shop-incomplete-status" "${COLOUR_ERROR}<Invalid>" \
            "language-options.shop-open-status" "${COLOUR_SUCCESS}<Deschis>" \
            "language-options.shop-outofstock-status" "${COLOUR_ERROR}<Stoc Insuficient>"
            
        configure_plugin 'TradeShop' messages \
            "change-closed" "$(get_formatted_message success trade Oferta a fost $(get_enablement_message dezactivată))" \
            "change-open" "$(get_formatted_message success trade Oferta a fost $(get_enablement_message activată))" \
            "insufficient-items" "$(get_formatted_message error trade Îți lipsesc următoarele obiecte:\\n{%MISSINGITEMS%=  ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "item-added" "$(get_formatted_message success trade Obiectul a fost adăugat la ofertă)" \
            "item-not-removed" "$(get_formatted_message error trade Obiectul nu s-a putut scoate de la ofertă)" \
            "item-removed" "$(get_formatted_message success trade Obiectul a fost scos de la ofertă)" \
            "no-sighted-shop" "$(get_formatted_message error trade Nu s-a găsit nici o ofertă)" \
            "no-ts-create-permission" "$(get_formatted_message error trade Nu poți crea acest tip de ofertă)" \
            "no-ts-open" "$(get_formatted_message error trade Nu poți deschide această ofertă)" \
            "on-trade" "$(get_formatted_message success trade Ai cumpărat {%RECEIVEDLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%} ${COLOUR_MESSAGE}cu {%GIVENLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "player-full" "$(get_formatted_message error inventory Ai inventarul plin)" \
            "shop-closed" "$(get_formatted_message error trade Această ofertă nu este activă)" \
            "shop-empty" "$(get_formatted_message error inventory Oferta nu are stoc suficient)" \
            "shop-full" "$(get_formatted_message error inventory Oferta nu are spațiu suficient în inventar)" \
            "shop-insufficient-items" "$(get_formatted_message error inventory Oferta nu are stoc suficient)" \
            "successful-setup" "$(get_formatted_message success trade Oferta de vânzare a fost creată)"
    else
        configure_plugin "TradeShop" config \
            "language-options.shop-closed-status" "${COLOUR_ERROR}<Closed>" \
            "language-options.shop-incomplete-status" "${COLOUR_ERROR}<Invalid>" \
            "language-options.shop-open-status" "${COLOUR_SUCCESS}<Open>" \
            "language-options.shop-outofstock-status" "${COLOUR_ERROR}<Out of Stock>"

        configure_plugin "TradeShop" messages \
            "change-closed" "$(get_formatted_message success trade The offer was $(get_enablement_message disabled))" \
            "change-open" "$(get_formatted_message success trade The offer was $(get_enablement_message enabled))" \
            "insufficient-items" "$(get_formatted_message error trade You are missing the following items:\\n{%MISSINGITEMS%=  ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "item-added" "$(get_formatted_message success trade The item was added to the offer)" \
            "item-not-removed" "$(get_formatted_message error trade The item could not be removed from the offer)" \
            "item-removed" "$(get_formatted_message success trade The item was removed from the offer)" \
            "no-sighted-shop" "$(get_formatted_message error trade Could not find any offer in range)" \
            "no-ts-create-permission" "$(get_formatted_message error You can\'t create this type of offer)" \
            "no-ts-open" "$(get_formatted_message error trade You can\'t open this type of offer)" \
            "on-trade" "$(get_formatted_message info trade You bought:\\n{%RECEIVEDLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%}\n${COLOUR_MESSAGE}for:\n{%GIVENLINES%= ${COLOUR_HIGHLIGHT}%AMOUNT% %ITEM%})" \
            "player-full" "$(get_formatted_message error inventory Your inventory is full)" \
            "shop-closed" "$(get_formatted_message error trade This offer is not active)" \
            "shop-empty" "$(get_formatted_message error inventory This offer is out of stock)" \
            "shop-full" "$(get_formatted_message error inventory The offer\'s inventory is full)" \
            "shop-insufficient-items" "$(get_formatted_message error inventory This offer is out of stock)" \
            "successful-setup" "$(get_formatted_message success trade The trade offer was set up)"
    fi
fi

if is_plugin_installed 'TreeAssist'; then
    configure_plugin 'TreeAssist' messages 'info.plugin_prefix' "${COLOUR_RESET}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'TreeAssist' messages \
            'successful.noreplant' "$(get_formatted_message success woodcutting Replantarea automată a pomilor $(get_enablement_message oprită) pentru $(get_highlighted_message ${PLACEHOLDER_ARG1_PERCENT} secunde))" \
            'successful.replant' "$(get_formatted_message success woodcutting Replantarea automată a pomilor $(get_enablement_message pornită) pentru $(get_highlighted_message ${PLACEHOLDER_ARG1_PERCENT} secunde))" \
            'warning.destruction_invalidblock' "$(get_formatted_message error woodcutting Acest copac nu se poate tăia automat)"
    else
        configure_plugin 'TreeAssist' messages \
            'successful.noreplant' "$(get_formatted_message success woodcutting Automatic replanting of saplings $(get_enablement_message disabled) for $(get_highlighted_message ${PLACEHOLDER_ARG1_PERCENT} seconds))" \
            'successful.replant' "$(get_formatted_message success woodcutting Automatic replanting of saplings $(get_enablement_message enabled) for $(get_highlighted_message ${PLACEHOLDER_ARG1_PERCENT} seconds))" \
            'warning.destruction_invalidblock' "$(get_formatted_message error woodcutting This tree cannot be automatically chopped)"
    fi
fi

configure_plugin 'VanillaMessagesFormatter' config \
    'formats.error.prefix' "<${COLOUR_ERROR_HEX}>$(get_symbol_by_category error error)</${COLOUR_ERROR_HEX}> " \
    'formats.error.primaryColor' "${COLOUR_MESSAGE_HEX}" \
    'formats.error.secondaryColor' "${COLOUR_HIGHLIGHT_HEX}" \
    'formats.error.suffix' '.' \
    'formats.success.prefix' "<${COLOUR_SUCCESS_HEX}>$(get_symbol_by_category success success)</${COLOUR_SUCCESS_HEX}> " \
    'formats.success.primaryColor' "${COLOUR_MESSAGE_HEX}" \
    'formats.success.secondaryColor' "${COLOUR_HIGHLIGHT_HEX}" \
    'formats.success.suffix' '.' \
    'formats.success_player.prefix' "<${COLOUR_SUCCESS_HEX}>$(get_symbol_by_category success gamemode)</${COLOUR_SUCCESS_HEX}> " \
    'formats.success_player.primaryColor' "${COLOUR_MESSAGE_HEX}" \
    'formats.success_player.secondaryColor' "${COLOUR_PLAYER_HEX}" \
    'formats.success_player.suffix' '.' \
    'mappings.commands\.deop\.success' 'success_player'
    
if is_plugin_installed 'VotingPlugin'; then
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'VotingPlugin' config \
            'Format.BroadcastMsg'  "$(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT}) ${COLOUR_ACTION}a fost recompensat pentru votul pe ${COLOUR_HIGHLIGHT}%SiteName%${COLOUR_ACTION}." \
            'VoteReminding.Rewards.Messages.Player'  "${COLOUR_MESSAGE}Încă mai ai ${COLOUR_HIGHLIGHT}%sitesavailable% site-uri ${COLOUR_MESSAGE}pe care să votezi."
    else
        configure_plugin 'VotingPlugin' config \
            'Format.BroadcastMsg'  "$(get_player_mention ${PLACEHOLDER_PLAYER_PERCENT}) ${COLOUR_ACTION}was rewarded for voting on ${COLOUR_HIGHLIGHT}%SiteName%${COLOUR_ACTION}." \
            'VoteReminding.Rewards.Messages.Player'  "${COLOUR_MESSAGE}You have ${COLOUR_HIGHLIGHT}%sitesavailable% sites ${COLOUR_MESSAGE}left to vote on."
    fi
fi

if is_plugin_installed 'WanderingTrades'; then
    configure_plugin 'WanderingTrades' config \
    	'language' "${LOCALE_FULL}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'WanderingTrades' "$(get_plugin_dir WanderingTrades)/lang/ro_RO.yml" \
            'command.reload.message' "$(get_formatted_message_minimessage info plugin Se reîncarcă ${COLOUR_PLUGIN}WanderingTrades${COLOUR_MESSAGE}...)"
    else
        configure_plugin 'WanderingTrades' "$(get_plugin_dir WanderingTrades)/lang/en_US.yml" \
            'command.reload.message' "$(get_formatted_message_minimessage info plugin Reloading ${COLOUR_PLUGIN}WanderingTrades${COLOUR_MESSAGE}...)"
    fi
fi

if is_plugin_installed 'FastAsyncWorldEdit'; then
    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin "FastAsyncWorldEdit" messages \
            "prefix"                                                "${COLOUR_MESSAGE}${PLACEHOLDER_ARG0}" \
            "fawe..error.no-perm"                                   "${INVALID_COMMAND_MESSAGE}" \
            "fawe..worldedit..copy..command..copy"                  "$(get_formatted_message success worldedit Au fost copiate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            'worldedit..command..time-elapsed'                      "$(get_formatted_message info worldedit Au trecut $(get_highlighted_message ${PLACEHOLDER_ARG0} secunde) modificând $(get_highlighted_message ${PLACEHOLDER_ARG1} blocuri), cu viteza de $(get_highlighted_message ${PLACEHOLDER_ARG2} blocuri/s))" \
            "worldedit..contract..contracted"                       "$(get_formatted_message success worldedit Selecția a fost scurtată cu ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..count..counted"                             "$(get_formatted_message success worldedit Au fost numărate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..error..incomplete-region"                   "$(get_formatted_message error worldedit Nu s-a făcut nici o selecție)" \
            "worldedit..expand..expanded"                           "$(get_formatted_message success worldedit Selecția a fost extinsă cu ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..expand..expanded..vert"                     "$(get_formatted_message success worldedit Selecția a fost extinsă cu ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..line..changed"                              "$(get_formatted_message success worldedit Au fost schimbate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..move..moved"                                "$(get_formatted_message success worldedit Au fost mutate $(get_highlighted_message ${PLACEHOLDER_ARG0} blocuri))" \
            "worldedit..pos..already-set"                           "$(get_formatted_message error worldedit Poziția a fost deja setată)" \
            "worldedit..redo..none"                                 "$(get_formatted_message error worldedit Nu există modificări de refăcut)" \
            "worldedit..redo..redone"                               "$(get_formatted_message success worldedit S-au refăcut ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} modificări)" \
            "worldedit..reload..config"                             "$(get_reload_message FastAsyncWorldEdit)" \
            'worldedit..replace..replaced'                          "$(get_formatted_message success worldedit Au fost înlocuite $(get_highlighted_message ${PLACEHOLDER_ARG0} blocuri))" \
            "worldedit..select..cleared"                            "$(get_formatted_message success worldedit Selecția a fost ștearsă)" \
            "worldedit..selection..cuboid..explain..primary"        "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 1 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..primary-area"   "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 1 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary"      "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 2 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary-area" "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Poziția 2 ${COLOUR_MESSAGE}a fost setată la ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..set..done"                                  "$(get_formatted_message success worldedit Au fost schimbate ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocuri)" \
            "worldedit..shift..shifted"                             "$(get_formatted_message success worldedit Selecția a fost mutată)" \
            "worldedit..size..blocks"                               "$(get_formatted_message info worldedit Blocuri: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..distance"                             "$(get_formatted_message info worldedit Distanță: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..size"                                 "$(get_formatted_message info worldedit Dimensiune: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..type"                                 "$(get_formatted_message info worldedit Tip: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..undo..none"                                 "$(get_formatted_message error worldedit Nu există modificări de anulat)" \
            "worldedit..undo..undone"                               "$(get_formatted_message success worldedit S-au anulat ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} modificări)" \
            "worldedit..wand..selwand..info"                        "$(get_formatted_message info worldedit ${COLOUR_COMMAND}Click Stânga ${COLOUR_MESSAGE}alege ${COLOUR_HIGHLIGHT}Poziția 1${COLOUR_MESSAGE}, ${COLOUR_COMMAND}Click Dreapta ${COLOUR_MESSAGE}alege ${COLOUR_HIGHLIGHT}Poziția 2)"
    else
        configure_plugin "FastAsyncWorldEdit" messages \
            "prefix"                                                "${COLOUR_MESSAGE}${PLACEHOLDER_ARG0}" \
            "fawe..error.no-perm"                                   "${INVALID_COMMAND_MESSAGE}" \
            "fawe..worldedit..copy..command..copy"                  "$(get_formatted_message success worldedit Copied ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            'worldedit..command..time-elapsed'                      "$(get_formatted_message info worldedit $(get_highlighted_message ${PLACEHOLDER_ARG0} seconds) elapsed changing $(get_highlighted_message ${PLACEHOLDER_ARG1} blocks), at $(get_highlighted_message ${PLACEHOLDER_ARG2} blocks/s))" \
            "worldedit..contract..contracted"                       "$(get_formatted_message success worldedit The selection was shrunk by ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..count..counted"                             "$(get_formatted_message success worldedit Counted ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..error..incomplete-region"                   "$(get_formatted_message error worldedit No selection has been made)" \
            "worldedit..expand..expanded"                           "$(get_formatted_message success worldedit The selection was expanded by ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..expand..expanded..vert"                     "$(get_formatted_message success worldedit The selection was expanded by ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..line..changed"                              "$(get_formatted_message success worldedit Changed ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..move..moved"                                "$(get_formatted_message success worldedit Moved ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..pos..already-set"                           "$(get_formatted_message error worldedit Position already set)" \
            "worldedit..redo..none"                                 "$(get_formatted_message error worldedit Nothing to redo)" \
            "worldedit..redo..redone"                               "$(get_formatted_message success worldedit Redid ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} edits)" \
            "worldedit..reload..config"                             "$(get_reload_message FastAsyncWorldEdit)" \
            'worldedit..replace..replaced'                          "$(get_formatted_message success worldedit Replaced $(get_highlighted_message ${PLACEHOLDER_ARG0} blocks))" \
            "worldedit..select..cleared"                            "$(get_formatted_message success worldedit The selection was cleared)" \
            "worldedit..selection..cuboid..explain..primary"        "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 1 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..primary-area"   "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 1 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary"      "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 2 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..selection..cuboid..explain..secondary-area" "$(get_formatted_message success worldedit ${COLOUR_HIGHLIGHT}Position 2 ${COLOUR_MESSAGE}set to ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..set..done"                                  "$(get_formatted_message success worldedit Set ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} blocks)" \
            "worldedit..shift..shifted"                             "$(get_formatted_message success worldedit The selection was shifted)" \
            "worldedit..size..blocks"                               "$(get_formatted_message info worldedit Blocks: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..distance"                             "$(get_formatted_message info worldedit Distance: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..size"                                 "$(get_formatted_message info worldedit Size: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..size..type"                                 "$(get_formatted_message info worldedit Type: ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0})" \
            "worldedit..undo..none"                                 "$(get_formatted_message error worldedit Nothing to undo)" \
            "worldedit..undo..undone"                               "$(get_formatted_message success worldedit Undid ${COLOUR_HIGHLIGHT}${PLACEHOLDER_ARG0} edits)" \
            "worldedit..wand..selwand..info"                        "$(get_formatted_message info worldedit ${COLOUR_COMMAND}Left Click ${COLOUR_MESSAGE}sets ${COLOUR_HIGHLIGHT}Position 1${COLOUR_MESSAGE}, ${COLOUR_COMMAND}Right Click ${COLOUR_MESSAGE} sets ${COLOUR_HIGHLIGHT}Position 2)"
    fi
fi

if is_plugin_installed 'WorldEditSUI'; then
    configure_plugin 'WorldEditSUI' messages \
        'noPermission'  "${NO_PERMISSION_MESSAGE}" \
        'prefix'        "${COLOUR_RESET}" \
        'reload'        "$(get_reload_message WorldEditSUI)" \
        'WGNotEnabled'  "${INVALID_COMMAND_MESSAGE}"

    if [ "${LOCALE}" = 'ro' ]; then
        configure_plugin 'WorldEditSUI' messages \
            'particlesHidden' "$(get_formatted_message info worldedit Cadrul de selecție a fost $(get_enablement_message dezactivate))" \
            'particlesShown' "$(get_formatted_message info worldedit Cadrul de selecție a fost $(get_enablement_message activate))"
    else
        configure_plugin 'WorldEditSUI' messages \
            'particlesHidden' "$(get_formatted_message info worldedit The selection box was $(get_enablement_message disabled))" \
            'particlesShown' "$(get_formatted_message info worldedit The selection box was $(get_enablement_message enabled))"
    fi
fi
