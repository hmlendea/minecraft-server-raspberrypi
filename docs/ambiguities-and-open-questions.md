# Ambiguities and open questions

Unresolved items, latent defects, and known gaps observed in the source. Recorded as evidence, not as instructions.

## Correctness anomalies

1. **`reset-end.sh` region-sign handling.** Inside `clear_region`, the negative-coordinate branch tests `REGION_X` but assigns `REGION_X=$((REGION_Y - 1))`, and the guard tests the shell string `X`/`Y` rather than `"${X}"`/`"${Y}"`. Negative and origin regions may therefore be mis-mapped or mis-guarded. (`scripts/reset-end.sh`)
2. **`change-player-username.sh` stats move.** The stats file is moved to `WORLD_PLAYERDATA_DIR` instead of `WORLD_STATS_DIR`, so the source `/stats/<uuid>.json` is never found and the step silently no-ops. (`scripts/change-player-username.sh`)
3. **`worldguard.sh` undefined variable.** `set_deny_message`, `set_teleport_message`, `set_farewell_message`, and `set_greeting_message` reference `REGION_TYPE_ID` before it is set, instead of their `REGION_TYPE` parameter, in the `[ -z ... ]` tests. (`scripts/common/worldguard.sh`)
4. **Duplicate `transform_asset_file_name`.** Both `jenkins.sh` (`transform_asset_file_name`) and `plugins.sh` (`transform_plugin_asset_file_name`) perform filename substitution with overlapping semantics. (`scripts/common/jenkins.sh`, `scripts/common/plugins.sh`)
5. **`web.sh` privilege coupling.** `download_file` performs `chown minecraft:minecraft` internally, mixing a privilege concern into a generic download primitive. (`scripts/common/web.sh`)
6. **Player cache not invalidated on migration.** `change-player-username.sh` does not update or clear `cache/players.json`, so stale UUID→username mappings can persist. (`scripts/common/players.sh`, `scripts/change-player-username.sh`)
7. **Duplicate keys in `configure_plugin` calls.** Some `configure_plugin` invocations pass the same key twice (e.g. `PurpurExtras` `settings.protect-blocks-with-loot.message` in the `ro` branch). The last assignment wins, which may not be the intent. (`scripts/configure-localisation.sh`)
8. **`clean-server-properties` race.** The detached 2-minute job rewrites `server.properties` without synchronisation with other writers. (`server`)
9. **`convert_seconds_to_ticks` short-circuit hazard.** As the right-hand side of `set_config_value "${KEY}" $(convert_seconds_to_ticks 15)`, the function's `echo` is fine, but the pattern is fragile if the helper ever changes. (`scripts/common/utils.sh`, `scripts/configure-settings.sh`)

## Naming and consistency

10. **Case inconsistency in plugin names.** `configure-settings.sh` uses `ChatBubbles` while `configure-localisation.sh` uses `Chatbubbles`; the name is also echoed into `get_reload_message`. Whether these refer to the same plugin is unclear from the toolkit alone.
11. **`function_exists` semantics.** The function returns 0 (a not-found code path) before it has inspected anything, so the "found" branch is only reachable when a `# Source file:` comment exists. Its contract is ambiguous. (`scripts/common/utils.sh`)
12. **Message typos.** Several localised strings contain apparent typos (`The offer1s inventory`, `Your shop1s`, `f${COLOUR_HIGHLIGHT}%what%`, `doesn\'`). These are written verbatim into plugin configuration.

## Gaps

13. **No automated coverage** for the controller, configuration writers, player data, or the non-Modrinth adapters. See [testing.md](./testing.md).
14. **No checksum or signature verification** of downloaded artefacts. See [security.md](./security.md).
15. **No log redaction** of player personal data. See [logging.md](./logging.md).
16. **Disabled/TODO updates.** Multiple plugins are commented out or marked `TODO` in `update-server.sh` (BestTools, ChestSort, CommandHelper, InvUnload, TreeAssist, and others), meaning they are updated manually.
17. **`MINECRAFT_VERSION='26.3'`** does not match any released Minecraft version line, suggesting a placeholder or a private/forward-dated value. Impact on `update-server.sh` is unclear without the provider response.
18. **`SERVER_HOSTNAME`, `CURRENCY_SYMBOL`, `PLAYERS_MAX`, `PLAYERS_TARGET`** are hard-coded operator-specific values with no documented override mechanism.
19. **`simulation-distance` for the End/Nether** references `SIMULATION_DISTANCE_END`/`SIMULATION_DISTANCE_NETHER` in `configure-settings.sh`, but `specs.sh` only defines `SIMULATION_DISTANCE_END`/`SIMULATION_DISTANCE_NETHER` conditionally (`[ -z ... ]` assignments). Confirm intended defaults when tuning.

## Questions for maintainers

- Is `MINECRAFT_VERSION` intended to track a real release line?
- Should the player cache be updated during username migration?
- Is `ChatBubbles` distinct from `Chatbubbles`?
- Should `web.sh` own the `chown`, or should callers?
- Should `reset-end.sh` be corrected, or is the current behaviour relied upon?

## Related documentation

- [testing.md](./testing.md), [security.md](./security.md), [change-guide.md](./change-guide.md)