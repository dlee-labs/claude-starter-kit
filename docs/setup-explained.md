# What setup actually does, stage by stage

The one-prompt setup is Claude following [`SETUP.md`](../SETUP.md). This page is the same run explained for a
person: what each stage changes on your machine, the exact commands, why it is there, and how to undo it.
Read it before you paste the prompt, or keep it open beside the session.

Paths are Windows-first. `<home>` is `C:\Users\<you>`. In Git Bash, `~` means the same folder.

**How approvals work.** Claude Code asks permission before it edits a file or runs a command, unless your
settings say otherwise. On top of that, the runbook makes Claude stop once per stage, show you everything
that stage will do, and wait for your yes. You can say no to any stage, or any item in it, and the run
continues without it. Nothing here asks for a password or token in the chat; every sign-in happens in your
own terminal or browser.

---

## Stage 0 · Where are we

**Does:** Detects the OS (Windows or macOS) and which shell tools this Claude session has: Bash (only if Git
for Windows is installed) and/or PowerShell. Reads the kit's README. Looks for an earlier setup log and, if one
exists, resumes from the first unfinished stage. Asks four questions: your name, work email, org name, role.

**Changes on your machine:** nothing.

**Why:** Every later stage branches on the OS and the shell. The four answers fill in your personal
instructions file in Stage 3, so you answer them once.

---

## Stage 1 · Tools

**Does:** Checks for, and installs whatever is missing of:

| Tool | Command (Windows) | What it is for |
|---|---|---|
| Git for Windows | `winget install --id Git.Git -e --source winget` | Version control, plus Git Bash, which gives Claude its Bash tool and runs the pre-commit hook |
| GitHub CLI | `winget install --id GitHub.cli -e --source winget` | Creating and pushing to a private repo without handing Claude a token |
| Python 3.12 | `winget install --id Python.Python.3.12 -e --source winget` | Log and CSV analysis, admin scripts (Google Admin, UniFi) |
| jq | `winget install --id jqlang.jq -e --source winget` | Reading JSON from APIs in the shell |
| 1Password CLI *(optional)* | `winget install --id AgileBits.1Password.CLI -e --source winget` | Injecting a credential into one command (`op run`) so it never sits in a file or a chat |
| Node.js LTS *(optional)* | `winget install --id OpenJS.NodeJS.LTS -e --source winget` | Some skills and MCP servers need it (HyperFrames, for one) |

**Changes on your machine:** installs those programs and adds them to your PATH. Windows may raise a
permission prompt (UAC) for some; that is Windows asking you, not Claude.

**Why:** winget is Windows' own package manager. It installs signed packages from known publishers, and
uninstalls them cleanly later. After Git installs, you restart the Claude app once so the session sees Git
Bash and the new PATH, then re-paste the prompt; the setup log carries you past this stage.

**Undo:** `winget uninstall --id <same id>`, or Settings > Apps.

---

## Stage 2 · Folders and the workspace repo

**Does, in order:**

