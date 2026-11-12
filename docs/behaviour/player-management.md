# Behaviour: player management

## Query

`scripts/get-player.sh <name|uuid>` resolves a UUID (via `get_player_uuid` when the argument is not a GUID) and prints a formatted report. `scripts/get-players.sh` iterates every UUID in `playerdata/`.

## Trade history

`scripts/get-player-trades.sh <name>` parses `plugins/ChestShop/ChestShop.log`:

- Filters lines containing ` <player> bought|sold`.
- Normalises timestamps (drops seconds), strips `.00` amounts, excludes self-dealing.
- Aggregates duplicates with `uniq -c`, shows the last 17 entries.
- Emits either colourised chat output (when run as a game command) or shell output.

## Identity durability

Identity resolution favours authoritative server files (`usercache.json`, `whitelist.json`, `ops.json`) over derived sources, and falls back to offline UUID derivation. Resolved usernames are cached to `cache/players.json`.

## Migration

Username/UUID changes are performed by `change-player-username.sh`, which fails closed and rewrites references across plugins. See [flows/username-migration.md](../flows/username-migration.md).

## Sensitive output

Reports may include IP addresses and cached passwords. Treat output as sensitive.

## Related documentation

- [components/player-data.md](../components/player-data.md)
- [security.md](../security.md)
