# Change guide

How to modify common areas safely. Each section gives the files to change, the constraints to respect, and the verification to run.

## Add a managed plugin or datapack

1. Add an `update_plugin` (or `update_datapack`) entry in `scripts/update-server.sh`:
   - `update_plugin '<name>' '<url>' '<asset-pattern>' [allow_prereleases]`.
   - Choose the URL whose host selects the correct adapter (`github`/`modrinth`/otherwise Jenkins).
2. Guard configuration writes in `configure-settings.sh` / `configure-localisation.sh` with `configure_plugin` (which internally checks installation).
3. Do not add provider branching outside `plugins.sh` and its adapters.

**Verify:** `bash tests/modrinth-tests.sh` when loader filtering is touched; a dry inspection of the resolved URL otherwise.

## Add or change a configuration setting

1. Add the key/value pair to the relevant `set_config_*` call in `configure-settings.sh`.
2. Confirm the dotted path matches the target file's schema.
3. Route through `set_config_value`/`set_config_values`, never direct file edits.

**Verify:** run `sh scripts/configure-settings.sh` on a host (or a copy of the files) and inspect the audit lines.

## Add a localised message

1. Add the placeholder/variable to both `ro` and `en` branches in `configure-localisation.sh`.
2. Use the message builders from `messages.sh`.
3. Preserve plugin placeholder tokens exactly.

**Verify:** run `sh scripts/configure-localisation.sh` and confirm both branches define the variable.

## Add an operational script

1. Place it in `scripts/`, sourcing `paths.sh` first.
2. Source additional libraries as needed; never make a library depend on a script.
3. Use path variables from `paths.sh` and `run_with_privileges` for privileged operations.
4. Reapply `fix-permissions.sh` if ownership changes; add to `configure-all.sh` if it belongs to the standard sequence.

## Change hardware-derived tuning

1. Edit `specs.sh`; keep clamps (`VIEW_DISTANCE_MIN/MAX`, `SIMULATION_DISTANCE_MIN/MAX`) intact.
2. Recompute dependants (`*_PERCENTAGE_OF_VANILLA`, spawn limits, chunk targets) automatically.

## Change the server controller

1. Preserve the command vocabulary and the privilege gate.
2. Keep the session-created-before-launch ordering and the file→FIFO buffer transition.
3. Keep the `cmd_lock` wait-for bracketing on all console interaction.

## Migrate player data

1. Extend `change-player-username.sh` only additively; keep the fail-closed precondition.
2. Ensure every moved file's ownership is fixed afterwards.
3. Consider updating `cache/players.json` (currently not updated — see [ambiguities-and-open-questions.md](./ambiguities-and-open-questions.md)).

## Cross-cutting rules

- Maintain cross-platform compatibility of scripts.
- Keep scripts dependency-light; do not introduce a new required utility without a check.
- Update documentation when behaviour changes.

## Related documentation

- [ARCHITECTURE.md](../ARCHITECTURE.md) extension points.
- [invariants.md](./invariants.md)
- [testing.md](./testing.md)