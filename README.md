# Claude starter kit

A plugin marketplace and setup runbook for an IT lead bringing Claude into a church and school: the org's AI
rules as an ambient `CLAUDE.md`, an onboarding flow, and IT admin skills with the guardrails built in.

## Order of operations

**You do these by hand (about 15 minutes):**

Windows first; macOS works too. `<home>` is `C:\Users\<you>` on Windows, `~` on a Mac.

1. **Account.** Sign up for Claude on the plan you will use for org work (Team, Enterprise or an education
   agreement). A personal plan is fine for learning with made-up data; org data waits for business terms.
2. **App.** Install the Claude desktop app (claude.ai/download), sign in, and open the **Code** tab.
3. **Git for Windows** (recommended, git-scm.com, or `winget install --id Git.Git -e`). Claude Code runs on
   Windows without it, through PowerShell, but Git Bash gives it the Bash tool, and you need git anyway.
   Setup can install it for you; then you restart the app once.
4. **Kit.** Put this folder at `<home>\dev\claude-starter-kit` (clone it, or unzip it there). **Not** under
   Documents, Desktop or OneDrive.
5. **Paste the prompt below** into a new Code session opened on your home folder.

**Claude does the rest, stopping only for your approvals and your own sign-ins:**

| Stage | What happens | Your part |
|---|---|---|
| 0 | Checks the machine and shell, reads the kit, asks your name, org, role | Answer four questions |
| 1 | Installs missing tools with winget (git, gh, python, jq, optionally 1Password CLI and Node) | Approve; accept any Windows permission prompts; restart the app once after Git installs |
| 2 | Creates `<home>\Claude` (workspace) and `<home>\dev` (code), checks for OneDrive redirection, a private-by-default git repo, the secrets and student-data pre-commit hook, your git identity | Approve |
| 3 | Writes your personal `<home>\.claude\CLAUDE.md` from a three-question interview | Answer, approve |
| 4 | Merges guardrails into `<home>\.claude\settings.json` (deny secrets and destructive admin commands; ask before pushes and admin writes), for both Bash and PowerShell | Approve |
| 5 | Validates and installs this marketplace's `onboarding` and `it-admin` plugins; suggests a few more | Approve |
| 6 | Optional: backs the workspace up to a private GitHub repo | Run `gh auth login` yourself, then approve |
| 7 | Hands off: open a new session in `<home>\Claude` and type `/welcome` | `/welcome` writes the org rules, interviews you and builds your first real project |

## The prompt

```text
Set up my machine from the Claude starter kit in the dev\claude-starter-kit folder under my home folder. Read its SETUP.md and follow it
stage by stage. Ask me once per stage before changing anything, never ask me for a password or key, and keep
the setup log it describes so we can resume if we stop.
```

## After setup: first week

1. Run `/welcome` in your `Claude` folder.
2. Make the policy yours: fill in the `[BRACKETED]` values in `CONTEXT/ai-rules.md` and `ai-use-policy.md`,
   run `tools/build.sh`, commit, and run `/welcome` again for the checkup (it picks up the new rules).
3. Do one real task from each IT skill with sample data. Commit at the end of each session.
4. Write your first skill from whichever task you explained twice (`migrate-project` helps if it started as a
   claude.ai Project or a long prompt).

## What is in here

| Path | What |
|---|---|
| `SETUP.md` | The runbook Claude follows for the one-prompt setup |
| `CONTEXT/` | The org documents, edited only here: `ai-rules.md`, `ai-use-policy.md`, `working-with-claude.md`, `folder-structure.md`, `org-identity.md` |
| `plugins/onboarding/` | `welcome`, `org-guide`, `migrate-project`, `build-brand-voice` |
| `plugins/it-admin/` | `student-activity-review`, `account-lifecycle`, `unifi-review`, `automation-port` |
| `TEMPLATES/` | Personal `CLAUDE.md`, guardrail `settings.json`, workspace `.gitignore`, project README ledger |
| `.githooks/pre-commit` | Blocks credentials and person-level exports from any repo that uses it |
| `docs/` | Champion playbook, where work runs, the chief-of-staff model for many sessions, toolbox |
| `tools/build.sh` | Syncs `CONTEXT/` into the plugin and rebuilds the `CLAUDE.md` template. Run after any CONTEXT edit |

## Maintaining it

- Edit org documents in `CONTEXT/` only, then `tools/build.sh`, then commit. The copies under `plugins/` are
  build output.
- Bump the version in `.claude-plugin/marketplace.json` and the plugin's `plugin.json` when you change a skill.
- Everyone updates with `claude plugin marketplace update claude-starter-kit`.
- Keep this repo private. It holds no secrets, but it is the shape of your security posture.
