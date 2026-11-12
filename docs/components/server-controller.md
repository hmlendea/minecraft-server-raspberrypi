# Server controller

**File:** `server` (repository root, executable).

## Purpose

The operator entrypoint. Translates a single positional command into tmux operations against a detached JVM session, and provides process lifecycle, console access, command dispatch, and backup.

## Responsibilities

- Resolve the server jar and heap allocation.
- Create, query, and terminate the tmux session.
- Serialise console interaction through a command buffer.
- Poll for startup completion.
- Gracefully stop the server with player notification.
- Archive selected paths to the backup store.

## Deliberately not responsible for

- Minecraft gameplay behaviour.
- Plugin configuration (handled by `configure-*.sh`).
- Artefact updates (handled by `update-server.sh`).

## Session and privilege model

- `GAME_USER='minecraft'`; the session runs as this user.
- `SESSION_NAME=$(basename "$SERVER_ROOT_DIR")`.
- If the current user already is `minecraft`, `SUDO_CMD` is empty; otherwise `SUDO_CMD="sudo -u minecraft"`.
- A guard runs `${SUDO_CMD} whoami` and exits `21` unless it returns `minecraft`.
- The tmux server socket is namespaced with `-L "${SESSION_NAME}"`.

## Jar and RAM resolution

```bash
SERVER_JAR_NAME = last "purpur-[0-9.]*-[0-9]*.jar"
                → last "paper-[0-9]*.jar"
                → last "spigot-[0-9]*.jar"
TOTAL_RAM = MemTotal (GiB, rounded)
7G|8G → ALLOCATED_RAM=5500M
4G    → ALLOCATED_RAM=3G
else  → "not supported" and exit 1
```

The launch command uses Aikar-derived G1GC flags, `-Dpaper.maxChunkThreads=3`, `-Djna.tmpdir=${SERVER_CACHE_DIR}/JNA`, `--add-modules=jdk.incubator.vector`, and appends `nogui`.

## Startup detection

`SERVER_START_SUCCESS='done'`. The controller polls the command buffer up to `MAX_SERVER_START_TIME=30` times:

- Session dead → print `failed`, dump the buffer to stderr, remove the buffer, `kill-session`, `exit 1`.
- `grep -q -i done` in the buffer → print `done` and break.
- Final iteration without success → print `skipping`, warn to stderr, continue.

## Command buffer lifecycle

1. A plain file (`touch`) is used while the JVM starts, so the buffer exists before output is produced.
2. Pipe-pane `cat > buffer` captures console output.
3. After the session is up, the buffer is replaced by a FIFO (`rm -f` then `mkfifo`), which serialises subsequent command dispatch.

`game_command` wraps every console interaction with `wait-for -L cmd_lock` / `wait-for -U cmd_lock`, and, when `return_stdout` is set, temporarily enables pipe-pane to capture output.

## Background job

`clean-server-properties &` sleeps two minutes, deletes lines beginning with `#`, then sorts `server.properties` in place. It is detached and unsupervised. Two lines that would invoke `configure-settings.sh` and `fix-permissions.sh` are commented out.

## Key functions

| Function | Role |
|----------|------|
| `game_command` | Send keys / capture output under the command lock. |
| `server_start` | Geyser update, session creation, launch, startup poll. |
| `server_stop [reason]` | Localised broadcast, 30 s delay, kickall, save-all, stop, wait. |
| `server_status` | Running/stopped plus RSS memory summary via `gawk`. |
| `server_restart` | Stop-then-start when running. |
| `server_console` | `tmux attach`. |
| `server_command <…>` | Requires ≥1 argument; runs a command and returns stdout. |
| `server_backup` | Requires `tar`; save toggling; archive; retention prune. |
| `socket_has_session` / `socket_session_is_alive` | Session existence and `pane_dead` checks. |

## Failure semantics

- `set -u` and `set -e` are enabled after definitions; unset variables and unhandled command failures abort.
- Unknown command → message, no exit code change.
- Unsupported RAM → exit 1.
- Missing `tar` on backup → exit 11.
- No session for `command`/`console` → informational message.

## Related documentation

- [flows/startup.md](../flows/startup.md), [flows/shutdown-and-backup.md](../flows/shutdown-and-backup.md)
- [concurrency-and-scheduling.md](../concurrency-and-scheduling.md)
- [api-reference/INDEX.md](../api-reference/INDEX.md)
