# Documentation maintenance

## Purpose

Keep the `docs/` knowledge base accurate as the repository changes, so future agents do not have to rediscover comprehension from source.

## Ownership

| Area | Owner |
|------|-------|
| `docs/` tree | Repository maintainer |
| Root documents (`README.md`, `ARCHITECTURE.md`, `SECURITY.md`, `PRIVACY.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`) | Repository maintainer |

## When to update

| Change | Update |
|--------|--------|
| New/changed `server` command | [api-reference/INDEX.md](./api-reference/INDEX.md), [behaviour/server-lifecycle.md](./behaviour/server-lifecycle.md) |
| New operational script | [repository-structure.md](./repository-structure.md), [repository-overview.md](./repository-overview.md) |
| New common library or exported path/spec variable | [components/common-libraries.md](./components/common-libraries.md), [invariants.md](./invariants.md) |
| New provider or adapter | [components/provider-adapters.md](./components/provider-adapters.md), [integrations.md](./integrations.md) |
| New managed plugin/datapack | [flows/provisioning.md](./flows/provisioning.md), [components/plugin-management.md](./components/plugin-management.md) |
| Configuration schema change | [configuration.md](./configuration.md), [flows/configuration.md](./flows/configuration.md) |
| New host utility required | [dependencies.md](./dependencies.md), [troubleshooting.md](./troubleshooting.md) |
| New test | [testing.md](./testing.md) |
| Fixed ambiguity | [ambiguities-and-open-questions.md](./ambiguities-and-open-questions.md) |

## Conventions

- Files: kebab-case. Directories: kebab-case, plural for collections.
- Headings: sentence case.
- Cross-references: relative links from the `docs/` root, e.g. `[Architecture](./architecture.md)`.
- Code symbols: backticks with the file path or full name.
- Do not duplicate the root `ARCHITECTURE.md`, `SECURITY.md`, or other root documents; complement them.
- Do not place `ROADMAP.md`, `PRIVACY.md`, `SECURITY.md`, or `LICENSE` content under `docs/`.

## Process

1. Make the code change.
2. Identify affected `docs/` files using the table above.
3. Update those files and the [INDEX.md](./INDEX.md) catalogue if files were added.
4. Verify repository-relative links.
5. Update the "Last reviewed" field in [INDEX.md](./INDEX.md).

## Related documentation

- [INDEX.md](./INDEX.md)
- [repository-overview.md](./repository-overview.md)