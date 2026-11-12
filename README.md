[![Donate](https://img.shields.io/badge/-%E2%99%A5%20Donate-%23ff69b4)](https://hmlendea.go.ro/funding)

# About

This repository contains a lightweight Minecraft server optimized for running on a Raspberry Pi 4. The server uses PurpurMC, a high-performance Minecraft server implementation that is based on the popular PaperMC software.

The server is pre-configured with optimized settings files and scripts for dynamically changing server and plugin settings to ensure the best possible performance on a Raspberry Pi 4.

## Prerequisites

Before you can use this server, you'll need to make sure you have the following prerequisites:

- A Raspberry Pi 4
- A compatible power supply
- An SD card with a Linux-based OS installed
- Java 16 or later installed on your Raspberry Pi

# Installation

## Web server

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

### DynMap

Next we need to allow the web server to send chat messages to the Minecraft server by running the following commands:

```
touch /srv/http/standalone/dynmap_webchat.json
chown http /srv/http/standalone/dynmap_webchat.json
```

## Configuration

The server is pre-configured with optimized settings files and scripts for dynamically changing server and plugin settings. However, if you need to customize the server settings, you can do so by editing the following files:

Updating or customising those configurations should be done through the `scripts/configure-settings.sh` script.

## Usage

This server is designed to be easy to use and maintain. To start the server, simply run the following command:
```bash
./start.sh
```

This will start the server with the pre-configured settings and Java flags. To stop the server, simply use `Ctrl+C` in the terminal.

## 🏗️ Architecture

This server is a shell-based operations toolkit that provisions and runs a single PurpurMC Java process on a Raspberry Pi 4.

See the [Architecture Documentation](ARCHITECTURE.md) for the system context, principal components, runtime flows, ownership boundaries, dependencies, constraints, and extension points.

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
| Backups | Recovery | `/var/backups/minecraft/` | Most recent six archives | Yes |

### Data Locations

| Platform or Scope | Location | Contents |
|-------------------|----------|----------|
| World | `world/`, `world_nether/`, `world_the_end/` | Player data, statistics, advancements, region files |
| Plugin data | `plugins/` | Player records, chat, shop, region, and skin data |
| Logs | `logs/` | Connection, command, and plugin activity |
| Web map | `webmap/` | Rendered map tiles and skin images |
| Backups | `/var/backups/minecraft/` | Timestamped archives of world, plugin, and player data |

### Telemetry Controls

Optional plugin telemetry is controlled by `USE_TELEMETRY` in `scripts/common/specs.sh`; it is disabled by default and can be re-enabled or disabled and reapplied with `scripts/configure-settings.sh`. Optional plugin update checks are controlled by `CHECK_PLUGINS_FOR_UPDATES` and `SKIP_PLUGIN_UPDATE_CHECKS` in the same file.

## 🤝 Contributing

You are welcome to submit any suggestion, feedback, or modification to this project.

When doing so, please:
- Maintain cross-platform compatibility
- Submit focused pull requests that conform to the existing code style
- Maintain your branch synchronised with `master`
- Revise the documentation when functionality changes
- Properly test all modifications, including edge cases and error conditions

See the [Contributing Guidelines](./CONTRIBUTING.md) for details on how to report issues, suggest enhancements, and submit changes.

## 📜 Code of Conduct

See the [Code of Conduct](./CODE_OF_CONDUCT.md) for the standards of conduct expected in all project spaces.

## 🔒 Security

Minecraft Server on Raspberry Pi distributes configuration files and shell scripts for self-hosted servers and handles vulnerabilities through coordinated disclosure.

For information on reporting security vulnerabilities, see the [Security Policy](./SECURITY.md).
