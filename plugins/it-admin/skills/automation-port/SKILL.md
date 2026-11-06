---
name: automation-port
description: "Replace a clunky manual task or Power Automate flow with a maintainable script or scheduled job: inventory the flow, decide keep versus port, decide where it runs and where its credential lives, then build it with a dry-run flag, logging, config, tests and a runbook, and schedule it on the right machine. Use when someone says 'automate this', 'replace this Power Automate flow', 'I do this by hand every week', 'schedule this script', 'cron job', 'LaunchDaemon', 'run this every night', or 'where should this job run'."
---

# Automation port

## 1 · Inventory before building

For each flow or manual task, capture: trigger, inputs, outputs, systems touched (read vs write), who
depends on it, how often it fails, and what happens when it does. Put the list in
`PROJECTS/automation-inventory/README.md` if there is more than one.

**Keep, do not port,** a flow that is tightly bound to Microsoft 365 triggers and works. Port the ones that
are fragile, hard to read, or need data Power Automate cannot reach.

## 2 · Decide where it runs (write the answer down)

| The job | Runs on |
|---|---|
| Run by hand | The laptop (a script in a repo, or a skill) |
| Scheduled, late is fine | The laptop (app scheduled task, a Task Scheduler task that runs at logon, or a macOS LaunchAgent) |
| The org depends on it, or anyone but you relies on it | The always-on server, as a system service under a non-admin service account |
| Only needs cloud APIs, no campus network | A cloud scheduler is an option |

Tests: if the laptop burned tonight, would anyone notice the job stopped? Then not the laptop. One job, one
machine: never install the same job in two places.

## 3 · Decide where the credential lives

- A personal sign-in that reaches only what the runner can see: their password manager, injected at run time
  (`op run --env-file=...`).
- An org-wide key or service account: only on the server that runs the job, in a mode-600 env file read by a
  wrapper script, scoped to exactly this job's reads and writes. Read-only if the job only reads.
- Never in the repo, the plist or unit file, a prompt, or a log line.

## 4 · Build (a repo in `~/dev/`)

- `--dry-run` is the default; `--apply` is explicit. Dry-run prints exactly what would change.
- Config in a file, not constants in code. Secrets come from the environment only.
- Structured log line per action (what, target, result) to a log file with rotation.
- Idempotent: running twice does no harm.
- A failure alert to a person (email draft to self, a chat webhook to the IT channel) when it fails, and
  silence when it succeeds.
- Tests against sample data, never real exports.
- `docs/runbook.md`: what it does, where it runs, where its credential lives, how to run by hand, how to stop
  it, and what to check when it fails.

## 5 · Schedule

- **Windows (laptop or server):** Task Scheduler (`schtasks` or `Register-ScheduledTask`).
  - "Run only when user is logged on" is the laptop trap: the job silently waits for a login. For anything
    the org depends on, use **"Run whether user is logged on or not"** under a dedicated service account
    (a group Managed Service Account if you have Active Directory), not your own login.
  - A task running as a service account **does not see mapped drives** (`S:\`): use UNC paths
    (`\\server\share`), and test as that account. A missing drive often reads as "file not found", not as a
    permissions error.
  - Secrets: the 1Password CLI with a service-account token, or an env file readable only by the service
    account (set the ACL with `icacls`). Never in the task's arguments, which are visible in Task Scheduler.
  - Set "Stop the task if it runs longer than" and turn on task history, so a hung job is visible.
- **macOS server:** a LaunchDaemon in `/Library/LaunchDaemons` running as the service account. It has no
  login session and no Full Disk Access, so a protected folder reads as empty rather than erroring: test the
  real paths as that account. Never put secrets in the plist (world-readable); the wrapper sources a mode-600
  env file, and every value in it is quoted (a sourced unquoted `&` gets executed).
- **Linux:** a systemd service plus timer, `User=` the service account, `EnvironmentFile=` mode 600.
- Record in the runbook and the inventory which machine holds the job.

## 6 · Cut over

Run the new job in dry-run beside the old flow for one cycle and compare outputs. Then switch, disable the
old flow (do not delete it yet), and delete it after a clean month.
