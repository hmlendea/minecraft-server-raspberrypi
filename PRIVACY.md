# Privacy and Personal Data

This document describes how the Minecraft server on Raspberry Pi project and the servers built from it handle personal data, as verified on 12 November 2026. The repository contains configuration files and shell scripts for provisioning and operating a self-hosted PurpurMC Minecraft server; the personal data that exists is produced by the running server and its plugins on the operator's own host, not by the repository maintainers.

## 📑 Table of Contents

- [What This Document Covers](#-what-this-document-covers)
- [Self-Hosted Deployments](#-self-hosted-deployments)
- [Data We Handle](#-data-we-handle)
  - [Data Provided to the Application](#data-provided-to-the-application)
  - [Data Generated or Collected by the Application](#data-generated-or-collected-by-the-application)
  - [Data Received from Integrations](#data-received-from-integrations)
- [Processing and Use](#-processing-and-use)
- [Storage, Retention, and Deletion](#️-storage-retention-and-deletion)
- [External Processing and Integrations](#-external-processing-and-integrations)
- [User Controls and Requests](#️-user-controls-and-requests)
- [International Transfers](#-international-transfers)
- [Data Protection and Security](#️-data-protection-and-security)
- [Document Changes](#-document-changes)
- [Contact](#-contact)

## 🔎 What This Document Covers

This document describes how Minecraft Server on Raspberry Pi at https://github.com/hmlendea/minecraft-server-raspberrypi manages personal data. It covers the application conduct and verified integrations described below. Where the software is self-hosted, the instance operator may have separate responsibilities described below.

## 🏠 Self-Hosted Deployments

This document covers both the project maintainers and self-hosted instance operators. The maintainers publish configuration and operational scripts; they do not operate a server on behalf of users. Each self-hosted instance operator controls their instance's configuration, local storage, logs, backups, access controls, preservation, and request handling unless the project directly controls those functions.

No data is sent from a self-hosted instance to the project maintainers. The scripts contact external services only when an operator invokes a maintenance script or when a configured plugin is enabled: the distribution providers used by `update-server.sh` receive ordinary HTTP requests and no personal data, and optional plugin telemetry and update checks are disabled by default. Operators can deactivate optional processes by setting `USE_TELEMETRY`, `CHECK_PLUGINS_FOR_UPDATES`, and `SKIP_PLUGIN_UPDATE_CHECKS` in `scripts/common/specs.sh`, and by not installing or removing the corresponding plugins.

## 📥 Data We Handle

### Data Provided to the Application

- Player usernames and account identifiers, supplied by players when they connect and recorded by the server in `usercache.json`, `whitelist.json`, `ops.json`, and world player data.
- Account credentials supplied to the AuthMe plugin at registration and login. The repository's scripts configure AuthMe messaging only and never read or store raw passwords.
- In-game content supplied by players, including chat messages, TradeShop listings and balances, WorldGuard regions, and Discord account links recorded in `plugins/DiscordSRV/accounts.aof`.

### Data Generated or Collected by the Application

- Server logs under `logs/`, which record connection events, operator commands, and plugin activity that may include player identifiers.
- Player world state under `world/`, `world_nether/`, and `world_the_end/`, comprising `playerdata`, `stats`, and `advancements` keyed by player account identifier.
- Plugin data directories such as `plugins/Essentials/userdata`, `plugins/TradeShop/Data/Players`, `plugins/SkinsRestorer`, and `plugins/WorldGuard/worlds`, plus a local lookup cache at `cache/players.json` that stores usernames and account identifiers.
- Optional rendered web map output under `webmap/`, which includes map tiles and skin images derived from player content.
- Optional anonymous plugin telemetry emitted only when `USE_TELEMETRY` is enabled; it is disabled by default.

### Data Received from Integrations

- Discord account links and relayed chat received from the DiscordSRV plugin boundary.
- Vote records received from voting sites through the configured voting plugins.
- Player skin data retrieved from the Mojang skin services through SkinsRestorer.
- Public distribution metadata received from the PurpurMC API, Modrinth, GitHub, and Jenkins-style build servers; this metadata contains no personal data.

## 🧭 Processing and Use

The application processes the data described above for these verified functions:
- Player authentication — player usernames and account credentials provided to AuthMe
- Chat and event relay to Discord — chat messages and player usernames through DiscordSRV
- World map rendering — player positions and skins produced into `webmap/`
- Player lookup and account migration — player usernames and account identifiers in `cache/players.json`, world data, and plugin data
- Server operation and diagnosis — server logs and player world state
- Optional anonymous telemetry — aggregate plugin statistics when `USE_TELEMETRY` is enabled
- Optional plugin update checks — public distribution metadata when `CHECK_PLUGINS_FOR_UPDATES` is enabled

## 🗄️ Storage, Retention, and Deletion

All data is stored on the operator's host filesystem: player world data under the world directories, configuration and player records in the repository root, plugin data under `plugins/`, logs under `logs/`, rendered map output under `webmap/`, and the local lookup cache at `cache/players.json`. Backups created by the server controller are written as archives under `/var/backups/minecraft/`, where only the six most recent archives are retained; older archives are removed by the backup procedure. Server logs are rotated by the server runtime. The project maintainers do not control or access this storage; each self-hosted instance operator controls storage, deletion, and backups, and is responsible for honouring any applicable data requests for their instance. The repository does not implement an automated personal-data deletion procedure; deletion is performed by the operator on the files and archives described above.

## 🔗 External Processing and Integrations

The following verified integrations process or receive data when enabled on a self-hosted instance. A deployment with none of these plugins installed has no built-in external data transfer.

| Service or integration | Purpose | Data involved | Configuration or documentation |
|-----------------------|---------|---------------|--------------------------------|
| DiscordSRV and Discord | Relay in-game chat and events to Discord and link accounts | Chat messages, player usernames, account links | Configured in `scripts/configure-localisation.sh`; links stored in `plugins/DiscordSRV/accounts.aof` |
| bStats | Optional anonymous plugin telemetry | Aggregate plugin statistics | Toggled by `USE_TELEMETRY` in `scripts/common/specs.sh` and applied in `scripts/configure-settings.sh` |
| SkinsRestorer and Mojang skin services | Retrieve player skins | Player usernames and skin data | Configured in `scripts/configure-settings.sh` |
| Voting plugins | Receive votes from voting sites | Vote records and player usernames | Configured in `scripts/configure-settings.sh` |
| PurpurMC API | Download server builds | None (public build metadata) | Used by `scripts/update-server.sh` |
| Modrinth, GitHub, and Jenkins-style build servers | Download plugins and datapacks | None (public release metadata) | Used by `scripts/common/modrinth.sh`, `scripts/common/github.sh`, and `scripts/common/jenkins.sh` |
| lighttpd web server | Serve rendered map pages and tiles | Rendered `webmap/` output, including player positions and skins | Documented in `README.md` |

## ⚙️ User Controls and Requests

The following documented controls or request procedures are available:
- Disable optional plugin telemetry — set `USE_TELEMETRY` to `false` in `scripts/common/specs.sh` and reapply `scripts/configure-settings.sh`
- Disable plugin update checks — set `CHECK_PLUGINS_FOR_UPDATES` and `SKIP_PLUGIN_UPDATE_CHECKS` in `scripts/common/specs.sh`
- Disable rendered web map output — do not install the map plugins, and remove the `webmap/` directory and its web server configuration
- Migrate a player's stored data to a new username — run `scripts/change-player-username.sh` with the old and new usernames

## 🌍 International Transfers

Deployment location is controlled by the instance operator, and the repository itself transfers no data. When optional integrations are enabled, data may be transferred to third-party providers that operate internationally, including Discord, the bStats telemetry service, Mojang skin services, and voting sites. Operators determine which of these services are enabled and are responsible for the resulting transfers.

## 🛡️ Data Protection and Security

The repository applies the following safeguard, verified in the scripts: operational scripts require the `minecraft` user or equivalent privileges, and the server controller validates this identity before proceeding. Sensitive and mutable files, including `server.properties`, `ops.json`, `whitelist.json`, `banned-players.json`, `banned-ips.json`, `eula.txt`, world directories, plugin directories, and backup archives, are excluded from version control. Optional telemetry, timings, and update checks are disabled by default. For self-hosted deployments, the operator is responsible for host updates, secret protection, filesystem access controls, backups, network exposure, and log protection. No claim of absolute security is made.

The original maintainers are not responsible for changes, modifications, or privacy issues introduced by downstream forks.

## 🔄 Document Changes

Update this document when application data processes, storage, integrations, or deployment responsibilities change. The current version is published at [PRIVACY.md](./PRIVACY.md).

## 📬 Contact

For questions about application data handling, contact the project maintainers. For a self-hosted instance, contact the instance operator, unless the project explicitly manages the request. Include the server name, the affected player username, and the data process involved; do not send passwords, access tokens, or other secrets.
