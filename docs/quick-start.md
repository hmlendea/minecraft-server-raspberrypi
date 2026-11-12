# Quick start

## Prerequisites

- A Raspberry Pi 4 with a Linux-based OS.
- Java 16 or later (the runtime is a PurpurMC jar).
- A dedicated `minecraft` system user owning the server files.
- Host utilities: `jq`, `yq`, `xmlstarlet`, `tmux`, `tar`, `curl`, `wget`. `nbted` is additionally required for player-data queries. `gawk` is used by `server status`.
- Optional: `lighttpd`, `fcgi`, `php-cgi` if map plugins are used (see [`README.md`](../README.md)).

## First run

1. Deploy the repository onto the host.
2. Place the PurpurMC server jar (`purpur-<version>-<build>.jar`) in the repository root. The controller also accepts `paper-<version>.jar` or `spigot-<version>.jar` as fallbacks.
3. Ensure files are owned by `minecraft:minecraft` (run `scripts/fix-permissions.sh` as root or the `minecraft` user).
4. Start the server:

```bash
./server start
```

5. Verify status:

```bash
./server status
```

## Everyday operations

| Task | Command |
|------|---------|
| Start | `./server start` |
| Stop | `./server stop` |
| Restart | `./server restart` |
| Status | `./server status` |
| Attach console | `./server console` |
| Run a console command | `./server command <command...>` |
| Back up | `./server backup` |

## Applying configuration

```bash
sh scripts/configure-all.sh
```

Runs `configure-settings.sh` then `configure-localisation.sh`. Both are idempotent and skip missing files.

## Updating artefacts

Stop the server first, then:

```bash
sh scripts/update-server.sh
```

## Inspecting players

```bash
sh scripts/get-player.sh <username-or-uuid>
sh scripts/get-players.sh
sh scripts/get-player-trades.sh <username>
```

## Running the tests

```bash
for TEST_SCRIPT in tests/*-tests.sh; do bash "${TEST_SCRIPT}"; done
```

## Troubleshooting first steps

- `server start` aborts with a RAM message: total memory is not 4G or 7–8G — see [troubleshooting.md](./troubleshooting.md).
- Permission error (exit 21): the controller could not assume the `minecraft` user.
- `configure-*` reports a missing utility: install `jq`, `yq`, or `xmlstarlet`.

## Related documentation

- [api-reference/INDEX.md](./api-reference/INDEX.md) — full operator command reference.
- [flows/startup.md](./flows/startup.md) — what `server start` actually does.
