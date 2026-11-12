# Invariants

System-wide invariants and stability contracts. A change that violates one of these is a breaking change.

## Interface invariants

1. The `server` controller accepts `start`, `stop`, `status`, `restart`, `console`, `command`, `backup` as its first argument. Additive changes only.
2. Exported variable names in `paths.sh` and `specs.sh` remain stable; renames require synchronised updates to every consumer.
3. Provider adapters expose the `update_plugin_*` / `download_plugin_*` contract; routing stays inside `plugins.sh`.

## Configuration invariants

4. Dotted configuration key paths must match the target file's schema.
5. Empty values delete keys; missing files are skipped. Provisioning is idempotent.
6. Plugin-specific writes are guarded by installation checks.
7. Placeholder tokens (`%player%`, `{PLAYER}`, `%pluginVersion%`, `<name>`, …) are preserved verbatim in configuration values.

## File and path invariants

8. All scripts resolve the repository root via the `realpath`/`sed` idiom, independent of the working directory.
9. Path expansion is lazy: variables such as `WORLD_DIR`/`WORLD_NAME` are defined before use even when declared later.
10. Downloaded artefacts are chowned `minecraft:minecraft`.
11. `server.properties`, `cache/players.json`, `DiscordSRV/accounts.aof`, and world directories live at their fixed paths.

## Runtime invariants

12. Exactly one JVM is managed by the controller; the tmux session name equals the repository directory name.
13. Heap allocation is derived from total RAM and only 4G / 7G / 8G are supported.
14. Console access is serialised through the `cmd_lock` and the FIFO buffer.
15. The command buffer is a plain file during startup and a FIFO afterwards.

## Data invariants

16. Player identity is keyed by UUID; username changes are migrated by rewriting UUID references and moving UUID/username-keyed files.
17. Migration fails closed: an existing target for the new UUID/username aborts before any mutation.
18. Backups retain the six most recent archives.

## Provider invariants

19. Modrinth plugin versions are filtered on `{paper, spigot, bukkit}`; datapacks on `{datapack}`.
20. Filename placeholders `%pluginName%`, `%pluginVersion%`, `%dataPackName%`, `%dataPackVersion%` expand per the documented semantics.
21. Update flows never replace artefacts under a live server.

## Related documentation

- [configuration.md](./configuration.md)
- [components/plugin-management.md](./components/plugin-management.md)
- [testing.md](./testing.md)