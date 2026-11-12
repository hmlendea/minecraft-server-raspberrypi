# Error handling

## Philosophy

Bash is used with a mix of explicit guards and shell options. The toolkit distinguishes **fatal** configuration/precondition failures from **non-fatal** provider and file-absence outcomes.

## Shell options

| Script | Options | Effect |
|--------|---------|--------|
| `server` | `set -u`, `set -e` | Abort on unset variables and unhandled command failures |
| `tests/modrinth-tests.sh` | `set -euo pipefail` | Strict test harness |
| Most others | none | Rely on guards and defaults |

## Exit codes

| Code | Meaning | Origin |
|------|---------|--------|
| 1 | Unsupported RAM; generic precondition failure | `server`, `plugins.sh` |
| 11 | `tar` unavailable for backup | `server` |
| 21 | Cannot run as `minecraft` | `server` |
| 400 | Required utility (`jq`/`yq`/`xmlstarlet`) missing | `config.sh` |
| 2 | Required binary missing | `utils.ensure_bin_is_installed` |

## Guarded no-ops

These conditions produce a message or silence rather than failure:

- Missing configuration file → setter returns.
- Empty value → key deleted.
- Plugin/datapack not installed → configuration and update skip.
- Provider returns no version → update skip.
- Zero-byte download → file removed.
- `move_file`/`copy_file` with missing source or existing target → message, no action.
- `reload_plugin` while the server is stopped → return.
- `server command`/`console` with no session → message.

## Fatal conditions

- `start` as the wrong user (exit 21).
- `start` on unsupported total RAM (exit 1).
- `start` when the session dies during startup (dump + `kill-session` + exit 1).
- `update-server.sh` while the server is running (exit 1).
- Missing `jq`/`yq`/`xmlstarlet` (exit 400).
- Missing `tar` on backup (exit 11).
- `change-player-username.sh` when a new-UUID target already exists (abort before mutation).

## Degraded outcomes

- Startup timeout → warning, continue.
- Network failure in a provider lookup → item skipped.
- `nbted` absent → player location/spawn empty.
- `xargs` prune with no files → `-r` prevents an error.

## Reporting

Diagnostics go to standard error with colourised markers (`failed`, `skipped`, `timed out`). The controller dumps the captured console buffer to stderr when the session dies during startup.

## Related documentation

- [troubleshooting.md](./troubleshooting.md)
- [logging.md](./logging.md)