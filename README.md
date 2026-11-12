[![Donate](https://img.shields.io/badge/-%E2%99%A5%20Donate-%23ff69b4)](https://hmlendea.go.ro/funding)
[![Build Status](https://github.com/hmlendea/minecraft-server-raspberrypi/actions/workflows/tests.yml/badge.svg)](https://github.com/hmlendea/minecraft-server-raspberrypi/actions/workflows/tests.yml)
[![License](https://img.shields.io/github/license/hmlendea/minecraft-server-raspberrypi)](https://github.com/hmlendea/minecraft-server-raspberrypi/blob/master/LICENSE)

# Minecraft Server on Raspberry Pi

This repository contains a lightweight Minecraft server optimised for running on a Raspberry Pi 4. The server uses PurpurMC, a high-performance Minecraft server implementation based on PaperMC, and ships with optimised configuration files and scripts that change server and plugin settings dynamically to ensure the best possible performance on a Raspberry Pi 4.

## 📑 Table of Contents

- [Capabilities](#-capabilities)
- [Use Cases](#-use-cases)
- [Usage](#-usage)
- [Command Reference](#-command-reference)
- [Known Limitations](#-known-limitations)
- [System Requirements](#-system-requirements)
- [Installation](#-installation)
  - [Manual Installation](#manual-installation)
  - [Installation from Source](#installation-from-source)
- [Configuration](#-configuration)
  - [Configuration Files](#configuration-files)
  - [Settings](#settings)
  - [Reload Behaviour](#reload-behaviour)
  - [Network Ports](#network-ports)
- [Localisation](#-localisation)
- [Compatibility](#-compatibility)
- [Integrations](#-integrations)
- [Authentication and Authorisation](#-authentication-and-authorisation)
- [Extensibility](#-extensibility)
- [Permissions](#-permissions)
- [Privacy and Data](#-privacy-and-data)
  - [Data Locations](#data-locations)
  - [Telemetry Controls](#telemetry-controls)
- [Development](#-development)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Test](#test)
  - [Linting](#linting)
  - [Continuous Integration](#continuous-integration)
- [GitHub Actions](#-github-actions)
- [Project Structure](#-project-structure)
  - [Directories](#directories)
- [Architecture](#-architecture)
- [Deployment](#-deployment)
  - [Environments](#environments)
  - [Backup and Restore](#backup-and-restore)
- [Documentation](#-documentation)
- [API Reference](#-api-reference)
- [Troubleshooting](#-troubleshooting)
- [FAQ](#-faq)
- [Contributing](#-contributing)
- [Code of Conduct](#-code-of-conduct)
- [Acknowledgements](#-acknowledgements)
- [Security](#-security)
- [Support](#-support)
- [Project Engagement](#-project-engagement)
- [License](#-license)

## ✨ Capabilities

- Provision and run a single PurpurMC Minecraft Java server on a Raspberry Pi 4.
- Control the server lifecycle (start, stop, restart, status, console, command, and backup) through one `server` command.
- Apply performance, gameplay, and localisation settings across server and plugin configuration files idempotently.
- Download and replace the server jar, plugin jars, and datapacks from GitHub, Modrinth, Jenkins, and PurpurMC.
- Resolve and report player identities, details, and trades, and migrate player data across a username change.
- Serve rendered web maps through an optional lighttpd web server.

## 🎯 Use Cases

- **Single-instance self-hosting:** Run one Minecraft server on a Raspberry Pi 4 without containers or orchestration.
- **Deterministic provisioning:** Apply the same performance and gameplay configuration repeatedly across hosts and plugin inventories.
- **Artefact maintenance:** Keep the server, its plugins, and its datapacks current from their upstream providers.
- **Player data operations:** Resolve player identities, report details and trades, and rename players across plugins.

## 🚀 Usage

Start the server, check its status, and stop it through the `server` controller:

```bash
./server start
./server status
./server stop
```

Apply the configuration, update artefacts while the server is stopped, and inspect players:

```bash
sh scripts/configure-all.sh
sh scripts/update-server.sh
sh scripts/get-player.sh <username-or-uuid>
```

## ⌨️ Command Reference

| Command | Description |
|---------|-------------|
| `./server start` | Launch the JVM in a detached tmux session |
| `./server stop [reason]` | Graceful shutdown with an optional player notification |
| `./server status` | Report running/stopped state and a memory summary |
| `./server restart` | Stop (if running) then start |
| `./server console` | Attach to the tmux session |
| `./server command <command...>` | Send a console command and return its output |
| `./server backup` | Archive selected paths and prune to the six most recent archives |
| `sh scripts/configure-all.sh` | Apply settings then localisation |
| `sh scripts/configure-settings.sh` | Apply performance and gameplay settings |
| `sh scripts/configure-localisation.sh` | Apply locale-dependent messages |
| `sh scripts/update-server.sh` | Refresh the server jar, plugins, and datapacks |
| `sh scripts/fix-permissions.sh` | Restore `minecraft:minecraft` ownership and modes |
| `sh scripts/get-player.sh <name\|uuid>` | Report one player's details |
| `sh scripts/get-players.sh` | Report all known players |
| `sh scripts/get-player-trades.sh <name>` | Report recent ChestShop trades |
| `sh scripts/reset-end.sh` | Remove selected End region files (archived first) |
| `sh scripts/change-player-username.sh <old> <new>` | Migrate player data across plugins |

## ⚠️ Known Limitations

- Total system memory must be 4 GB, 7 GB, or 8 GB; `server start` aborts otherwise and there is no override flag.
- Downloaded artefacts are not verified against checksums or signatures.
- The toolkit performs no redaction of player personal data in reports or log searches.
- Automated test coverage is limited to provider parsing; the controller, configuration writers, and player data are verified manually.
- The toolkit supports a single server instance per host; there are no containers or orchestration.

## 🖥️ System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Operating system | Linux-based OS | N/A |
| Hardware | Raspberry Pi 4 | Raspberry Pi 4 with 7-8 GB RAM |
| Java runtime | Java 16 | Latest LTS |
| Host utilities | `jq`, `yq`, `xmlstarlet`, `tmux`, `tar`, `curl`, `wget` | Plus `nbted` and `gawk` |

## 📦 Installation

The server runtime and its plugins are distributed as a filesystem deployment rather than a packaged artefact.

### Manual Installation

1. Deploy the repository onto the host.
2. Place the PurpurMC server jar (`purpur-<version>-<build>.jar`) in the repository root. The controller also accepts `paper-<version>.jar` or `spigot-<version>.jar` as fallbacks.
3. Restore `minecraft:minecraft` ownership and modes with `scripts/fix-permissions.sh`.

#### Web Server

**Note**: The web server is only required if you want to use map plugins (such as DynMap, Pl3xMap, etc)

Install the following packages: `lighttpd`, `fcgi`, `php-cgi`

Update `/etc/lighttpd/lighttpd.conf` to:

```
server.port             = 25550
server.username         = "http"
server.groupname        = "http"
server.document-root    = "/srv/http"
server.errorlog         = "/var/log/lighttpd/error.log"
dir-listing.activate    = "enable"
index-file.names        = ( "index.html" )
mimetype.assign         = (
				".html" => "text/html",
				".txt" => "text/plain",
				".css" => "text/css",
				".js" => "application/x-javascript",
				".jpg" => "image/jpeg",
				".jpeg" => "image/jpeg",
				".gif" => "image/gif",
				".png" => "image/png",
				"" => "application/octet-stream"
			)
include "conf.d/fastcgi.conf"
```

Create the `/etc/lighttpd/conf.d/fastcgi.conf` file with:

```
server.modules += ("mod_fastcgi")
index-file.names += ("index.php")
fastcgi.server = (
    ".php" => (
        "localhost" => (
            "bin-path" => "/usr/bin/php-cgi",
            "socket" => "/tmp/php-fastcgi.sock",
            "broken-scriptfilename" => "enable",
            "max-procs" => "4",
            "bin-environment" => (
                "PHP_FCGI_CHILDREN" => "1"
            )
        )
    )
)
```

**DynMap**

Next we need to allow the web server to send chat messages to the Minecraft server by running the following commands:

```
touch /srv/http/standalone/dynmap_webchat.json
chown http /srv/http/standalone/dynmap_webchat.json
```

### Installation from Source

Deploy the repository onto the target host and follow the manual installation steps above:

```bash
git clone https://github.com/hmlendea/minecraft-server-raspberrypi.git
cd minecraft-server-raspberrypi
```

## ⚙️ Configuration

Configuration is declarative and mutated in place: human-maintained files are read, edited at a dotted key path, and written back by a format-aware setter. Host-local files such as `server.properties` are read at load for values such as `online-mode` and `level-name`. Updating or customising those configurations should be done through the `scripts/configure-settings.sh` and `scripts/configure-localisation.sh` scripts, normally invoked together by `scripts/configure-all.sh`.

### Configuration Files

| File | Scope | Purpose |
|------|-------|---------|
| `scripts/common/specs.sh` | Server-wide | Specification constants derived from hardware and `server.properties` |
| `server.properties` | Server runtime | Host-specific runtime settings; not version controlled |
| `bukkit.yml`, `spigot.yml`, `purpur.yml` | Server runtime | Version-controlled server defaults, mutated in place |
| `config/paper-global.yml`, `config/paper-world-defaults.yml` | Paper runtime | Version-controlled global and per-world defaults |
| `plugins/<name>/...` | Plugin | Per-plugin configuration, mutated then reloaded |

### Settings

The subsequent settings are recognised:
| Section | Key | Type | Default | Required | Description |
|---------|-----|------|---------|----------|-------------|
| `specs.sh` | `MINECRAFT_VERSION` | `string` | `26.3` | Yes | Target Minecraft version used by `scripts/update-server.sh` |
| `specs.sh` | `LOCALE` | `string` | `ro` | Yes | Message language (`ro` or `en`) |
| `specs.sh` | `LOCALE_FALLBACK` | `string` | `en` | No | Fallback message language |
| `specs.sh` | `VIEW_DISTANCE` | `integer` | `8` | No | Chunk view distance, clamped to `VIEW_DISTANCE_MIN`-`VIEW_DISTANCE_MAX` |
| `specs.sh` | `SIMULATION_DISTANCE` | `integer` | `6` | No | Chunk simulation distance, clamped to `SIMULATION_DISTANCE_MIN`-`SIMULATION_DISTANCE_MAX` and never above `VIEW_DISTANCE` |
| `specs.sh` | `PLAYERS_MAX` | `integer` | `20` | No | Maximum player count used to size chunk and spawn budgets |
| `specs.sh` | `USE_TELEMETRY` | `boolean` | `false` | No | Enables optional plugin telemetry |
| `specs.sh` | `CHECK_PLUGINS_FOR_UPDATES` | `boolean` | `false` | No | Enables plugin update checks |
| `specs.sh` | `SKIP_PLUGIN_UPDATE_CHECKS` | `boolean` | `true` | No | Skips plugin update checks |

### Reload Behaviour

The scripts mutate the configuration files on disk. Plugin configuration is reloaded through each plugin's own reload command, while changes to server-level files such as `bukkit.yml`, `spigot.yml`, `purpur.yml`, and `server.properties` take effect on the next server restart.

### Network Ports

| Port | Protocol | Direction | Purpose | Required |
|------|----------|-----------|---------|----------|
| `25550` | HTTP | Inbound | Optional lighttpd web map server | No |

The Minecraft game port is configured in `server.properties`, which is host-specific and not version controlled.

## 🌍 Localisation

The toolkit applies locale-dependent server and plugin messages through `scripts/configure-localisation.sh`, which selects a message branch from `LOCALE` in `scripts/common/specs.sh`.

| Language | Locale | Status |
|----------|--------|--------|
| Romanian | `ro` | Default |
| English | `en` | Fallback |

## 🧩 Compatibility

| Component | Supported Versions | Notes |
|-----------|--------------------|-------|
| Host operating system | Linux-based OS | Bash, `tmux`, and the POSIX utilities are required |
| Raspberry Pi hardware | Raspberry Pi 4 with 4 GB, 7 GB, or 8 GB total memory | `server start` aborts on any other total memory |
| Java runtime | Java 16 or later | Runs the PurpurMC server jar |
| Server software | PurpurMC; Paper and Spigot jars accepted as fallbacks | Placed in the repository root |
| Continuous integration runner | `ubuntu-latest` | Runs the shell test suite only |

## 🔌 Integrations

| Integration | Compatibility | Purpose | Required |
|-------------|---------------|---------|----------|
| PurpurMC API | Public HTTPS API | Server jar build discovery and download | Yes |
| Modrinth v2 API | Public HTTPS API | Plugin and datapack download | Yes |
| GitHub API | Public HTTPS API | Plugin release and asset download | Optional |
| Jenkins | Public HTTPS API | Plugin artefact download | Optional |
| tmux | Local process | Detached server session and console capture | Yes |
| lighttpd | HTTP on port `25550` | Serves rendered web maps | Optional |
| DiscordSRV | Plugin | Discord chat bridge | Optional |
| bStats | Plugin | Anonymous plugin telemetry, disabled by default | Optional |

## 🔐 Authentication and Authorisation

The toolkit exposes no network authentication. Authorisation is local: the `server` controller and the operational scripts must run as, or be able to elevate to, the `minecraft` user. `run_with_privileges` centralises this decision, and the controller aborts with exit 21 when it cannot assume the `minecraft` user.

## 🧱 Extensibility

The toolkit exposes two documented extension points for operators and maintainers, recorded in `ARCHITECTURE.md`.

| Extension Point | Contract | Purpose |
|-----------------|----------|---------|
| Managed plugin or datapack | An `update_plugin` entry in `scripts/update-server.sh`, guarded by `configure_plugin` | Adds a new plugin or datapack to provisioning and configuration |
| Configuration script | A script under `scripts/` that sources `scripts/common/paths.sh` and the libraries it needs | Applies additional deterministic configuration |

## 🔑 Permissions

| Permission | Required | Purpose |
|------------|----------|---------|
| Assume the `minecraft` user (`sudo -u minecraft`) | Yes | Process control, ownership, and runtime operations |
| Own or have write access to the server files as `minecraft` | Yes | Start, stop, and configuration writes |
| Bind HTTP port `25550` | No | Serve rendered web maps through lighttpd |
| Install `lighttpd`, `php-cgi`, and `fcgi` packages | No | Optional web map server |

## 🛡️ Privacy and Data

Minecraft Server on Raspberry Pi stores player data on the operator's own host and sends nothing to the project maintainers; optional plugin telemetry and update checks are disabled by default.

For the detailed description of how the application handles privacy and personal data, see the [Privacy Statement](./PRIVACY.md).

Player data is produced and stored by the running server and its plugins on the operator's host.

| Data | Purpose | Storage | Retention | Optional |
|------|---------|---------|-----------|----------|
| Player usernames and account identifiers | Authentication, permissions, and world state | `usercache.json`, `whitelist.json`, `ops.json`, world player data | Until the operator deletes it | No |
| Player world state | Game progression | `world/`, `world_nether/`, `world_the_end/` | Until the operator deletes it | No |
| Plugin data (chat, shops, regions, skins, Discord links) | Plugin features | `plugins/<name>/` | Until the operator deletes it | No |
| Server logs | Operation and diagnosis | `logs/` | Rotated by the server runtime | No |
| Rendered web map output | Public map pages | `webmap/` | Until the operator deletes it | Yes |
| Plugin telemetry | Anonymous plugin statistics | bStats service | Managed by bStats | Yes |
| Backups | Recovery | `/var/backups/minecraft/<session>/` | Most recent six archives | Yes |

### Data Locations

| Platform or Scope | Location | Contents |
|-------------------|----------|----------|
| World | `world/`, `world_nether/`, `world_the_end/` | Player data, statistics, advancements, region files |
| Plugin data | `plugins/` | Player records, chat, shop, region, and skin data |
| Logs | `logs/` | Connection, command, and plugin activity |
| Web map | `webmap/` | Rendered map tiles and skin images |
| Backups | `/var/backups/minecraft/<session>/` | Timestamped archives of world, plugin, and player data |

### Telemetry Controls

Optional plugin telemetry is controlled by `USE_TELEMETRY` in `scripts/common/specs.sh`; it is disabled by default and can be re-enabled or disabled and reapplied with `scripts/configure-settings.sh`. Optional plugin update checks are controlled by `CHECK_PLUGINS_FOR_UPDATES` and `SKIP_PLUGIN_UPDATE_CHECKS` in the same file.

## 🛠️ Development

### Requirements

- A Raspberry Pi 4 with a Linux-based OS and Java 16 or later.
- The host utilities required by the scripts: `jq`, `yq`, `xmlstarlet`, `tmux`, `tar`, `curl`, and `wget`. `nbted` is additionally required for player-data queries and `gawk` for `server status`.
- `shellcheck` for linting.

### Setup

```bash
git clone https://github.com/hmlendea/minecraft-server-raspberrypi.git
cd minecraft-server-raspberrypi
sudo apt-get install -y jq yq xmlstarlet tmux tar curl wget
```

### Test

```bash
for TEST_SCRIPT in tests/*-tests.sh; do bash "${TEST_SCRIPT}"; done
```

### Linting

```bash
shellcheck scripts/*.sh scripts/common/*.sh tests/*.sh server
```

### Continuous Integration

The `Tests` workflow runs every `tests/*-tests.sh` script on `push`, `pull_request`, and `workflow_dispatch`. It requires `jq` on the runner and can be reproduced locally with the test command above.

## ⚙️ GitHub Actions

| Workflow | Purpose | What it does |
|----------|---------|--------------|
| [ Tests ](https://github.com/hmlendea/minecraft-server-raspberrypi/blob/master/.github/workflows/tests.yml) | Validate the shell test suite | Checks out the repository, verifies `jq` is available, and runs every `tests/*-tests.sh` script on `push`, `pull_request`, and `workflow_dispatch` |

## 🗂️ Project Structure

The repository is a flat shell toolkit: an operator entrypoint at the root, operational scripts and shared libraries under `scripts/`, declarative server configuration at the root and under `config/`, and verification scripts under `tests/`.

### Directories

| Directory | Purpose |
|-----------|---------|
| `scripts/` | Operator-facing procedures such as configuration, updates, and player reporting |
| `scripts/common/` | Sourced-only shared libraries (paths, specifications, configuration, providers, players) |
| `config/` | Paper global and per-world default configuration |
| `tests/` | Isolated provider-parsing verification scripts |
| `docs/` | Documentation knowledge base |
| `.github/workflows/` | Continuous-integration workflows |

## 🏗️ Architecture

Minecraft Server on Raspberry Pi is a shell-based operations toolkit that provisions and runs a single PurpurMC Java process on a Raspberry Pi 4.

See the [Architecture Documentation](./ARCHITECTURE.md) for the system context, principal components, runtime flows, ownership boundaries, dependencies, constraints, and extension points.

## 🚢 Deployment

Deployment is a filesystem copy onto a single self-hosted Raspberry Pi 4 running a Linux-based OS; there is no compile step, container, or orchestration.

1. Deploy the repository onto the host.
2. Place the PurpurMC jar in the repository root, or a Paper/Spigot fallback.
3. Restore `minecraft:minecraft` ownership with `scripts/fix-permissions.sh`.
4. Install the host utilities (`jq`, `yq`, `xmlstarlet`, `tmux`, `tar`, `curl`, `wget`, optionally `nbted` and `gawk`).
5. Optionally install `lighttpd` and `php-cgi` for map plugins (see Manual Installation).
6. Apply configuration with `sh scripts/configure-all.sh`.
7. Start the server with `./server start`.

### Environments

| Environment | Purpose | Deployment Method |
|-------------|---------|-------------------|
| Target host | Single self-hosted server instance | Filesystem copy |
| Continuous integration | Shell test suite | GitHub Actions on `ubuntu-latest` |

### Backup and Restore

`./server backup` archives the world directories, plugin data, `server.properties`, and player lists to `/var/backups/minecraft/<session>/` as timestamped `tar.gz` files, keeping the six most recent. When the server is running, `save-off` and `save-all` precede the archive. Recovery is manual: extract a backup archive back onto the host.

## 📚 Documentation

Detailed documentation of the toolkit, its components, and its operational flows is maintained under [`docs/`](./docs/INDEX.md).

| Resource | Description |
|----------|-------------|
| [Documentation index](./docs/INDEX.md) | Master index and navigation for the documentation knowledge base |
| [Repository overview](./docs/repository-overview.md) | Purpose, scope, entry points, and intended audience |
| [Repository structure](./docs/repository-structure.md) | Source tree layout and module organisation |
| [Architecture](./docs/architecture.md) | Layered architecture detail that complements `ARCHITECTURE.md` |
| [Quick start](./docs/quick-start.md) | Prerequisites, first run, and everyday operations |
| [Components](./docs/components/) | Deep dives into the controller, common libraries, configuration writers, provider adapters, plugin management, player data, messaging, and region settings |
| [Flows](./docs/flows/) | End-to-end flows for startup, shutdown and backup, provisioning, configuration, and username migration |
| [Behaviour](./docs/behaviour/) | Operator-visible lifecycle, configuration provisioning, player management, and artefact update behaviour |
| [Command interface reference](./docs/api-reference/INDEX.md) | Operator commands for the `server` controller and the operational scripts |
| [Configuration](./docs/configuration.md) | Configuration sources, format dispatch, and hardware-derived values |
| [Data model](./docs/data-model.md) | Player, region, plugin, and datapack entities |
| [State and persistence](./docs/state-and-persistence.md) | Stores, derived caches, backups, and migrations |
| [Security](./docs/security.md) | Trust boundaries, privilege handling, and data protection controls |
| [Testing](./docs/testing.md) | Test strategy, harness technique, and coverage gaps |
| [Change guide](./docs/change-guide.md) | How to modify common areas safely |
| [Troubleshooting](./docs/troubleshooting.md) | Common issues and their resolutions |
| [FAQ](./docs/faq.md) | Frequently asked questions |
| [Open questions](./docs/ambiguities-and-open-questions.md) | Known gaps, latent defects, and unresolved items |

## 🌐 API Reference

The toolkit exposes no HTTP API. Its public interface is the operator command interface, documented in the [Command Interface Reference](./docs/api-reference/INDEX.md).

## 🩺 Troubleshooting

| Symptom | Probable Cause | Resolution |
|---------|----------------|------------|
| `server start` aborts with "<N>G total RAM is not supported" | Total system memory is not 4 GB, 7 GB, or 8 GB | Run on a supported Pi, or adjust the RAM branch in `server` deliberately; there is no override flag |
| `server start` prints "no permission to run commands as minecraft user" (exit 21) | The controller could not assume the `minecraft` user | Run as root, as `minecraft`, or with working passwordless `sudo -u minecraft` |
| `server start` prints "failed" and dumps the console buffer | The session died during startup, such as no server jar, a Java version mismatch, or a configuration error | Read the dumped buffer and confirm a `purpur-*.jar` exists and Java 16+ is installed |
| `configure-*` reports "The 'jq'/'yq'/'xmlstarlet' utility must be installed" (exit 400) | A required host utility is missing | Install the missing utility; `config.sh` checks `/usr/bin/jq`, `/usr/bin/xmlstarlet`, and `/usr/bin/yq` |
| `update-server.sh` prints "The server needs to be stopped to update the plugins!" (exit 1) | A running server process was detected | Stop the server, then update |
| Backup reports "The tar binaries are needed for a backup" (exit 11) | `tar` is not installed | Install `tar` |
| Player location or spawn prints empty | `nbted` is not installed, or the playerdata file is missing | Install `nbted` and verify `world/players/data/<uuid>.dat` |
| `server status` memory summary fails | `gawk` is not installed | Install `gawk` |

See the [Troubleshooting guide](./docs/troubleshooting.md) for the full list of diagnostic procedures and resolutions.

## ❓ FAQ

See the [Frequently Asked Questions](./docs/faq.md) for responses to frequently raised inquiries.

## 🤝 Contributing

You are welcome to submit any suggestion, feedback, or modification to this project.

When doing so, please:
- Preserve the existing public contract unless a breaking change is intentional
- Submit focused pull requests that conform to the existing code style
- Maintain your branch synchronised with `master`
- Revise the documentation when functionality changes
- Properly test all modifications, including edge cases and error conditions
- Include tests for additional or modified functionality
- Raise a new [issue](https://github.com/hmlendea/minecraft-server-raspberrypi/issues) for problems or suggestions

See the [Contributing Guidelines](./CONTRIBUTING.md) for details on how to report issues, suggest enhancements, and submit changes.

## 📜 Code of Conduct

See the [Code of Conduct](./CODE_OF_CONDUCT.md) for the standards of conduct expected in all project spaces.

## 🙏 Acknowledgements

- [PurpurMC](https://purpurmc.org/) and [PaperMC](https://papermc.io/) provide the high-performance server software that this toolkit deploys.
- The Bukkit, Spigot, and Paper plugin ecosystem supplies the plugins provisioned by the configuration scripts.

## 🔒 Security

Minecraft Server on Raspberry Pi distributes configuration files and shell scripts for self-hosted servers and handles vulnerabilities through coordinated disclosure.

For information on reporting security vulnerabilities, see the [Security Policy](./SECURITY.md).

## 💬 Support

For support, please [open an issue](https://github.com/hmlendea/minecraft-server-raspberrypi/issues).

## 💝 Project Engagement

Discovered a problem with Minecraft Server on Raspberry Pi or have a suggestion for it? [Open an issue](https://github.com/hmlendea/minecraft-server-raspberrypi/issues)!

If you find this project useful, consider [funding it](https://hmlendea.go.ro/funding) or starring ⭐️ it on GitHub!

[![Donate](https://raw.githubusercontent.com/hmlendea/readme-assets/master/donate_generic.png)](https://hmlendea.go.ro/funding)

## 📄 License

This project is being distributed under the `GNU General Public License v3.0`.
See [LICENSE](./LICENSE) for additional information.
