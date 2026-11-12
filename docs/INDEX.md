# Documentation index

Master index for the Minecraft Server on Raspberry Pi documentation knowledge base.

## Repository summary

This repository is a shell-based provisioning and operations toolkit that installs, configures, and runs a single PurpurMC (Paper fork) Minecraft Java server optimised for a Raspberry Pi 4. It owns the operating procedures (`server start|stop|status|restart|console|command|backup`), the declarative configuration of the server and its plugins, the automated acquisition of server jars, plugin jars, and datapacks from upstream providers, and the deterministic localisation and settings scripts applied to those artefacts. The hosted Minecraft runtime itself, and all plugin-internal behaviour, are external to the repository.

## Root document map

The repository root holds the canonical project documents. `docs/` complements them and never duplicates them.

| Document | Purpose |
|----------|---------|
| [`README.md`](../README.md) | Operator prerequisites, installation, web server setup, usage. |
| [`ARCHITECTURE.md`](../ARCHITECTURE.md) | System context, principal components, runtime flows, ownership boundaries, constraints, extension points. |
| [`CONTRIBUTING.md`](../CONTRIBUTING.md) | How to report issues, suggest enhancements, and submit changes. |
| [`CODE_OF_CONDUCT.md`](../CODE_OF_CONDUCT.md) | Standards of conduct in project spaces. |
| [`SECURITY.md`](../SECURITY.md) | Vulnerability disclosure policy. |
| [`PRIVACY.md`](../PRIVACY.md) | Privacy statement and data handling. |
| [`LICENSE`](../LICENSE) | Licensing terms. |

## Documentation catalogue

### Orientation

- [repository-overview.md](./repository-overview.md) — purpose, scope, entry points, and audience.
- [repository-structure.md](./repository-structure.md) — source tree layout and module organisation.
- [quick-start.md](./quick-start.md) — getting started for newcomers.
- [architecture.md](./architecture.md) — layered architecture detail that complements the root `ARCHITECTURE.md`.

### Components

- [components/server-controller.md](./components/server-controller.md) — the root `server` entrypoint and process control.
- [components/common-libraries.md](./components/common-libraries.md) — the shared `scripts/common/` vocabulary and primitives.
- [components/configuration-writers.md](./components/configuration-writers.md) — format-aware configuration mutation.
- [components/provider-adapters.md](./components/provider-adapters.md) — GitHub, Modrinth, and Jenkins distribution adapters.
- [components/plugin-management.md](./components/plugin-management.md) — plugin/datapack detection, configuration, download, and update routing.
- [components/player-data.md](./components/player-data.md) — player identity resolution, cache, and reporting.
- [components/messaging-and-localisation.md](./components/messaging-and-localisation.md) — colour, message, and locale vocabulary.
- [components/worldguard-regions.md](./components/worldguard-regions.md) — WorldGuard region settings and generated messages.

### Flows

- [flows/startup.md](./flows/startup.md) — `server start` end-to-end.
- [flows/shutdown-and-backup.md](./flows/shutdown-and-backup.md) — graceful stop and archive creation.
- [flows/provisioning.md](./flows/provisioning.md) — `update-server.sh` artefact replacement.
- [flows/configuration.md](./flows/configuration.md) — `configure-all.sh` settings and localisation application.
- [flows/username-migration.md](./flows/username-migration.md) — `change-player-username.sh` data migration.

### Behaviour

- [behaviour/server-lifecycle.md](./behaviour/server-lifecycle.md) — operator lifecycle semantics.
- [behaviour/configuration-provisioning.md](./behaviour/configuration-provisioning.md) — idempotent configuration behaviour.
- [behaviour/player-management.md](./behaviour/player-management.md) — query and migration behaviour.
- [behaviour/artefact-updates.md](./behaviour/artefact-updates.md) — update detection and replacement behaviour.

### Reference

- [api-reference/INDEX.md](./api-reference/INDEX.md) — operator command interface reference.
- [configuration.md](./configuration.md) — configuration schema, sources, precedence.
- [data-model.md](./data-model.md) — entities, files, and relationships.
- [state-and-persistence.md](./state-and-persistence.md) — stores, caches, and backups.
- [dependencies.md](./dependencies.md) — external and internal dependencies.
- [integrations.md](./integrations.md) — external system integrations.
- [error-handling.md](./error-handling.md) — error taxonomy and recovery.
- [logging.md](./logging.md) — output, diagnostics, and sensitive log handling.
- [security.md](./security.md) — security model and trust boundaries (complements root `SECURITY.md`).
- [concurrency-and-scheduling.md](./concurrency-and-scheduling.md) — process model, FIFO serialisation, background jobs.
- [invariants.md](./invariants.md) — system-wide invariants and contracts.

### Operations

- [build-and-deployment.md](./build-and-deployment.md) — deployment model and environments.
- [testing.md](./testing.md) — test strategy and coverage.
- [change-guide.md](./change-guide.md) — how to modify common areas safely.
- [troubleshooting.md](./troubleshooting.md) — common issues and solutions.
- [faq.md](./faq.md) — frequently asked questions.
- [design-decisions.md](./design-decisions.md) — key design choices and rationale.
- [ambiguities-and-open-questions.md](./ambiguities-and-open-questions.md) — unresolved items and known gaps.
- [documentation-maintenance.md](./documentation-maintenance.md) — keeping these documents current.

## Navigation aids

- **Start here (newcomers):** [repository-overview.md](./repository-overview.md) → [quick-start.md](./quick-start.md) → [flows/startup.md](./flows/startup.md).
- **Deep dive (component owners):** [architecture.md](./architecture.md) → [components/common-libraries.md](./components/common-libraries.md) → [configuration.md](./configuration.md).
- **Flows (debuggers):** [flows/](./flows/) → [troubleshooting.md](./troubleshooting.md) → [error-handling.md](./error-handling.md).

## Maintenance metadata

| Field | Value |
|-------|-------|
| Last reviewed | 2026-11-12 |
| Owner | Repository maintainer |
| Coverage status | Full toolkit coverage; plugin-internal behaviour documented as opaque by design. |
