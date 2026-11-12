# FAQ

## What server software is used?

PurpurMC (a Paper fork), placed as a jar in the repository root. Paper and Spigot jars are accepted as fallbacks by the controller.

## Why is `server.properties` not in version control?

It is host-specific, secrets-adjacent, and mutated in place; `.gitignore` excludes it. Use the configuration scripts to change it reproducibly.

## How do I change the Minecraft version?

Set `MINECRAFT_VERSION` in `scripts/common/specs.sh`, then run `sh scripts/update-server.sh` (with the server stopped) to fetch the matching Purpur build.

## Why does the server use a fixed heap?

Heap is derived from total system RAM (3G on 4G systems, 5500M on 7–8G systems) with fixed `-Xms`/`-Xmx` and a tuned G1GC flag set, trading flexibility for predictable Raspberry Pi performance.

## How do I add a plugin?

Add an `update_plugin` entry in `scripts/update-server.sh` and guard its configuration with `configure_plugin`. See [change-guide.md](./change-guide.md).

## Why do configuration scripts skip some plugins?

Plugin-specific writes are guarded by installation checks, so a host with a subset of plugins receives only the relevant configuration.

## Is telemetry enabled?

No. `USE_TELEMETRY=false`, the bStats server UUID is zeroed, and `timings` is disabled by default.

## How do I back up?

`./server backup`. It save-toggles when running, archives selected paths to `/var/backups/minecraft/<session>/`, and keeps the six most recent archives.

## How do I run a console command?

`./server command <command...>`; it returns the console output. For interactive access use `./server console`.

## What is the `done` startup marker?

The literal string the controller greps for (case-insensitively) in the captured console output to decide startup has completed.

## Why are there two session-liveness checks?

The controller checks tmux session existence for its own operations; `status.sh` scans `ps aux` for a Java process to provide `IS_SERVER_RUNNING` for the rest of the toolkit. They are independent signals.

## Where are player passwords obtained from?

From the player cache, or parsed from server logs (`/auth`, `/l`, `/log`, `/login`) and cached. Treat as sensitive.

## Can I change a player's username?

Yes, with `sh scripts/change-player-username.sh <old> <new>`, which migrates files and UUID references across plugins and fails closed on conflicts.

## How is the build produced?

There is no build; deployment is a filesystem copy. See [build-and-deployment.md](./build-and-deployment.md).

## How do I run the tests?

```bash
for TEST_SCRIPT in tests/*-tests.sh; do bash "${TEST_SCRIPT}"; done
```

## Related documentation

- [quick-start.md](./quick-start.md)
- [troubleshooting.md](./troubleshooting.md)