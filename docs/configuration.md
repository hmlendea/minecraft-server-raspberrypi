# Configuration

## Principle

Configuration is **declarative and mutated in place**. Human-maintained files under version control (or host-local files such as `server.properties`) are read, edited at a dotted key path, and written back by a format-aware setter. No templates, includes, or generated copies are used. Correctness depends on the dotted key path matching the target file's schema.

## Configuration sources

| Area | Source | Behaviour |
|------|--------|-----------|
| Specification constants | `scripts/common/specs.sh` | Computed and exported at load; derived from hardware and `server.properties`. |
| Server runtime settings | `server.properties` | Not version controlled; mutated by `configure-settings.sh`; read at load for `online-mode` and `level-name`. |
| Bukkit/Spigot/Purpur | `bukkit.yml`, `spigot.yml`, `purpur.yml` | Version-controlled defaults; mutated in place. |
| Paper global/defaults | `config/paper-global.yml`, `config/paper-world-defaults.yml` | Version-controlled; mutated in place. |
| Paper per-world | `<world>/paper-world.yml` | Mutated per world (overworld, nether, end). |
| Pufferfish | `pufferfish.yml` | Mutated in place. |
| Plugin configuration | `plugins/<name>/…` | Located by `get_plugin_file`; mutated then reloaded via a plugin command. |
| Locale | `LOCALE` in `specs.sh` (`ro` default, `en` fallback) | Selects a message branch in `configure-localisation.sh`. |

## Format dispatch

`set_config_value <file> <key> <value>` selects a writer by extension:

| Extension | Writer | Tool |
|-----------|--------|------|
| `.json` | `set_json_value` (via `set_json_value_with_jq`, or `set_json_value_with_sed` when the key contains `..`) | `jq` / `sed` |
| `.xml` | `set_xml_value` | `xmlstarlet` |
| `.yml` / `.yaml` | `set_yml_value` | `yq` (fallback `sed` for simple keys) |
| other (properties, text) | inline `sed` writer | `sed` |

`set_config_values <file> [key value]...` applies a batch and counts the arguments, reporting an error on an odd count.

## Empty values and missing files

- An **empty value** deletes the key: `set_yml_value` calls `delete_yml_setting`, the JSON writer switches to `del(...)`, and the region-flag helpers use this to clear greetings.
- A **missing file** causes the setter to return silently. This makes provisioning safe to run on hosts that do not have every plugin installed.

## Reading values

- `get_config_value <file> <key>` — dispatches to `get_yml_value`.
- `get_yml_value <file> <key>` — uses `yq` for dotted keys, `grep` for simple keys.
- `get_server_property <key> [fallback]` — reads a `key=value` property from `server.properties` in `specs.sh`.

## Required utilities

`config.sh` validates at load time that `jq`, `xmlstarlet`, and `yq` exist at `/usr/bin/`, exiting with code 400 if any is missing.

## Hardware-derived values

`specs.sh` derives performance values, then clamps them to safe bounds:

| Value | Derivation | Bound |
|-------|-----------|-------|
| `VIEW_DISTANCE` | Configured; default 8 | clamped to `[VIEW_DISTANCE_MIN, VIEW_DISTANCE_MAX]` |
| `SIMULATION_DISTANCE` | Configured; default 6 | clamped to `[SIMULATION_DISTANCE_MIN, SIMULATION_DISTANCE_MAX]`, never above `VIEW_DISTANCE` |
| `VIEW_DISTANCE_PERCENTAGE_OF_VANILLA` | `100 * VIEW_DISTANCE / VIEW_DISTANCE_VANILLA` | — |
| Mob spawn limits | `base * SIMULATION_DISTANCE_PERCENTAGE_OF_VANILLA / 100` | — |
| `VIEW_CHUNKS_TARGET` / `SIMULATION_CHUNKS_TARGET` | `(2d+1)²` formulas × `PLAYERS_MAX` | — |
| `CONNECTION_THROTTLE` | 4000, or 1000 when `Sonar` is installed | — |
| `CPU_THREADS` | `nproc` | — |

## Precedence

There is no layered override system: the on-disk file is authoritative and scripts write it directly. Where a value is read from one file to seed another (e.g. `WORLD_NAME` from `level-name`), that read happens once at `specs.sh` load. See [invariants.md](./invariants.md) for the stability contracts.

## Related documentation

- [components/configuration-writers.md](./components/configuration-writers.md)
- [flows/configuration.md](./flows/configuration.md)
