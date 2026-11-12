# Logging

## Framework

The toolkit has no logging framework. All diagnostics are human-facing `echo` to standard output or standard error, optionally colourised with shell escape sequences or Minecraft colour codes. The Minecraft runtime and its plugins maintain their own logs under `logs/` (for example `logs/latest.log`).

## Output channels

| Channel | Destination | Content |
|---------|-------------|---------|
| Controller status | stdout/stderr | `Starting…`, `done`, `failed`, `skipped`, `timed out`, memory summary |
| Configuration writers | stdout | `<file>: <key>=<value>` or `<file>: <key> (delete)` |
| Update flow | stdout | `Checking for updates for plugin '<name>'…`, `> Downloaded '<path>'` |
| Provider adapters | stdout (via callers) | resolved version implicitly through downloads |
| Minecraft runtime | `logs/` | Connection, command, and plugin activity; rotated by the JVM |

## Semantics

There are no structured severity levels. Conventions observed in the codebase:

- Progress: plain `echo`.
- Success: `echo -e "\e[39;1m done\e[0m"`.
- Warning: stderr `echo -e` (`skipping`, `timed out`).
- Error: stderr `echo -e` (`failed`, `not supported`, permission messages).

## Correlation

None. There is no request or trace identifier. Correlating a toolkit action with a runtime log entry relies on timestamps and the captured console buffer (`/tmp/minecraft_<session>_command_dump.txt`).

## Sinks and retention

- Toolkit output: transient (terminal).
- Runtime logs: `logs/` with JVM-managed rotation; `find_in_logs` searches `.log` and `.log.gz`.
- Command buffer: transient, removed on stop.

## Redaction

The toolkit performs **no** redaction. Player reports and log searches may surface usernames, IP addresses, Discord IDs, passwords, and locations. Operator discipline is relied upon.

## Sampling and performance

Not applicable; diagnostics are synchronous and operator-initiated.

## Error logging

Failures print a message; the controller additionally dumps the captured console buffer to stderr when the JVM dies during startup. No stack traces (Bash).

## Audit logging

None separate from the configuration writers' `<file>: <key>=<value>` lines, which are the closest analogue to a change audit trail.

## Configuration

Log behaviour is not configurable at runtime. The Minecraft server's own logging is configured through its configuration files and plugins.

## Related documentation

- [error-handling.md](./error-handling.md)
- [security.md](./security.md)
- [components/server-controller.md](./components/server-controller.md)