1. Creates `<home>\Claude\` with `CONTEXT\`, `PROJECTS\` and `REFERENCE\` (your documents workspace), and
   `<home>\dev\` (code, one repo per tool). Stops and asks if `Claude` already has content in it.
2. Checks whether Windows redirects your Documents folder into OneDrive. If it does, it says so and keeps the
   workspace at `<home>\Claude`, which is not redirected.
3. Sets two global git options:
   - `git config --global core.autocrlf true`: Windows line endings in your working files, Unix line
     endings in the repo, so files look right on both systems.
   - `git config --global core.longpaths true`: lets git handle paths longer than Windows' old 260-character
     limit, which deep project folders hit.
4. Copies two files from the kit into the workspace:
   - `.gitattributes`: keeps hook scripts in Unix line endings, so Git Bash can run them.
   - `.gitignore`: keeps credentials (`.env`, `secrets\`), your personal profile files, and raw exports
     (`PROJECTS\*\1-source\*.csv`, `.xlsx`, `.json`) out of git.
5. `git init -b main` in `<home>\Claude`: the workspace becomes a git repository with full history.
6. Installs the pre-commit hook: copies `.githooks\pre-commit` into the workspace and runs
   `git config core.hooksPath .githooks`, so git runs it before every commit in this repo only. Then it
   **tests it**: it makes a scratch file containing a fake API key, tries to commit it, shows you the block,
   and deletes the scratch file.
7. Sets your git name and email (it recommends your GitHub noreply address, so your real email is not
   published in commit history). If you want work and personal commits under different identities, it adds
   an `includeIf "gitdir/i:~/dev/work/"` block to `~/.gitconfig`: repos under that folder use your work
   identity automatically. The `/i` makes the match ignore capitalization, as Windows paths do; the trailing
   slash is required or the rule silently never matches.

**What the hook blocks:**
- Credential-shaped text: `api_key = "…"` style assignments of 16+ characters, private key blocks, AWS keys
  (`AKIA…`), GitHub tokens (`ghp_…`), Slack tokens, `sk-…` keys, Google service-account JSON.
- Credential files by name: `.env`, `.pem`, `.p12`, `*credentials*.json`, `*token*.json`,
  `*service-account*.json`.
- Person-level exports: any CSV or TSV whose header row names people (student, name, email) together with an
  identifier (email, ID, URL, IP, grade, OU, date of birth, address, phone). A CSV of totals (`month,count`)
  passes.

When it blocks, it says why. Fix the file; never `git commit --no-verify`.

**Changes on your machine:** two new folders, two global git settings, and one repo with three small files.

**Why:** Git is your undo button and your long-term memory, and its history is permanent. The `.gitignore`
and hook exist because the one mistake you cannot undo is committing a credential or a student list. Sync
services like OneDrive corrupt `.git` folders, which is why the workspace stays out of them.

**Undo:** delete `<home>\Claude` and `<home>\dev` (empty at this point);
`git config --global --unset core.autocrlf` and `--unset core.longpaths`.

---

## Stage 3 · Your personal instructions (`<home>\.claude\CLAUDE.md`)

**Does:** Fills the kit's template with your Stage 0 answers, then asks three more questions one at a time:
how you like output, one thing Claude should never do, and what you work on outside the org. It shows you
the finished file before writing it. If you already have one, it offers a merge instead.

**What is in the file:** who you are; how to work with you (no padding, say "I don't know", ask when a
wrong guess is expensive); hard rules (never send email without your yes, never print or commit a
credential, never put person-level data in a repo, commit at the end of each session); and where things
live (`Claude` for documents, `dev` for code, scheduled org jobs on the always-on server).

**Changes on your machine:** one file. Claude Code loads it at the start of **every** session, in any folder.

**Why:** This replaces the mega-prompt. You write it once, it is always on, and you edit it like any file.
Org rules are not here; they go in the workspace's own `CLAUDE.md` (from `/welcome`), so they apply to org
work only.

**Undo:** edit or delete the file.

---

## Stage 4 · Guardrails (`<home>\.claude\settings.json`)

**Does:** Merges the kit's permission rules into your user settings (keeping anything already there) and
shows you the merged file before writing.

| Rule type | What Claude Code does | Kit entries |
|---|---|---|
| `deny` | Refuses the action outright, even if you or a prompt ask for it | Reading `~/.ssh`, `~/.aws`, the GitHub CLI's config, and any `.env`, `secrets` folder, credentials or service-account JSON **anywhere on disk**; force push; `git commit --no-verify` or `-n`; GAM deletes; `sudo`; `Format-Volume`, `Clear-Disk` |
| `ask` | Always stops for your approval, even in a permissive mode | Any `gam` command; `git push`; `gh repo create`; API writes (`curl -X POST/PUT/PATCH/DELETE`, `Invoke-RestMethod -Method`); recursive `Remove-Item`; scheduled tasks (`schtasks`, `Register-ScheduledTask`, `launchctl`); elevation (`Start-Process -Verb RunAs`); `Set-ExecutionPolicy`; `op` (1Password) |

Every command rule exists twice, as `Bash(...)` and `PowerShell(...)`, because on Windows Claude Code can run
commands through either tool. Credential paths start with `//` (filesystem root) or `~/` (home): a bare
`**/.env` would only cover the folder the session started in.

**What these rules can and cannot stop.** Read denies cover Claude's own file tools and the shell file
commands Claude Code recognizes (`cat`, `head`, `tail`, `sed`), but not a script that opens files itself.
Command rules match the command as written, so an unusual spelling can slip past; the `guardrails` plugin in
Stage 5 closes the dangerous cases. Full OS-level enforcement is the sandbox, which runs on macOS, Linux and
WSL2, not native Windows.

**Changes on your machine:** one file, applying to every Claude Code session.

**Why:** The rules file is culture: Claude follows it, but it can be argued with. Settings are enforced by
the tool itself. For an org, the same rules can be enforced for everyone from the claude.ai admin console
(`docs/org-mode.md`), where users cannot change them.

**Undo:** edit the file; remove any line you disagree with.

---

## Stage 5 · The kit's plugins

