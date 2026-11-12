# Testing

## Strategy

Automated verification is **unit-level and focused on provider parsing**. It runs in isolation from a live server and from network calls. Controller, configuration, and runtime behaviour are verified manually by operators.

## Test suite

| Test | Scope | Technique |
|------|-------|-----------|
| `tests/modrinth-tests.sh` | `get_latest_modrinth_version_id` loader filtering | Function-level: `curl` is replaced with a stub returning a fixture; the library is sourced with `source` neutered so only the function under test loads |

## What `modrinth-tests.sh` verifies

1. For each loader in `{paper, spigot, bukkit, datapack}`: the newest matching version is selected from a fixture containing missing-loader, empty-loader, incompatible (`fabric`), and matching entries.
2. Large-response handling: a 20,000-entry fixture returns the first matching id (`version-0`).
3. Empty responses (`[]`) return an empty string for both plugin and datapack types.
4. Incompatible-only responses return an empty string.
5. Non-plugin/non-datapack project types fall back to `.[0].id` (`newest`), and `[]` yields `null` (JSON null serialised by `jq -r`).

## Test harness technique

The test:

```bash
function source() { :; }
builtin source "${SERVER_SCRIPTS_COMMON_DIR}/modrinth.sh"
unset -f source
```

neutralises the library's self-sourcing so it does not pull in `paths.sh` (which would require the full environment). It then defines a `curl` function that prints `TEST_RESPONSE`.

## Running the tests

```bash
for TEST_SCRIPT in tests/*-tests.sh; do
    bash "${TEST_SCRIPT}"
done
```

CI runs the same loop on `push`, `pull_request`, and `workflow_dispatch`.

## Coverage gaps

- No automated tests for `server` (startup, shutdown, backup, console).
- No automated tests for `config.sh` writers.
- No automated tests for `players.sh` identity resolution.
- No automated tests for `worldguard.sh` message generation.
- Provider adapters other than Modrinth are untested.
- Privilege-dependent and network-dependent behaviour is exercised only on the host.

See [ambiguities-and-open-questions.md](./ambiguities-and-open-questions.md) and [change-guide.md](./change-guide.md).

## Related documentation

- [components/provider-adapters.md](./components/provider-adapters.md)
- [build-and-deployment.md](./build-and-deployment.md)