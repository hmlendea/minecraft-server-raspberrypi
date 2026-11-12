# Repository overview

## Purpose

The repository exists to define, provision, and operate a single Minecraft server optimised for Raspberry Pi 4 hardware. It is not the Minecraft server itself; it is the operations toolkit and declarative configuration around a third-party PurpurMC Java process.

## Scope

- **Operating procedures:** start, stop, status, restart, console access, command dispatch, and backup of the runtime.
- **Configuration provisioning:** deterministic application of performance, gameplay, and localisation settings across server and plugin configuration files.
- **Artefact acquisition:** download and replacement of the server jar, plugin jars, and datapacks from upstream providers.
- **Player data operations:** identity resolution, reporting, and username migration.

## Explicit non-scope

- Minecraft gameplay mechanics.
- Plugin-internal behaviour (treated as opaque).
- The hosted PurpurMC runtime (a filesystem-deployed jar, never linked against).
- The fixed set of installed plugins: the inventory is discovered from `plugins/` at execution time.

## Entry points

| Entry point | Invocation | Purpose |
|-------------|-----------|---------|
| `server` | `./server <command>` | Operator control of the runtime. See [api-reference/INDEX.md](./api-reference/INDEX.md). |
| `scripts/configure-all.sh` | `sh scripts/configure-all.sh` | Apply settings then localisation. |
| `scripts/configure-settings.sh` | `sh scripts/configure-settings.sh` | Apply performance and gameplay settings. |
| `scripts/configure-localisation.sh` | `sh scripts/configure-localisation.sh` | Apply locale-dependent messages. |
| `scripts/update-server.sh` | `sh scripts/update-server.sh` | Refresh server jar, plugins, and datapacks. |
| `scripts/fix-permissions.sh` | `sh scripts/fix-permissions.sh` | Restore `minecraft:minecraft` ownership and modes. |
| `scripts/get-player.sh` | `sh scripts/get-player.sh <name\|uuid>` | Report one player's details. |
| `scripts/get-players.sh` | `sh scripts/get-players.sh` | Report all known players. |
| `scripts/get-player-trades.sh` | `sh scripts/get-player-trades.sh <name>` | Report recent ChestShop trades. |
| `scripts/reset-end.sh` | `sh scripts/reset-end.sh` | Remove selected End region files (archived first). |
| `scripts/change-player-username.sh` | `sh scripts/change-player-username.sh <old> <new>` | Migrate player data across plugins. |
| `tests/*-tests.sh` | `bash tests/modrinth-tests.sh` | Provider parsing verification. |

## Audience

- **Server operators:** use [quick-start.md](./quick-start.md) and [api-reference/INDEX.md](./api-reference/INDEX.md).
- **Future maintainers:** use [architecture.md](./architecture.md), [components/](./components/), and [change-guide.md](./change-guide.md).

## Related documentation

- Root system context: [`ARCHITECTURE.md`](../ARCHITECTURE.md).
- Operator details: [`README.md`](../README.md).