**Does:**
```
claude plugin validate "<kit folder>"                 # checks the marketplace and plugins are well-formed
claude plugin marketplace add "<kit folder>"          # registers the kit as a source of plugins
claude plugin install onboarding@claude-starter-kit   # welcome, org-guide, migrate-project, build-brand-voice
claude plugin install guardrails@claude-starter-kit   # the hook described below
claude plugin install it-admin@claude-starter-kit     # student-activity-review, account-lifecycle, unifi-review, automation-port
claude plugin list                                    # confirms all three are installed and enabled
bash "<kit folder>/plugins/guardrails/tests/run.sh"   # guardrails self-test; must pass every case
```

**The `guardrails` plugin** adds a hook: a small script Claude Code runs before **every** Bash or PowerShell
command, which can veto it. It blocks, in any spelling the deny rules might miss: skipping git hooks
(`--no-verify`, `commit -n`, overriding or unsetting `core.hooksPath`), force pushes (`--force-with-lease` is
allowed), GAM delete and wipe commands however the binary is invoked, and recursive deletes at a drive, home or
root folder. It **fails closed**: if the script cannot run, the command is blocked rather than allowed. It
needs Git Bash on Windows, which Stage 1 installs. It adds nothing to the context window. The self-test feeds
26 sample commands to it as data (none are executed) and checks each verdict.
Then it suggests, and installs only on your yes, Matt Pocock's skills (grilling, tdd, diagnosing-bugs) and
Anthropic's skill-creator, and lists the rest of `docs/toolbox.md` as optional.

**Changes on your machine:** Claude Code records the marketplace and plugins in its own config under
`<home>\.claude\`. The plugins are read from the kit folder, so keep that folder where it is.

**Why:** A skill is a written procedure Claude loads when the task matches. Only its one-line description sits
in the context window until needed, so installed skills cost almost nothing until used. A marketplace is how
a team shares one canonical copy: fix a skill in the kit repo, everyone updates.

**Undo:** `claude plugin uninstall <name>@claude-starter-kit`, `claude plugin marketplace remove
claude-starter-kit`.

---

## Stage 6 · GitHub backup (optional)

**Does:** You run `gh auth login` yourself, in your own terminal; it opens a browser, and the token goes into
Windows' credential store. Claude never sees it. Then, on your yes, Claude runs
`gh repo create <name> --private --source <home>\Claude --remote origin`, makes the first commit and pushes,
and checks that the repo really is private before pushing.

**Why:** Off-machine history. If the laptop dies, the workspace does not. The repo holds documents and rules,
never credentials or exports (the hook and `.gitignore` see to that).

**Undo:** delete the repo on GitHub; `git remote remove origin`.

---

## Stage 7 · Hand-off to `/welcome`

**Does:** Writes the final checklist to `<home>\Claude\REFERENCE\setup-log-<date>.md`, including anything you
skipped. Then tells you to open a **new** Code session with the `Claude` folder as its working folder and type
`/welcome`.

**Why a new session:** a workspace's `CLAUDE.md` loads when a session starts in that folder. `/welcome` needs to
run where those rules apply.

### What `/welcome` then does

1. Checks the folder is the right one (empty, not a documents folder full of sensitive files).
2. Writes the org rules into `<home>\Claude\CLAUDE.md`, built from the kit's `ai-rules.md` and
   `working-with-claude.md`, and copies the policy, folder standard and org-identity docs into `CONTEXT\`.
   These are the org-wide layer, separate from your personal file.
3. Runs a quick preflight (folder writable, rules present, which connectors respond).
4. Gives a short tour of the rules: what you can do first, then what is off-limits.
5. Interviews you (role, rhythms, outputs, time sinks) into `CONTEXT\my-profile.md`, which never goes in git.
6. Builds your first real project with you, from one of your time sinks, in `PROJECTS\<name>\`, and shows you
   where a correction goes: `my-preferences.md` for how you like things done, the project's `CLAUDE.md` for
   facts about that project.

---

## Afterwards: what is where

| Location | What | In git? |
|---|---|---|
| `<home>\.claude\CLAUDE.md` | Your personal instructions, every session | No (outside the repo) |
| `<home>\.claude\settings.json` | Guardrails, every session | No |
| `<home>\Claude\CLAUDE.md` | Org rules, sessions in this folder | Yes |
| `<home>\Claude\CONTEXT\` | Policy, rules, folder standard, your profile | Yes, except your profile and preferences |
| `<home>\Claude\PROJECTS\` | Your work, one folder per project | Yes, except raw exports |
| `<home>\Claude\REFERENCE\setup-log-*.md` | What setup did | Yes |
| `<home>\dev\claude-starter-kit\` | The kit (plugin source) | Its own repo |
