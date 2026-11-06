# Setup runbook (Claude follows this)

You are Claude, setting up a new user's machine from this starter kit. The user pasted one prompt and expects
you to carry the whole setup, stopping only where a human has to act. Work through the stages in order.
Narrate in one line per stage, not per command.

**Ground rules for this run**
- Ask **once per stage** for approval, showing exactly what you will do (commands, files, and settings
  changes) and, in one or two lines, why, taken from that stage's section of `KIT/docs/setup-explained.md`.
  If the user asks what something does, answer from that file. Then do all of it.
- Never ask for, print, or store a password, token, or API key. Sign-ins the user does themselves, in their
  own terminal or browser.
- Never overwrite an existing file without showing the difference and asking. No `.bak` copies: show the diff.
- Keep a checklist at `<home>/Claude/REFERENCE/setup-log-YYYY-MM-DD.md` as you go (stage, result, anything the
  user still has to do). If the run stops, re-running the prompt resumes from that log.
- `KIT` below means the folder this file is in. `<home>` is the user's home folder (`%USERPROFILE%` on
  Windows, `~` on macOS). In Git Bash on Windows, `~` also means `%USERPROFILE%`.

## Stage 0 · Where are we

1. Detect the OS. **Windows** (the primary path for this kit) or **macOS**; each stage below gives both. On
   Linux, adapt and continue only with the user's yes.
2. On Windows, note which shell tools this session has (Bash via Git Bash, PowerShell, or both).
3. Read `KIT/README.md` and `<home>/Claude/REFERENCE/setup-log-*.md` if one exists; resume at the first
   unfinished stage.
4. Ask the user for: their name, their work email, their org's name, and their role in one line.

## Stage 1 · Tools

Check, and list what is missing in one table: `git`, `gh` (GitHub CLI), `python3` (or `python`), `jq`, and
optionally Node 22+ (for some skills) and the 1Password CLI (`op`, recommended for credentials).

**Windows:** install with winget after one approval, one package per command:
```
winget install --id Git.Git -e --source winget
winget install --id GitHub.cli -e --source winget
winget install --id Python.Python.3.12 -e --source winget
winget install --id jqlang.jq -e --source winget
winget install --id AgileBits.1Password.CLI -e --source winget      # optional
winget install --id OpenJS.NodeJS.LTS -e --source winget            # optional
```
Some installers raise a Windows permission prompt (UAC); tell the user to accept it. After installing Git for
Windows, tell the user to **restart the Claude app** so the session picks up Git Bash and the new PATH, then
re-paste the prompt; the setup log carries you past this stage.

**macOS:** Xcode command-line tools (`xcode-select --install`) and Homebrew need the user's Mac password: give
them the exact lines to run in their own Terminal and wait. Then `brew install git gh python jq` (plus
`1password-cli`, `node` if wanted).

Do not install anything the user declines.

## Stage 2 · Folders and the workspace repo

1. Create `<home>/Claude/` (documents workspace) with `CONTEXT/`, `PROJECTS/`, `REFERENCE/`, and
   `<home>/dev/` (code). If `Claude` already exists with content, stop and ask (see the welcome skill's
   warning about connecting a folder that already holds sensitive material).
   - **Windows: never under Documents, Desktop or OneDrive.** Many organizations redirect Documents and
     Desktop into OneDrive ("Known Folder Move"), which syncs the folder to the cloud and corrupts git
     repositories. Check: if `%USERPROFILE%\Documents` resolves into a OneDrive path, say so, and keep the
     workspace at `%USERPROFILE%\Claude`, which is not redirected.
   - **macOS: not inside iCloud Drive, Dropbox or Google Drive** for the same reason.
2. Git settings (Windows): `git config --global core.autocrlf true` and `git config --global core.longpaths
   true`. Copy `KIT/TEMPLATES/workspace.gitattributes` to `<home>/Claude/.gitattributes` so hook scripts keep
   Unix line endings.
