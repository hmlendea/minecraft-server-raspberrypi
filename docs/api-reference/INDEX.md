# API reference index

The toolkit exposes no HTTP API. Its "API" is the **operator command interface**: a single positional command on the `server` controller, plus the operational scripts under `scripts/`.

## Operator command interface

**Controller:** `server` (repository root).

**Invocation:** `./server <command> [arguments…]`

**Base path:** the repository root; commands are the first argument.

| Command | Argument | Effect | Auth | Reference |
|---------|----------|--------|------|-----------|
| `start` | — | Launch the JVM in a detached tmux session. | `minecraft` user (via `sudo -u`) | [components/server-controller.md](../components/server-controller.md) |
| `stop` | `[reason]` | Graceful shutdown with player notification. | `minecraft` user | [flows/shutdown-and-backup.md](../flows/shutdown-and-backup.md) |
| `status` | — | Running/stopped and RSS summary. | `minecraft` user | below |
| `restart` | — | Stop (if running) then start. | `minecraft` user | — |
| `console` | — | Attach to the tmux session. | `minecraft` user | — |
| `command` | `<command…>` | Send a console command; return output. | `minecraft` user | below |
| `backup` | — | Archive selected paths; prune to six. | `minecraft` user, `tar` | below |
| *(other)* | — | Prints `Unknown command: <value>`. | — | — |

Global precondition: the controller must be able to run as `minecraft` (exit 21 otherwise). Global failure: unsupported total RAM aborts `start` with exit 1.

## `status`

- **Responses:** `Status: running` (plus a process/memory summary computed with `gawk`) or `Status: stopped`.
- **Side effects:** none.
- **Auth:** `minecraft` user for the `pgrep`.

## `command`

- **Request:** `./server command <command...>`; the arguments are joined and sent to the console.
- **Responses:** the console output text (captured via pipe-pane), or `There is no <session> session to connect to.` when stopped.
- **Errors:** `No server command specified.` (exit 1) when no arguments.
- **Behaviour:** sends under the `cmd_lock`; captures output by temporarily enabling pipe-pane; polling delay defaults to `sleep_time` (0.3 s when `return_stdout`).
- **Auth:** `minecraft` user.

## `backup`

- **Responses:** progress lines, then `backup completed`.
- **Errors:** exit 11 when `tar` is not installed; `Nothing to back up.` when no targets exist.
- **Behaviour:** save-toggle when running; timestamped `tar.gz`; retention prune to six.
- **Idempotency:** additive; repeated runs create new archives and prune the oldest.

## Operational scripts reference

| Script | Request | Success output | Errors |
|--------|---------|----------------|--------|
| `configure-all.sh` | — | write audit lines | propagates child failures |
| `configure-settings.sh` | — | write audit lines | missing utility → exit 400 |
| `configure-localisation.sh` | — | write audit lines | privilege failure |
| `update-server.sh` | — | per-item `Checking for updates…` / `Downloaded` | running server → exit 1 |
| `fix-permissions.sh` | — | none | privilege failure |
| `reset-end.sh` | — | `Removing region …` lines | none |
| `get-player.sh` | `<name\|uuid>` | formatted report | — |
| `get-players.sh` | — | report per player | — |
| `get-player-trades.sh` | `<name>` | trade lines | — |
| `change-player-username.sh` | `<old> <new>` | move lines | `new UUID/Username already exists` → abort |

## Authentication and authorisation

There is no network authentication. Authorisation is local: the script must run as, or be able to elevate to, `minecraft`. `run_with_privileges` centralises this decision.

## Versioning

There is no API versioning. The command vocabulary is treated as a stable contract (see [invariants.md](../invariants.md)); changes are additive only.

## Rate limiting

None at the toolkit level. The Minecraft network layer applies `connection-throttle` (see [configuration.md](../configuration.md)).

## Related documentation

- [behaviour/server-lifecycle.md](../behaviour/server-lifecycle.md)
- [components/server-controller.md](../components/server-controller.md)
- [flows/](../flows/)
