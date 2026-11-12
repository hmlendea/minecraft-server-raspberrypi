# Concurrency and scheduling

## Process model

- One JVM process managed through one detached tmux session.
- No supervision, clustering, or automatic restart.
- The session name is `basename "$SERVER_ROOT_DIR"`, so the repository directory name is significant.

## Console serialisation

All console interaction passes through `game_command`, which brackets each operation with tmux `wait-for` locks:

```
wait-for -L cmd_lock
  … send-keys / pipe-pane …
wait-for -U cmd_lock
```

This guarantees that no two commands interleave on the console. Startup and shutdown release the lock at defined points.

## Command buffer

| Phase | Buffer type | Reason |
|-------|-------------|--------|
| During startup | Plain file (`touch`) | Must exist before output is produced |
| After startup | FIFO (`mkfifo`) | Serialise command dispatch |

The buffer lives at `/tmp/minecraft_<session>_command_dump.txt` and is removed on stop.

## Background jobs

- `clean-server-properties &` — a detached 2-minute delayed job that strips comments and sorts `server.properties`. It runs unsynchronised with the rest of the start flow, so a concurrent write to `server.properties` could race with it.

## Timing constants

| Constant | Value | Location |
|----------|-------|----------|
| `MAX_SERVER_START_TIME` | 30 checks | `server` |
| Poll interval | `sleep_time` (0.1 s default) | `server` |
| `SECONDS_BEFORE_KICK` | 30 s | `server` |
| Stop wait | 100 × 0.1 s | `server` |
| `sleep_time` (command capture) | 0.3 s | `server` |
| `clean-server-properties` delay | 2 min | `server` |
| Autosave | 20/30/40 min (overworld/nether/end) | `specs.sh` |

## Resource bounding

- Heap is fixed (`-Xms`/`-Xmx`) from total RAM.
- `paper.maxChunkThreads=3`.
- View/simulation distances and mob spawn limits are clamped in `specs.sh`.
- Chunk loading rates are bounded in `paper-global.yml`.

## Consistency during backup

`save-off` then `save-all` precede the archive and `save-on` follows when the server is running; `sync && wait` flushes buffers.

## Related documentation

- [components/server-controller.md](./components/server-controller.md)
- [flows/startup.md](./flows/startup.md)
- [state-and-persistence.md](./state-and-persistence.md)