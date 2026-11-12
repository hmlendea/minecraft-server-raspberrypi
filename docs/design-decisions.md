# Design decisions

Key choices and their rationale, consequences, and evidence.

## 1. tmux rather than a service manager

**Decision:** manage the JVM through a detached tmux session named after the repository directory.

**Rationale:** provides persistent, screen-like console access, scriptable command delivery (`send-keys`), output capture (`pipe-pane`), and synchronisation primitives (`wait-for`) without a daemon.

**Consequence:** operator experience is coupled to the session name; there is no automatic restart, supervision, or multi-instance support.

**Evidence:** `server` (session creation, `game_command`, `socket_*` helpers).

## 2. Abstract distribution providers behind adapters

**Decision:** separate `github.sh`, `modrinth.sh`, and `jenkins.sh`, routed only by `plugins.sh`.

**Rationale:** the three providers differ in protocol but share download semantics; a uniform `update_plugin_*` contract keeps `update-server.sh` declarative.

**Consequence:** adding a provider requires a new adapter plus routing; provider-specific logic stays out of unrelated libraries.

**Evidence:** `plugins.sh` routing; adapter function symmetry.

## 3. Mutate configuration in place with format-aware setters

**Decision:** no templates or generated copies; read, edit at a dotted key, write back.

**Rationale:** keeps a single authoritative file per target and avoids templating divergence.

**Consequence:** correctness depends on matching dotted key paths with each schema; failures are silent skips on missing files.

**Evidence:** `config.sh` dispatch by extension.

## 4. Derive performance values from hardware in `specs.sh`

**Decision:** compute distances, spawn limits, chunk targets, and timing constants from a few primitives and clamps.

**Rationale:** centralises Raspberry Pi 4 tuning knowledge so it is recomputed rather than hand-edited per file.

**Consequence:** changing a primitive propagates automatically; unsupported hardware aborts startup.

**Evidence:** `specs.sh` derived values and clamps.

## 5. Disable telemetry and profiler hooks by default

**Decision:** `USE_TELEMETRY=false`, zeroed bStats UUID, `timings` disabled.

**Rationale:** reduces overhead and avoids external reporting on constrained hardware; keeps providers/operators in control.

**Consequence:** metrics require explicit opt-in.

**Evidence:** `specs.sh` flags; `configure-settings.sh` bStats block.

## 6. Fail-closed player migration

**Decision:** `change-player-username.sh` aborts if any new-UUID target exists.

**Rationale:** prevents partial or conflicting migrations across many plugins.

**Consequence:** operators must clear conflicts deliberately.

**Evidence:** precondition block in the script.

## 7. Filesystem-based plugin detection

**Decision:** infer the installed plugin/datapack set from filenames at runtime.

**Rationale:** the same repository must serve hosts with different plugin sets, and plugin inventory is host-specific.

**Consequence:** every plugin-specific operation must be guarded; directory names may differ and require a mapping (see `get_plugin_dir`).

**Evidence:** `plugins.sh` detection and mapping.

## 8. Configuration applied separately from startup

**Decision:** the controller's `configure-settings.sh`/`fix-permissions.sh` calls are commented out; configuration is a separate operator step.

**Rationale:** decouples runtime startup from potentially slow, privilege-heavy configuration.

**Consequence:** operators must run `configure-all.sh` explicitly.

**Evidence:** commented lines in `server`.

## Related documentation

- [architecture.md](./architecture.md)
- [change-guide.md](./change-guide.md)