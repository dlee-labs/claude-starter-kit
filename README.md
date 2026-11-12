# Claude starter kit

A plugin marketplace and setup runbook for an IT lead bringing Claude into a church and school: the org's AI
rules as an ambient `CLAUDE.md`, an onboarding flow, and IT admin skills with the guardrails built in.

It is a template: fill in the `[BRACKETED]` values for your organization, keep your filled-in copy private, and
have leadership adopt the policy before staff use it with real data. MIT licensed.

**Looking for a church AI policy?** [`church-ai-policy/`](church-ai-policy/) is a complete, adaptable AI use
policy for a church's elders or board, with a members' privacy notice. It works with any AI service; you do not
need the rest of this kit to use it.

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

**Claude does the rest, stopping only for your approvals and your own sign-ins.** Every stage, with its exact
commands, the files it changes, why, and how to undo it: [`docs/setup-explained.md`](docs/setup-explained.md).


| Stage | What happens | Your part |
|---|---|---|
| 0 | Checks the machine and shell, reads the kit, asks your name, org, role | Answer four questions |
| 1 | Installs missing tools with winget (git, gh, python, jq, optionally 1Password CLI and Node) | Approve; accept any Windows permission prompts; restart the app once after Git installs |
| 2 | Creates `<home>\Claude` (workspace) and `<home>\dev` (code), checks for OneDrive redirection, a private-by-default git repo, the secrets and student-data pre-commit hook, your git identity | Approve |
| 3 | Writes your personal `<home>\.claude\CLAUDE.md` from a three-question interview | Answer, approve |
| 4 | Merges guardrails into `<home>\.claude\settings.json` (deny secrets and destructive admin commands; ask before pushes and admin writes), for both Bash and PowerShell | Approve |
| 5 | Validates and installs the `onboarding`, `guardrails` and `it-admin` plugins, runs the guardrails self-test; suggests a few more | Approve |
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
| `plugins/guardrails/` | A fail-closed hook that blocks skipping git hooks, force pushes, GAM deletes and root-level recursive deletes, with a self-test |
| `plugins/it-admin/` | `student-activity-review`, `account-lifecycle`, `unifi-review`, `automation-port` |
| `TEMPLATES/` | Personal `CLAUDE.md`, guardrail `settings.json`, org-wide `managed-settings.json`, workspace `.gitignore`, project README ledger |
| `.githooks/pre-commit` | Blocks credentials and person-level exports from any repo that uses it |
| `docs/` | Setup explained stage by stage, org mode (enforce the kit for everyone), champion playbook, where work runs, the chief-of-staff model for many sessions, toolbox |
| `church-ai-policy/` | A standalone church AI use policy template and members' notice, for any AI service |
| `tools/build.sh` | Syncs `CONTEXT/` into the plugin and rebuilds the `CLAUDE.md` template. Run after any CONTEXT edit |

## Updating the kit from a newer zip

**Not set up yet:** delete the old `claude-starter-kit` folder, extract the new zip in its place, and run the
setup prompt as normal.

**Already set up:**
1. Rename the old folder to `claude-starter-kit-old` (it holds any edits you made, such as filled-in rules).
2. Extract the new zip so you have a fresh `<home>\dev\claude-starter-kit`.
3. Open a new Code session on your home folder and paste:

```text
The Claude starter kit in the dev\claude-starter-kit folder under my home folder was updated; the previous
copy is in dev\claude-starter-kit-old. Read the new SETUP.md and README.md. Then: (1) list what changed
between the two folders, and copy back any edits I made to CONTEXT\ in the old copy, showing me each one
first; (2) re-run Stage 4 to merge the new settings rules into my settings, showing me the diff; (3) re-run
Stage 5: update the marketplace, install any plugin I don't have yet, and run the guardrails self-test;
(4) append what you did to my setup log. Ask once before each step.
```

4. Start a new session (or run `/reload-plugins`) so updated skills load. The kit loads in place from this
   folder, so skill changes need no version bump. Settings and newly added plugins do need steps 2 and 3.
5. When all is well, delete `claude-starter-kit-old`.

If you edited `CONTEXT\` in your copy, also run `/welcome` in your `Claude` folder for the checkup: it notices
that your org rules file is older than the kit's and offers to update it.

## Maintaining it

- Edit org documents in `CONTEXT/` only, then `tools/build.sh`, then commit. The copies under `plugins/` are
  build output.
- **Your own machine** loads the kit in place from this folder: edits take effect at the next session start
  or after `/reload-plugins`, no version bump needed.
- **Once others install it from a hosted repo:** bump `version` in the changed plugin's `plugin.json` only
  (never also in the marketplace entry), or omit `version` everywhere so users track commits. Auto-update is
  off by default: each person turns it on in `/plugin` > Marketplaces, or an admin sets `"autoUpdate": true`
  in managed settings. Otherwise people update with `claude plugin marketplace update claude-starter-kit`.
- **On a Team plan,** an admin can sync this repo to everyone through claude.ai Organization settings > Plugins
  & skills (that sync needs a private repo, so fork or copy this one into your org), so staff need no git account
  and no install step.
- Keep your filled-in copy private. It holds no secrets, but it is the shape of your security posture.