3. `git init -b main` in `<home>/Claude`, copy `KIT/TEMPLATES/workspace.gitignore` to `<home>/Claude/.gitignore`.
4. Install the pre-commit hook: copy `KIT/.githooks/pre-commit` to `<home>/Claude/.githooks/` and run
   `git -C <home>/Claude config core.hooksPath .githooks`. On macOS also `chmod +x` it. (On Windows, Git for
   Windows runs hooks with its own bundled bash, so the same script works.) Test it: create a scratch file
   with `printf 'api_key = "%s"\n' TESTTESTTESTTESTTEST > hook-test.txt` (in Git Bash), stage it, show that the
   commit is blocked, then unstage and delete the scratch file.
5. Git identity. Ask whether they want commits under their work identity, personal identity, or both by
   folder. Set `user.name` and `user.email` globally for the default; if both, add an `includeIf
   "gitdir/i:~/dev/work/"` block (on Windows use `gitdir/i:` because paths are case-insensitive; the trailing
   slash is required) pointing at a second include file. Recommend a GitHub noreply address.

## Stage 3 · Personal instructions (`<home>/.claude/CLAUDE.md`)

1. If it exists, show it and ask whether to merge.
2. Otherwise fill `KIT/TEMPLATES/user-CLAUDE.md` with the Stage 0 answers, then ask three questions one at a
   time and add the answers: how they like output (short or detailed, bullets or prose); one thing they never
   want Claude to do; what they work on outside the org (so it stays separate).
3. Show the result and write it on approval.

## Stage 4 · Guardrails (`<home>/.claude/settings.json`)

1. Read `KIT/TEMPLATES/settings.json`. If a settings file exists, merge: add the kit's `deny` and `ask`
   entries to the existing lists, keep everything the user already has. Show the merged result.
2. The template already covers both the Bash tool and the PowerShell tool, and anchors credential paths at
   the filesystem root (`//`) or home (`~/`) so they apply in every folder.
3. Write it on approval. Explain in two lines what the deny and ask rules do and how to change them.
4. If this is the org's IT lead, mention `KIT/docs/org-mode.md`: the same rules can be enforced for every
   staff member from the claude.ai admin console. Do not change any org setting yourself.

## Stage 5 · The kit's plugins

Run, after one approval:

```
claude plugin validate "KIT"
claude plugin marketplace add "KIT"
claude plugin install onboarding@claude-starter-kit
claude plugin install guardrails@claude-starter-kit
claude plugin install it-admin@claude-starter-kit
claude plugin list
bash "KIT/plugins/guardrails/tests/run.sh"
```

The last line is the guardrails self-test: it feeds sample commands to the hook as data (nothing is executed)
and must report every case passed. If it fails, stop and show the user the output; the hook blocks on failure,
so a broken hook would block every shell command.

Then recommend (do not install without a yes) `mattpocock-skills` (grilling, tdd, diagnosing-bugs) from
Anthropic's official marketplace and Anthropic's `skill-creator`. List anything else in `KIT/docs/toolbox.md`
as optional, with one line each.

## Stage 6 · GitHub (optional, user-driven)

1. If they want the workspace backed up: they run `gh auth login` in their own terminal (it opens a browser;
   you never see the token).
2. Then, on approval: `gh repo create <name> --private --source <home>/Claude --remote origin`, first commit
   ("workspace: initial setup"), push. Confirm the repo is **private** in the output before pushing.

## Stage 7 · Hand off to /welcome

1. Write the final checklist to the setup log, including anything still owed.
2. Tell the user, in three lines:
   - Open a **new** Code session with the `Claude` folder in their home folder as the working folder.
   - Type `/welcome`. It writes the org rules into `Claude/CLAUDE.md`, copies the shared docs, interviews
     them, and builds their first real project.
   - Before using real org data: confirm the account is on the org's business plan.

Do not run `/welcome` in this session: it must run with the `Claude` folder as the working folder so its
`CLAUDE.md` loads.
