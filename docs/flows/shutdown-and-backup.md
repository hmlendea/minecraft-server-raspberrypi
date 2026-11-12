# Flow: shutdown and backup

## Shutdown (`./server stop [reason]`)

```mermaid
sequenceDiagram
  participant Op as Operator
  participant Ctl as server controller
  participant JVM as PurpurMC JVM
  Op->>Ctl: ./server stop [reason]
  Ctl->>JVM: essentials:broadcast "Attention everyone!"
  Ctl->>JVM: broadcast "<server> will shut down in a moment"
  opt reason provided
    Ctl->>JVM: broadcast "Reason: <reason>"
  end
  Ctl->>JVM: essentials:broadcast "kick in 30 seconds"
  Ctl->>Ctl: sleep 30
  Ctl->>JVM: kickall "<server> is shutting down …"
  Ctl->>JVM: save-all
  Ctl->>JVM: stop
  loop up to 100 × 0.1s
    Ctl->>Ctl: session gone?
  end
  Ctl-->>Op: done / timed out
```

- All broadcast texts are localised on `LOCALE` (`ro`/`en`).
- `SECONDS_BEFORE_KICK=30`.
- When no session exists, the controller prints that the session was already dead.
- The `reason` argument becomes part of the kick reason.

## Backup (`./server backup`)

```mermaid
flowchart TD
  A[server backup] --> B{tar available?}
  B -->|no| X[exit 11]
  B -->|yes| C[collect existing backup paths]
  C --> D{any paths?}
  D -->|no| Y[Nothing to back up]
  D -->|yes| E{server running?}
  E -->|yes| F[game_command save-off]
  F --> G[game_command save-all]
  G --> H[sleep; sync; wait]
  H --> I[tar.gz to backup dir]
  I --> J[game_command save-on]
  E -->|no| I
  J --> K[retention prune to 6]
  I --> K
```

- Backup items are filtered to those that exist: `data`, `plugins`, `world`, `world_nether`, `world_the_end`, `server.properties`, `cache/players.json`, `banned-players.json`, `whitelist.json`.
- Archive name: `<timestamp>.tar.gz` under `/var/backups/minecraft/<session>/`.
- The `tar` invocation runs from `SERVER_ROOT_DIR` and filters the "Removing leading" notice.
- Retention: `ls -tp *.tar.gz | tail -n +7 | xargs -r rm` removes everything beyond the six newest.

## Causal guarantees

- A running server is quiesced (`save-off` then `save-all`) before archiving, giving a consistent snapshot, and resumed (`save-on`) after.
- A stopped server archives without save toggling.
- The backup directory is created if absent.

## Failure modes

| Condition | Result |
|-----------|--------|
| `tar` missing | exit 11 |
| Nothing to back up | informational message, no archive |
| Server stopped | direct archive, no save toggling |

## Related documentation

- [components/server-controller.md](../components/server-controller.md)
- [state-and-persistence.md](../state-and-persistence.md)
