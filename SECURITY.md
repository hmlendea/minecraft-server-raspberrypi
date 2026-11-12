# Security Policy

This document describes the security policy for Minecraft Server on Raspberry Pi, a collection of configuration files and shell scripts that provision and operate a self-hosted PurpurMC Minecraft server on a Raspberry Pi 4. The repository is published at https://github.com/hmlendea/minecraft-server-raspberrypi; the policy covers supported versions and distribution channels, vulnerability reporting, report scope, coordinated disclosure, good-faith research, and recognition.

## 📑 Table of Contents

- [Supported Versions](#️-supported-versions)
- [Reporting a Vulnerability](#-reporting-a-vulnerability)
- [Scope](#-scope)
- [Disclosure Policy](#-disclosure-policy)
- [Safe Harbour](#-safe-harbour)
- [Recognition](#-recognition)

## 🛡️ Supported Versions

Use this table to indicate which project versions currently receive security maintenance.

| Version | Distribution Channel | Supported |
|---------|--------------------|-----------|
| Latest version | GitHub repository (`master` branch) | ✅ |
| Latest version | Unofficial third-party distribution channels | ❌ |
| Preceding versions | Any distribution channel | ❌ |

## 🚨 Reporting a Vulnerability

Please do not disclose suspected vulnerabilities publicly before maintainers have had an opportunity to validate and remediate them.

To report a vulnerability:
- [GitHub Security Advisories](https://github.com/hmlendea/minecraft-server-raspberrypi/security/advisories)
- Contact the maintainers directly

## 📌 Scope

The original maintainers are not responsible for changes, modifications, or security issues introduced by downstream forks.

The subsequent report categories are in scope for this repository:
- Command injection or argument injection in the scripts under `scripts/`
- Path traversal or arbitrary file write during server, plugin, or datapack updates
- Insecure downloads, including missing HTTPS usage or absent integrity verification in `scripts/update-server.sh`
- Permission or ownership weakening introduced by `scripts/fix-permissions.sh`
- Exposure of player data, account credentials, or server secrets through configuration, logs, or backups

The subsequent categories are out of scope unless explicitly stated to the contrary:
- Vulnerabilities in PurpurMC, PaperMC, or the upstream Minecraft server software
- Vulnerabilities in the third-party plugins, datapacks, or mods referenced by `scripts/update-server.sh`
- Vulnerabilities in upstream distribution endpoints (PurpurMC, Modrinth, GitHub, and Jenkins-style build servers)
- Issues arising from operator modification of the configuration files or scripts
- Misconfiguration of a self-hosted instance, including exposed ports, weak operator credentials, or disabled authentication
- Vulnerabilities in the host operating system, the Java runtime, or the Raspberry Pi hardware

## 📢 Disclosure Policy

This project follows coordinated disclosure:
1. Vulnerabilities are investigated privately.
2. A remediation plan is prepared and validated.
3. Public disclosure is published after a fix, mitigation, or agreed risk decision is available.
4. Credit is attributed in accordance with reporter preference and project policy.

## 🧾 Safe Harbour

If your investigation is conducted in good faith, confined to authorised scope, and disclosed responsibly, the maintainers will not pursue action for policy-compliant activity.

## 🙏 Recognition

We appreciate responsible disclosure. Reporters who desire public attribution may be acknowledged in release notes, advisories, or a dedicated acknowledgements section.
