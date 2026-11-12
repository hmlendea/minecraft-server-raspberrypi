# Player data

**File:** `scripts/common/players.sh`; consumers `scripts/get-player.sh`, `scripts/get-players.sh`, `scripts/change-player-username.sh`.

## Purpose

Resolve player identity and attributes from multiple authoritative and derived sources, cache slow lookups, and format player reports.

## Cache

`PLAYERS_CACHE_FILE` (`cache/players.json`) is a UUID-keyed JSON document. It is created (`{}`) on demand and loaded once per process into `LOADED_PLAYERS_CACHE_JSON`.

- `get_playerscache_value <uuid> <prop>` — read (returns empty for `null`).
- `set_playerscache_value <uuid> <prop> <val>` — write.

Consumers write back resolved values so later runs are cheap. The cache is not invalidated automatically.

## Identity resolution

`get_player_uuid <username>` — first hit wins:

1. Player cache (`.value.username`).
2. `usercache.json` (`.name` → `.uuid`).
3. `whitelist.json`.
4. `ops.json`.
5. Deterministic offline UUID: MD5 of `OfflinePlayer:<username>`, version/variant bits set, hyphenated to 8-4-4-4-12.

`get_player_username <uuid>` — first non-empty of:

1. Cache (`username`).
2. Essentials `last-account-name` (from `<uuid>.yml`).
3. `usercache.json`.
4. `whitelist.json`.
5. `ops.json`.
6. Playerdata `lastKnownName` (via `nbted`).

## Attributes

| Function | Source chain | Cache key |
|----------|--------------|-----------|
| `get_player_ip` | Essentials `ip-address` | — |
| `get_player_discord_id` | cache → `DiscordSRV/accounts.aof` → `linkedaccounts.json` | `discordId` |
| `get_player_date_seen_first` | cache → playerdata `firstPlayed` → AuthMe log `registered` | `joinTimestamp` |
| `get_player_date_seen_last` | playerdata `lastPlayed` | — |
| `get_player_location` | playerdata `Pos` (`nbted`) | — |
| `get_player_spawn` | playerdata `SpawnX/Y/Z` (`nbted`) | — |
| `get_player_password` | cache → logs (`/auth`, `/l`, `/log`, `/login`) | `password` |
| `get_player_playtime` | `stats/<uuid>.json` | — |
| `get_player_wealth` | Essentials `money` | — |

Timestamps stored in milliseconds are divided by 1000 before formatting. Locations and spawns require `nbted` and return empty when it is absent.

## Reporting

`get_player_info <uuid>` prints a formatted block (username, UUID, Discord ID, first/last seen, playtime, IP, location, spawn, wealth, and password when present). `get_players_uuids`, `get_players_usernames`, and `get_players_usernames_that_own_regions` enumerate players from `playerdata/*.dat`.

## Sensitivity

Username, IP, password, Discord ID, and location are personal data. They are printed on demand for operators and may appear in logs. See [security.md](../security.md) and [logging.md](../logging.md).

## Related documentation

- [data-model.md](../data-model.md)
- [flows/username-migration.md](../flows/username-migration.md)
- [behaviour/player-management.md](../behaviour/player-management.md)
