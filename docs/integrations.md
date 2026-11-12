# Integrations

## Upstream distribution

| Integration | Direction | Endpoint | Consumer | Failure semantics |
|-------------|-----------|----------|----------|-------------------|
| PurpurMC API | Outbound | `https://api.purpurmc.org/v2/purpur/<version>` | `update-server.sh` | Empty build → skip |
| Modrinth v2 | Outbound | `api.modrinth.com/v2/project/...`, `cdn.modrinth.com/data/...` | `modrinth.sh` | Empty version → skip |
| GitHub API | Outbound | `api.github.com/repos/<u>/<r>/releases`, `/tags` | `github.sh` | `null`/empty tag → skip |
| Jenkins | Outbound | `<base>/job/<job>/lastSuccessfulBuild/api/json` | `jenkins.sh` | Empty version → skip |
| Modrinth CDN | Outbound | `cdn.modrinth.com/...` | `web.sh` | Zero-byte → delete |
| GitHub release assets | Outbound | `<repo>/releases/download/<tag>/<asset>` | `web.sh` | Zero-byte → delete |

All provider traffic is HTTPS to public endpoints with no embedded credentials.

## Host integrations

| Integration | Direction | Contract | Owner |
|-------------|-----------|----------|-------|
| tmux | Local | Session named after repo dir; `send-keys`, `pipe-pane`, `wait-for` | `server` |
| JVM console | Local | Command dispatch and output capture | `server` |
| lighttpd | Outbound (external) | HTTP on port `25550` serving `webmap/` | Host |
| Backup filesystem | Local | `/var/backups/minecraft/<session>/` | `server` |

## Plugin-level integrations

These are owned by the plugins, not the toolkit. The toolkit only writes their configuration.

| Plugin | Integration | Toolkit touchpoint |
|--------|-------------|--------------------|
| DiscordSRV | Discord chat bridge | UUID rewrite on migration; message config |
| AuthMe | Password authentication | Message config; log read for first-seen |
| EssentialsX | Economy, homes, userdata | Userdata moves; wealth/join data |
| SkinsRestorer | Skin caches | Cache/player file moves |
| TradeShop | Player shops | Player data moves |
| WorldGuard | Regions and flags | Region files, flags, messages |
| Pl3xMap / Dynmap | Web maps | Webmap paths, server config |
| RegionBossbar | Region boss bars | Boss bar entries |
| bStats | Telemetry | Enabling/disabling |
| Vault | Economy bridge | Hook flags |
| Sonar | Anti-VPN/spam | Adjusts `CONNECTION_THROTTLE` |

## Related documentation

- [components/provider-adapters.md](./components/provider-adapters.md)
- [flows/provisioning.md](./flows/provisioning.md)
- [security.md](./security.md)