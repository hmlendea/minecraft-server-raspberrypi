# Troubleshooting

## `server start` aborts with "<N>G total RAM is not supported"

**Cause:** total system memory is not 4G, 7G, or 8G.

**Resolution:** run on a 4G or 7–8G Pi, or adjust the RAM branch in `server` (and the heap values) deliberately. There is no override flag.

## `server start` prints "no permission to run commands as minecraft user" (exit 21)

**Cause:** the controller could not assume the `minecraft` user (`${SUDO_CMD} whoami` did not return `minecraft`).

**Resolution:** run as root, as `minecraft`, or with working passwordless `sudo -u minecraft`.

## `server start` prints "failed" and dumps the console buffer

**Cause:** the session died during startup — typically no server jar found, a Java version mismatch, or a configuration error.

**Resolution:** read the dumped buffer; confirm a `purpur-*.jar` (or Paper/Spigot fallback) exists and Java 16+ is installed.

## `server start` prints "skipping"

**Cause:** the startup `done` marker was not observed within 30 checks.

**Resolution:** non-fatal; the server likely continues starting. Confirm later with `server status`.

## `A tmux <session> session is already running`

**Cause:** a session with the repository directory name already exists.

**Resolution:** use `server console`/`server command` to interact with it, or stop it first.

## `There is no <session> session to connect to`

**Cause:** `command` or `console` was invoked with no live session.

**Resolution:** start the server first.

## `configure-*` reports "The 'jq'/'yq'/'xmlstarlet' utility must be installed" (exit 400)

**Cause:** a required host utility is missing.

**Resolution:** install it. `config.sh` checks `/usr/bin/jq`, `/usr/bin/xmlstarlet`, `/usr/bin/yq`.

## `configure-*` reports "The 'yq' utility is not installed" per call

**Cause:** `yq` is absent at write time.

**Resolution:** install `yq`; YAML writes cannot proceed without it.

## `update-server.sh` prints "The server needs to be stopped to update the plugins!" (exit 1)

**Cause:** a running Java process matching bukkit/paper/purpur/spigot was detected.

**Resolution:** stop the server, then update.

## Backup reports "The tar binaries are needed for a backup" (exit 11)

**Cause:** `tar` is not installed.

**Resolution:** install `tar`.

## Backup reports "Nothing to back up."

**Cause:** none of the configured backup items exist.

**Resolution:** confirm the server directory layout.

## Player location/spawn prints empty

**Cause:** `nbted` is not installed, or the playerdata file is missing.

**Resolution:** install `nbted`; verify `world/players/data/<uuid>.dat`.

## `server status` memory summary fails

**Cause:** `gawk` is not installed.

**Resolution:** install `gawk`.

## `change-player-username.sh` prints "The new UUID/Username already exists"

**Cause:** a target file for the new UUID/username already exists.

**Resolution:** remove the conflicting file deliberately, or choose a different target. The script aborts before any mutation by design.

## Tests fail in CI with "jq: command not found"

**Cause:** the runner lacks `jq`.

**Resolution:** the workflow verifies `jq` before running; ensure the runner image provides it.

## Related documentation

- [error-handling.md](./error-handling.md)
- [flows/startup.md](./flows/startup.md)
- [faq.md](./faq.md)