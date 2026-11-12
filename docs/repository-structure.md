# Repository structure

## Top-level layout

```
minecraft-server-raspberrypi/
├── server                     # Operator entrypoint (executable shell controller)
├── scripts/                   # Operational scripts and common libraries
│   ├── configure-all.sh
│   ├── configure-settings.sh
│   ├── configure-localisation.sh
│   ├── update-server.sh
│   ├── fix-permissions.sh
│   ├── reset-end.sh
│   ├── get-player.sh
│   ├── get-players.sh
│   ├── get-player-trades.sh
│   ├── change-player-username.sh
│   └── common/                # Sourced-only libraries
│       ├── paths.sh
│       ├── specs.sh
│       ├── config.sh
│       ├── plugins.sh
│       ├── github.sh
│       ├── modrinth.sh
│       ├── jenkins.sh
│       ├── web.sh
│       ├── utils.sh
│       ├── status.sh
│       ├── players.sh
│       ├── messages.sh
│       ├── colours.sh
│       ├── worldguard.sh
│       └── rand.sh
├── tests/
│   └── modrinth-tests.sh
├── config/                    # Paper configuration
│   ├── paper-global.yml
│   └── paper-world-defaults.yml
├── bukkit.yml                 # Bukkit configuration
├── spigot.yml                 # Spigot configuration
├── purpur.yml                 # Purpur configuration
├── commands.yml               # Command aliases
├── help.yml                   # Help topics
├── permissions.yml            # Default permissions
├── .github/workflows/tests.yml
├── .gitignore
└── <root project documents>
```

## Module organisation

### Root configuration

Version-controlled, human-maintained declarative configuration consumed by the PurpurMC runtime. `server.properties` is deliberately **not** version controlled (see `.gitignore`) because it is host-specific and mutated in place.

### Operational scripts (`scripts/`)

Operator-facing procedures. Each script sources `scripts/common/paths.sh` first, then the libraries it needs. Scripts may depend on any common library; libraries never depend on scripts.

### Common libraries (`scripts/common/`)

Sourced-only definitions. They export variables and define functions; they are never executed directly (except `status.sh`, which computes `IS_SERVER_RUNNING` as a side effect at source time).

### Tests (`tests/`)

Isolated verification scripts named `*-tests.sh`, executed by the CI workflow.

### Continuous integration (`.github/workflows/tests.yml`)

Runs every `tests/*-tests.sh` on `push`, `pull_request`, and `workflow_dispatch`.

## Path resolution convention

Every script resolves the repository root the same way:

```bash
source "$(dirname "${BASH_SOURCE[0]}" | xargs realpath | sed 's/\/scripts.*//g')/scripts/common/paths.sh"
```

This makes the toolkit independent of the current working directory. `paths.sh` then exports every directory and file path the toolkit uses (see [components/common-libraries.md](./components/common-libraries.md)).

## Related documentation

- [components/](./components/) for per-component detail.
- [architecture.md](./architecture.md) for layering and dependency direction.
