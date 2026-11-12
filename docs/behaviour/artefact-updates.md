# Behaviour: artefact updates

## Detection

Each update resolves a "latest" version from the provider:

- Modrinth: first version whose `loaders` intersect the appropriate set.
- GitHub: latest non-prerelease (or latest overall when prereleases are allowed), falling back to the newest tag.
- Jenkins: version derived from the `lastSuccessfulBuild` artifact filename.
- PurpurMC: `.builds.latest`.

## Replacement

- A file already present at the target path is not re-downloaded (`download_file` no-ops; `download_plugin` skips).
- When a new version is downloaded, prior `<name>-*.jar` / `<name>-*.zip` files are removed, then the new file is placed and (for plugins) chowned and chmodded.
- Server jar downloads are placed in the repository root as `purpur-<version>-<build>.jar`.

## Idempotency and partial failure

- A provider returning no version skips that item without error.
- Zero-byte downloads are deleted.
- Because each item is independent, a failure for one item does not abort the rest of the run.

## Manual items

Several plugins are marked `TODO` or have their update lines commented out, meaning they are updated manually. Examples include BestTools, ChestSort, CommandHelper, InvUnload, and TreeAssist. See [flows/provisioning.md](../flows/provisioning.md).

## Preconditions

`update-server.sh` refuses to run while a server is detected running, preventing replacement of jars under a live JVM.

## Related documentation

- [components/plugin-management.md](../components/plugin-management.md)
- [components/provider-adapters.md](../components/provider-adapters.md)
- [flows/provisioning.md](../flows/provisioning.md)
