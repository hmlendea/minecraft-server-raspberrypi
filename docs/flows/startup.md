# Flow: startup

Triggered by `./server start` (and by `./server restart` when stopped).

## Sequence

```mermaid
sequenceDiagram
  participant Op as Operator
  participant Ctl as server controller
  participant Tmux as tmux session
  participant JVM as PurpurMC JVM
  Op->>Ctl: ./server start
  Ctl->>Ctl: verify GAME_USER privilege
  Ctl->>Ctl: resolve jar + detect total RAM
  Ctl->>Ctl: if Geyser installed, update_plugin
  Ctl->>Ctl: check existing session
  alt session exists
    Ctl-->>Op: "already running" message
  else
    Ctl->>Tmux: rm buffer; touch buffer (plain file)
    Ctl->>Tmux: new-session -d /bin/bash (as minecraft)
    Ctl->>Tmux: set -g prefix2 C-a
    Ctl->>Tmux: wait-for cmd_lock
    Ctl->>Tmux: pipe-pane "cat > buffer"
    Ctl->>Tmux: send-keys "exec <java …>"
    Tmux->>JVM: exec java
    loop up to 30 × 0.1s
      Ctl->>Ctl: session alive? grep -q done buffer?
    end
    Ctl->>Tmux: pipe-pane off
    Ctl->>Tmux: rm buffer; mkfifo buffer
    Ctl-->>Op: done / warning
  end
```

## Causal detail

1. **Privilege gate** — `${SUDO_CMD} whoami` must return `minecraft`, otherwise exit 21. This runs before any other effect.
2. **Jar resolution** — scans for the newest matching Purpur jar, then Paper, then Spigot. If none is found, `SERVER_JAR_PATH` is empty and the launch will fail at the `exec` step.
3. **RAM gate** — total memory must be 4G or 7–8G, else exit 1. Heap is fixed at 3G or 5500M respectively.
4. **Geyser refresh** — if Geyser is installed, its update is attempted inline. A network failure degrades to "no download" rather than aborting.
5. **Ordered session creation** — the session and pipe-pane are established **before** the launch command so that early console output is captured. A `cmd_lock` wait-for synchronises the two steps.
6. **Startup detection** — the loop treats a **dead session** as fatal (dumps buffer, kills session, exits 1) but a **timeout** as a warning, continuing regardless. The `done` marker is matched case-insensitively.
7. **Buffer transition** — the buffer is converted from a plain file to a FIFO so that later console interaction is serialised. This is the point at which `game_command` becomes safe to use.

## Concurrency

- `clean-server-properties &` starts a background job that mutates `server.properties` after two minutes, independent of the start result.
- `configure-settings.sh` and `fix-permissions.sh` invocations are commented out in the controller; configuration is expected to be applied separately.

## Failure modes

| Condition | Result |
|-----------|--------|
| Not `minecraft` user | exit 21 with a permission message |
| Unsupported RAM | exit 1 with "not supported" |
| No jar found | launch `exec` fails; session dies; exit 1 with buffer dump |
| Startup marker not reached in 30 checks | warning to stderr, continues |
| Session already running | informational message, no action |

## Related documentation

- [components/server-controller.md](../components/server-controller.md)
- [concurrency-and-scheduling.md](../concurrency-and-scheduling.md)
- [troubleshooting.md](../troubleshooting.md)
