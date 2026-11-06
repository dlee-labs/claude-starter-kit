# Setup runbook (Claude follows this)

You are Claude, setting up a new user's machine from this starter kit. The user pasted one prompt and expects
you to carry the whole setup, stopping only where a human has to act. Work through the stages in order.
Narrate in one line per stage, not per command.

**Ground rules for this run**
- Ask **once per stage** for approval, showing exactly what you will do (commands, files, and settings
  changes). Then do all of it.
- Never ask for, print, or store a password, token, or API key. Sign-ins the user does themselves, in their
  own terminal or browser.
- Never overwrite an existing file without showing the difference and asking. Back nothing up as `.bak`:
  show the diff instead.
- Keep a checklist at `~/Claude/REFERENCE/setup-log-YYYY-MM-DD.md` as you go (stage, result, anything the
  user still has to do). If the run stops, re-running the prompt resumes from that log.
- `KIT` below means the folder this file is in.

## Stage 0 · Where are we

1. Confirm macOS (`sw_vers`). On Windows or Linux, say this runbook is macOS-first, adapt paths, and continue
   only with the user's yes.
2. Read `KIT/README.md` and `~/Claude/REFERENCE/setup-log-*.md` if one exists; resume at the first unfinished
   stage.
3. Ask the user for: their name, their work email, their org's name, and their role in one line. Nothing else
   yet.

## Stage 1 · Tools

Check, and list what is missing in one table: Xcode command-line tools (`xcode-select -p`), Homebrew,
`git`, `gh` (GitHub CLI), `python3`, `jq`, and optionally Node 22+ (for some skills) and the 1Password CLI
(`op`, recommended for credentials).

- Install what is missing with Homebrew after one approval. Xcode tools and Homebrew itself prompt for the
  user's Mac password: tell them to run those two in their own Terminal, give them the exact line, and wait.
- Do not install anything the user declines.

## Stage 2 · Folders and the workspace repo

1. Create `~/Claude/` (documents workspace) with `CONTEXT/`, `PROJECTS/`, `REFERENCE/`, and `~/dev/` (code).
   If `~/Claude` already exists with content, stop and ask (see the welcome skill's warning about connecting a
   folder that already holds sensitive material).
2. `git init -b main` in `~/Claude`, copy `KIT/TEMPLATES/workspace.gitignore` to `~/Claude/.gitignore`.
3. Install the pre-commit hook: copy `KIT/.githooks/pre-commit` to `~/Claude/.githooks/`, make it
   executable, and run `git -C ~/Claude config core.hooksPath .githooks`. Test it: create a scratch file
   with `printf 'api_key = "%s"\n' TESTTESTTESTTESTTEST > hook-test.txt`, stage it, show that the commit is
   blocked, then unstage and delete the scratch file.
4. Git identity. Ask whether they want commits under their work identity, personal identity, or both by
   folder. Set `user.name` and `user.email` globally for the default; if both, add an `includeIf
   "gitdir:~/dev/work/"` block (trailing slash required) pointing at a second include file. Recommend a
   GitHub noreply address over a real email.

## Stage 3 · Personal instructions (`~/.claude/CLAUDE.md`)

1. If `~/.claude/CLAUDE.md` exists, show it and ask whether to merge.
2. Otherwise fill `KIT/TEMPLATES/user-CLAUDE.md` with the Stage 0 answers, then ask three questions one at a
   time and add the answers: how they like output (short or detailed, bullets or prose); one thing they never
   want Claude to do; what they work on outside the org (so it stays separate).
3. Show the result and write it on approval.

## Stage 4 · Guardrails (`~/.claude/settings.json`)

1. Read `KIT/TEMPLATES/settings.json`. If `~/.claude/settings.json` exists, merge: add the kit's `deny` and
   `ask` entries to the existing lists, keep everything the user already has. Show the merged result.
2. Write it on approval. Explain in two lines what the deny and ask rules do and how to change them.

## Stage 5 · The kit's plugins

Run, after one approval:

```bash
claude plugin validate "KIT"
claude plugin marketplace add "KIT"
claude plugin install onboarding@claude-starter-kit
claude plugin install it-admin@claude-starter-kit
claude plugin list
```

Then recommend (do not install without a yes) these from the official marketplace:
`mattpocock-skills` (grilling, tdd, diagnosing-bugs) and Anthropic's `skill-creator`. List anything else in
`KIT/docs/toolbox.md` as optional, with one line each.

## Stage 6 · GitHub (optional, user-driven)

1. If they want the workspace backed up: they run `gh auth login` in their own Terminal (it opens a browser;
   you never see the token).
2. Then, on approval: `gh repo create <name> --private --source ~/Claude --remote origin`, first commit
   ("workspace: initial setup"), push. Confirm the repo is **private** in the output before pushing.

## Stage 7 · Hand off to /welcome

1. Write the final checklist to the setup log, including anything still owed (a sign-in they skipped, a tool
   they declined).
2. Tell the user, in three lines:
   - Open a **new** Code session with `~/Claude` as the folder.
   - Type `/welcome`. It writes the org rules into `~/Claude/CLAUDE.md`, copies the shared docs, interviews
     them, and builds their first real project.
   - Before using real org data: confirm the account is on the org's business plan.

Do not run `/welcome` in this session: it must run with `~/Claude` as the working folder so its `CLAUDE.md`
loads.
