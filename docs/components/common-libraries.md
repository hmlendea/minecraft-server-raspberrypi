# Common libraries

**Directory:** `scripts/common/`.

Sourced-only Bash libraries. They export variables and define functions; they are never executed as scripts. Every operational script sources `paths.sh` first.

## `paths.sh`

The dependency root. Exports all directories and files the toolkit uses. Sources nothing.

**Directories:** `SERVER_ROOT_DIR`, `SERVER_CACHE_DIR`, `SERVER_LOGS_DIR`, `SERVER_PLUGINS_DIR`, `SERVER_PLUGINS_TEMP_DIR`, `SERVER_SCRIPTS_DIR`, `SERVER_SCRIPTS_COMMON_DIR`, `SERVER_CONTROLLER`.

**Server config files:** `SERVER_OPS_FILE`, `SERVER_PROPERTIES_FILE`, `SERVER_USERCACHE_FILE`, `SERVER_WHITELIST_FILE`, `BUKKIT_CONFIG_FILE`, `PAPER_GLOBAL_CONFIG_FILE`, `PAPER_WORLD_DEFAULT_CONFIG_FILE`, `PAPER_WORLD_CONFIG_FILE`, `PAPER_WORLD_END_CONFIG_FILE`, `PAPER_WORLD_NETHER_CONFIG_FILE`, `PUFFERFISH_CONFIG_FILE`, `PURPUR_CONFIG_FILE`, `SPIGOT_CONFIG_FILE`.

**World:** `WORLD_DIR`, `WORLD_ADVANCEMENTS_DIR`, `WORLD_PLAYERDATA_DIR`, `WORLD_STATS_DIR`, `WORLD_END_DIR`, `WORLD_END_PLAYERDATA_DIR`, `WORLD_NETHER_DIR`, `WORLD_NETHER_PLAYERDATA_DIR`, `SERVER_DATAPACKS_DIR`.

**Webmap:** `WEBMAP_DIR`, `WEBMAP_SKINS_DIR`, `WEBMAP_SKINS_2D_UUID_DIR`, `WEBMAP_SKINS_2D_USERNAME_DIR`, `WEBMAP_TILES_DIR`, `WEBMAP_ICON_FILE`, `WEBMAP_INDEX_FILE`.

**Resources:** `PASSWORDS_DICTIONARY_FILE`, `PLAYERS_CACHE_FILE`, `SERVER_IMAGE_FILE`, `CURRENT_LOG_FILE`.

**Plugin directories:** `DISCORDSRV_DIR`, `ESSENTIALS_DIR`, `ESSENTIALS_USERDATA_DIR`, `LUCKPERMS_DIR`, `MINIMOTD_DIR`, `PAPERTWEAKS_DIR`, `PAPERTWEAKS_MODULES_DIR`, `PLEXMAP_DIR`, `PLEXMAP_CLAIMS_DIR`, `SKINSRESTORER_DIR`, `SKINSRESTORER_CACHE_DIR`, `TRADESHOP_DIR`, `TRADESHOP_DATA_DIR`, `TRADESHOP_PLAYER_DATA_DIR`, `WORLDGUARD_DIR`.

**Plugin files:** `DISCORDSRV_ACCOUNTS_FILE`, `PAPERTWEAKS_MODULES_FILE`, `PLEXMAP_CONFIG_FILE`, `PLEXMAP_CONFIG_COLOURS_FILE`, `PLEXMAP_CLAIMS_WORLDGUARD_CONFIG_FILE`, `WORLDGUARD_WORLD_REGIONS_FILE`, `WORLDGUARD_WORLD_REGIONS_TEMPORARY_FILE`.

> Ordering note: `PAPER_WORLD_CONFIG_FILE` and `WORLDGUARD_WORLD_REGIONS_FILE` reference `WORLD_DIR`/`WORLD_NAME`. `WORLD_DIR` is defined later in the same file, so these evaluate correctly because expansion is lazy (the path is only dereferenced when used). `WORLD_NAME` is supplied by `specs.sh`.

## `specs.sh`

Sources `paths.sh`, `config.sh`, `plugins.sh`. Computes and exports the specification vocabulary: `MINECRAFT_VERSION`, `ONLINE_MODE`, `WORLD_NAME`, `SERVER_NAME`, `SERVER_HOSTNAME`, `CURRENCY_SYMBOL`, feature flags (`CHECK_PLUGINS_FOR_UPDATES=false`, `SKIP_PLUGIN_UPDATE_CHECKS=true`, `AUTO_UPDATE_PLUGINS=false`, `USE_TELEMETRY=false`, `DISABLE_TELEMETRY=true`), distance/spawn/timing constants, locale (`LOCALE='ro'`, `LOCALE_FALLBACK='en'`, `LOCALE_FULL`), and CPU thread counts. See [configuration.md](../configuration.md).

## `config.sh`

Format-aware configuration writers and readers. Sources `paths.sh` (if unset) and `utils.sh`. Validates that `jq`, `xmlstarlet`, and `yq` exist. See [components/configuration-writers.md](./configuration-writers.md).

## `plugins.sh`

Plugin/datapack detection, configuration dispatch, download, and update routing. Sources `config.sh`, `github.sh`, `modrinth.sh`, `status.sh`, `jenkins.sh`, `web.sh`. See [components/plugin-management.md](./plugin-management.md).

## `github.sh` / `modrinth.sh` / `jenkins.sh`

Provider adapters. See [components/provider-adapters.md](./provider-adapters.md).

## `web.sh`

`download_file <url> <path>` — no-ops if the path exists; downloads with `wget --quiet`; chowns to `minecraft:minecraft`; removes zero-byte results; prints a confirmation line.

## `utils.sh`

| Function | Role |
|----------|------|
| `run_with_privileges` | Runs directly when EUID 0 or user `minecraft`; otherwise `sudo`. |
| `convert_ticks_to_seconds`, `convert_seconds_to_ticks`, `convert_ticks_to_duration` | Tick/time conversions (20 ticks = 1 s). |
| `run_server_command` | Echoes the command, checks `IS_SERVER_RUNNING`, and delegates to the controller. |
| `send_broadcast_message` | `run_server_command broadcast`. |
| `is_guid` | UUID format check. |
| `function_exists` | Checks a function's presence (always returns 0 before inspection). |
| `string_is_null_or_whitespace` | Emptiness check ignoring spaces. |
| `find_in_logs` | Searches compressed and plain logs. |
| `move_file`, `copy_file`, `copy_file_if_needed` | Guarded file operations (refuse overwrite, chown). |
| `create_file` | Creates parent directories and an empty file. |
| `ensure_su_access`, `ensure_bin_is_installed` | Privilege/utility checks. |

## `status.sh`

Computes `IS_SERVER_RUNNING` by scanning `ps aux` for a `java` process matching `bukkit|paper|purpur|spigot`. This is the canonical liveness signal used across the toolkit, distinct from the controller's tmux session check.

## `players.sh`

Player identity, cache, and reporting. See [components/player-data.md](./player-data.md).

## `messages.sh`, `colours.sh`

Message construction and colour vocabulary. See [components/messaging-and-localisation.md](./messaging-and-localisation.md).

## `worldguard.sh`

WorldGuard region settings and generated messages. See [components/worldguard-regions.md](./worldguard-regions.md).

## `rand.sh`

`get_random_boolean <percent>` and `get_random_element <args…>`. Small, dependency-free helpers.

## Related documentation

- [architecture.md](../architecture.md) for dependency rules.
- [dependencies.md](../dependencies.md) for the external utilities.
