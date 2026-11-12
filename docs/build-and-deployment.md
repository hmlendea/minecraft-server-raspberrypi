# Build and deployment

## Build

There is no compile step. The "build" is the set of shell scripts and configuration files. Deployment is a filesystem copy onto the target host.

## Deployment model

- A single self-hosted server instance on a Raspberry Pi 4 running a Linux-based OS.
- The repository is placed on the host filesystem; the controller launches the JVM as `minecraft` inside a detached tmux session.
- No containers, orchestration, or horizontal scaling.

## Environments

| Environment | Notes |
|-------------|-------|
| Target host | Raspberry Pi 4; total RAM must be 4G or 7G/8G. |
| Continuous integration | `ubuntu-latest` running the shell test suite. |

## Deployment procedure

1. Deploy the repository onto the host.
2. Place the PurpurMC jar in the root (or Paper/Spigot as fallback).
3. Ensure `minecraft:minecraft` ownership (`scripts/fix-permissions.sh`).
4. Install host utilities (`jq`, `yq`, `xmlstarlet`, `tmux`, `tar`, `curl`, `wget`, optionally `nbted`, `gawk`).
5. Optionally install `lighttpd`/`php-cgi` for map plugins and configure `dynmap_webchat.json` (see [`README.md`](../README.md)).
6. Apply configuration: `sh scripts/configure-all.sh`.
7. Start: `./server start`.

## Persistent state

World directories, plugin data, and `server.properties` live on the host filesystem. Backups go to `/var/backups/minecraft/<session>/`. Recovery is manual; there is no automatic restart.

## Continuous integration

`.github/workflows/tests.yml`:

```yaml
on: [push, pull_request, workflow_dispatch]
jobs.test:
  runs-on: ubuntu-latest
  steps:
    - actions/checkout@v6
    - for TEST_SCRIPT in tests/*-tests.sh; do bash "${TEST_SCRIPT}"; done
```

Requires `jq` on the runner (verified via `command -v jq`).

## Related documentation

- [quick-start.md](./quick-start.md)
- [testing.md](./testing.md)
- [concurrency-and-scheduling.md](./concurrency-and-scheduling.md)