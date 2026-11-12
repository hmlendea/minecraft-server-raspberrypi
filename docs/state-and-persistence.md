# State and persistence

## Stores

| Store | Owner | Path variable | Lifecycle |
|-------|-------|---------------|-----------|
| Server properties | Runtime, mutated by scripts | `SERVER_PROPERTIES_FILE` | Persisted; excluded from version control. |
| Server YAML config | Runtime, mutated by scripts | `BUKKIT_CONFIG_FILE`, `SPIGOT_CONFIG_FILE`, `PURPUR_CONFIG_FILE`, `PUFFERFISH_CONFIG_FILE`, `PAPER_*` | Version-controlled defaults, mutated in place. |
| Plugin configuration | Plugins | `plugins/<name>/…` | Mutated then reloaded. |
| World state | JVM | `WORLD_DIR`, `WORLD_NETHER_DIR`, `WORLD_END_DIR` | JVM-owned. |
| Player data | JVM + plugins | `WORLD_PLAYERDATA_DIR`, `WORLD_STATS_DIR`, `WORLD_ADVANCEMENTS_DIR` | Keyed by UUID. |
| Player cache | Toolkit | `PLAYERS_CACHE_FILE` (`cache/players.json`) | Derived; rebuilt on demand. |
| Passwords dictionary | Toolkit | `PASSWORDS_DICTIONARY_FILE` (`cache/passwords.lst`) | Referenced path. |
| Webmap | Pl3xMap/Dynmap plugins | `WEBMAP_DIR` | Generated; ignored by Git. |
| Command buffer | Controller | `/tmp/minecraft_${SESSION_NAME}_command_dump.txt` | File during startup, FIFO afterwards; removed on stop. |
| Backups | Controller | `/var/backups/minecraft/<session>/` | Timestamped `tar.gz`, last six retained. |

## Derived cache

`cache/players.json` is a keyed-by-UUID JSON document populated lazily by `get_player_*` functions. Each function that resolves a value from a slower source (playerdata via `nbted`, logs, AuthMe, Discord) writes the result back through `set_playerscache_value`. The cache is:

- **Derived, not authoritative:** it can always be rebuilt.
- **Not automatically invalidated:** a stale entry wins over a fresh source. `change-player-username.sh` does not clear or rewrite cache entries (see [ambiguities-and-open-questions.md](./ambiguities-and-open-questions.md)).
- **Created on demand:** `players.sh` creates `{}` if the file is absent.

`get_playerscache_value` loads the file once per process into `LOADED_PLAYERS_CACHE_JSON` and queries it with `jq`, avoiding repeated reads.

## Backups

The `server backup` action archives a fixed, filtered set of paths (only those that exist):

```
data plugins world world_nether world_the_end server.properties
cache/players.json banned-players.json whitelist.json
```

- Naming: `%Y_%m_%d_%H.%M.%S.tar.gz`.
- Consistency: when the server is running, `save-off` then `save-all` precede the archive, and `save-on` follows; `sync && wait` flushes buffers. When stopped, the archive is taken directly.
- Retention: `ls -tp | tail -n +7` deletes all but the six most recent archives.

## Reset of End regions

`scripts/reset-end.sh` moves selected End region files (`r.X.Y.mca`) into a timestamped backup sub-directory inside `world_the_end/DIM1/` before removal. The region coordinates are hard-coded (End cities and strongholds). Note the historical `REGION_X`/`REGION_Y` sign-handling bug recorded in [ambiguities-and-open-questions.md](./ambiguities-and-open-questions.md).

## Migrations

Player username/UUID migration is the only data migration in the toolkit; it is described in [flows/username-migration.md](./flows/username-migration.md). It moves files and rewrites UUID references and fails closed if any target already exists.

## Related documentation

- [data-model.md](./data-model.md)
- [components/player-data.md](./components/player-data.md)
