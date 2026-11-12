# Behaviour: configuration provisioning

## Contract

Applying configuration produces a deterministic target state regardless of prior file contents:

1. Every configured key is set to its computed value.
2. Every configured key set to an empty value is removed.
3. Files absent from the host are left untouched.

Running `configure-all.sh` twice yields the same result as running it once.

## Interaction with the running state

- When the server is **running**, `configure_plugin` reloads each affected plugin so changes take effect immediately.
- When the server is **stopped**, writes persist and take effect on next start; `reload_plugin` returns early.

## Locale selection

A single `LOCALE` value selects both server-level and plugin-level message variants. `ro` also enables the `LOCALE_FULL=ro_RO` value and Romanian message files (for example AuthMe `messages_ro.yml`).

## Guarded application

Plugin writes are conditioned on installation. This means a host with a subset of plugins receives only the relevant configuration, and the same repository can serve hosts with different plugin sets.

## Observable output

Each write prints a line of the form `<file>: <key>=<value>` (or `(delete)`), principally for `yml`/`json` writes. These lines are the primary audit trail for what configuration changed.

## Related documentation

- [flows/configuration.md](../flows/configuration.md)
- [configuration.md](../configuration.md)
- [components/configuration-writers.md](../components/configuration-writers.md)
