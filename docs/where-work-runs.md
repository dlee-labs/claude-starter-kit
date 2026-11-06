# Where work runs, and keeping environments straight

## The routing rule

| The task needs | Runs on |
|---|---|
| Nothing special (drafting, planning, scripts, repo edits) | Whatever machine you are at |
| A GUI app, browser logins, local media, previews | The laptop |
| The campus network (UniFi, file servers, printers) | A machine on that network: the laptop on site, or the always-on server |
| An org-wide credential | The always-on server, as a service the session calls |
| A schedule the org depends on | The always-on server, as a system service |
| Only cloud APIs, on a schedule | The server, or a cloud routine with only the connectors it needs |

## Surfaces for remote work

- **Laptop:** sees everything; stops when it sleeps.
- **Always-on server:** reach it by SSH, or drive a session on it from your phone with Remote Control. Keep
  it minimal: only the repos and keys its jobs need.
- **Phone driving a Mac (Remote Control):** good for approving and steering; the Mac must stay awake.
- **Cloud session:** works on a GitHub repo with allowed connectors; cannot see your disk or the campus LAN.

## Keeping environments straight

1. **Git is the only sync.** One clone per machine; they meet on GitHub. Never a repo in iCloud, Dropbox,
   OneDrive or a network share (they corrupt `.git` and create conflict copies). On Windows, check whether
   Documents and Desktop are redirected into OneDrive; keep repos under `C:\Users\<you>\` directly.
2. **Pull at session start,** and read incoming scripts, hooks, skills and `CLAUDE.md` changes before they run
   on another machine.
3. **One scheduled job, one machine,** recorded in the job's runbook.
4. **Credentials follow the workload.** A machine holds only the keys its jobs use.
5. **Parallel tasks get their own git worktree.**
6. **Name the machine.** Session titles or the status line show host and repo. Most mix-ups are "I thought I
   was on the other box."

## Scheduling traps (Windows)

- A Task Scheduler task set to "Run only when user is logged on", and the desktop app's scheduled tasks, run
  only while you are signed in and the PC is awake. A nightly job on a laptop runs whenever you next open it.
- "Run whether user is logged on or not" under a service account runs unattended, but that account does not
  see mapped drive letters: use UNC paths, and test as the account.
- Task arguments are visible to anyone who can open Task Scheduler. Secrets go in the 1Password CLI or an
  env file whose ACL allows only the service account.
- Sleep and Windows Update restarts skip runs. Turn on "Run task as soon as possible after a scheduled start
  is missed" for anything that must not be skipped, or move it to the server.

## Scheduling traps (macOS)

- A user **LaunchAgent** and the desktop app's scheduled tasks run only in a logged-in, awake session. A
  nightly job on a laptop runs whenever the lid opens.
- A system **LaunchDaemon** runs at boot without a login, but has no Full Disk Access: a protected folder
  reads as empty, not as an error. Test as the service account.
- Daemon plists are world-readable. Secrets go in a mode-600 env file read by a wrapper; quote every value.
