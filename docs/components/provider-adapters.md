# Provider adapters

**Files:** `scripts/common/github.sh`, `scripts/common/modrinth.sh`, `scripts/common/jenkins.sh`.

## Purpose

Each adapter translates one upstream distribution protocol into the uniform download contract consumed by `plugins.sh`. They depend only on `web.sh` (and shared naming helpers) and never on one another.

## Uniform contract

Each adapter exposes:

- `update_plugin_<provider> <name> <url> <asset_pattern> [allow_prereleases]` — resolve the latest version and download.
- `download_plugin_<provider>` — download a specific version.

The lower-level `download_plugin` (in `plugins.sh`) performs the actual file placement. Adapters construct the download URL and delegate.

## GitHub (`github.sh`)

- `get_latest_github_release_tag <repo_url> [allow_prereleases]`:
  1. `GET https://api.github.com/repos/<user>/<repo>/releases`.
  2. If it is a non-empty array: sort by `published_at`, take the last; when prereleases are disallowed, filter `prerelease == false` first.
  3. Otherwise fall back to `GET …/tags` and take `.[0].name`.
- `download_plugin_github` strips a leading `v` from the tag to form the version, expands the asset pattern, and builds `<repo>/releases/download/<tag>/<asset>`.
- Missing/`null` tag → no download.

## Modrinth (`modrinth.sh`)

- `get_modrinth_project_name <url>` — basename of the URL.
- `get_modrinth_project_id <name>` — `GET /v2/project/<name>` → `.id`.
- `get_latest_modrinth_version_id <project_id> <type>` — `GET /v2/project/<id>/version`, then:
  - `plugin` → first entry whose `loaders` intersect `{paper, spigot, bukkit}`.
  - `datapack` → first entry whose `loaders` intersect `{datapack}`.
  - otherwise → `.[0].id`.
- `get_modrinth_version_number`, `get_modrinth_asset_name` — from the version endpoint.
- Download URL: `https://cdn.modrinth.com/data/<project>/versions/<version>/<filename>`.
- Empty version id → no download.

The loader-filtering logic is the subject of the only automated test (see [testing.md](../testing.md)).

## Jenkins (`jenkins.sh`)

- `get_latest_jenkins_build_version <base_url> <job>`:
  1. `GET <base>/job/<job>/lastSuccessfulBuild/api/json` for `.id`.
  2. Derive a version from the first artifact filename by stripping job name, `Bukkit`/`Spigot`, `-javadoc`/`-sources`, a leading `-`, `.jar`, and a leading `v`.
  3. If the job name prefixes the result, use `build<id>` instead.
- `download_plugin_jenkins` tries, in order, artifact paths:
  1. `…/artifact/<name?>/build/libs/<asset>`
  2. `…/artifact/artifacts/<asset>`
  3. `…/artifact/target/<asset>`
  - `spark` maps to the `spark-bukkit` artifact name.
- Empty version → no download.

## Naming helpers

- `jenkins.sh` defines `transform_asset_file_name`, substituting `%pluginName%` and `%pluginVersion%`.
- `plugins.sh` defines `transform_plugin_asset_file_name`, substituting `%pluginName%`, `%pluginVersion%`, `%dataPackName%`, and `%dataPackVersion%`.

Both exist; the duplication is recorded in [ambiguities-and-open-questions.md](../ambiguities-and-open-questions.md).

## Failure semantics

All adapters short-circuit (no download, no error exit) when the resolved version is empty or `null`. Network failures surface as empty `curl -s` bodies, which the `jq` expressions treat as empty results, so a failed lookup rarely aborts a multi-item update.

## Related documentation

- [plugins.sh routing](./plugin-management.md)
- [flows/provisioning.md](../flows/provisioning.md)
- [integrations.md](../integrations.md)
