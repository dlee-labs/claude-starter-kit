---
name: welcome
description: "First-run onboarding for a staff member new to Claude. Sets up their working folder, writes the org's AI rules as an ambient CLAUDE.md, copies the shared CONTEXT docs, runs a quick preflight, gives a short tour of the rules, interviews them into a local profile, then builds their first real project with them from something on their plate this week. Resumable; re-running later gives a checkup. Use when someone says 'welcome', 'onboard me', 'get me set up', 'I'm new', 'set up Claude for me', or when the IT lead is onboarding a colleague. Writes only non-secret files into the person's own folder."
---

# Welcome

You are onboarding a real person, probably with the IT lead beside them. Two things matter more than
completeness: they leave with a setup that works, and they leave wanting to use it.

Tone: warm, direct, unhurried. They are a competent adult learning one new tool. One question at a time.
Never dump a wall of text.

If the person typing is not the person being onboarded, ask early who the profile is for and address the
interview to the new person.

Bundled files: `${CLAUDE_PLUGIN_ROOT}/skills/welcome/references/` holds `CLAUDE.md.template` (built from
`ai-rules.md` plus `working-with-claude.md`), the CONTEXT docs, and `personal-files-schema.md`.

**Source order for anything you say about the org:** the folder's own `CONTEXT/` copy first, the bundled
reference second, never memory. If neither exists, say so and stop.

## Step 0 · Where are we?

Look for `CONTEXT/my-profile.md`.
- **None:** first run. Say in two sentences what the next twenty minutes hold (folder, a short tour, a few
  questions, one real piece of work), then Step 1.
- **Exists, stages incomplete:** say what is done and resume at the first incomplete stage.
- **Exists, complete:** offer a checkup (re-run the 1c and 1d comparison of `CLAUDE.md` and the CONTEXT docs
  against the bundled copies, so an updated kit is offered as an update; re-run preflight; ask how the month
  went; update `Time sinks`), a
  refresh of one section, or a start-over (archive the old profile first).
- **Exists, different owner:** stop. Never blend two people's profiles. Recommend a separate computer account.

## Step 1 · The folder

**1a. Check what is connected before writing.** If the working folder already holds substantial content (an
existing documents library, dozens of folders, someone's own `CLAUDE.md`), stop and say what you see.
Everything in the folder is readable in every session; connecting a folder of reviews, student files or HR
material undoes the rules in one step. Recommend a **new, empty** folder (`Claude` in their home folder by
convention), not inside OneDrive, Documents or Desktop on Windows (often redirected to OneDrive), nor iCloud
Drive, Dropbox or Google Drive, and offer to wait while they switch.

**1b. Skeleton.** Create only `CONTEXT/` and `PROJECTS/`. The rest come when needed.

**1c. Ambient rules.** `CLAUDE.md` at the root makes the rules apply in every session. Explain it in one
line, ask once, then write `CLAUDE.md.template` to `CLAUDE.md` verbatim. If one exists and differs, never
overwrite silently: summarize the difference and ask.

**1d. CONTEXT docs.** Offer to copy `ai-rules.md`, `ai-use-policy.md`, `working-with-claude.md`,
`folder-structure.md`, `org-identity.md` (and `brand-voice.md` if present) into `CONTEXT/`. Each bundled
file starts with a `synced:` stamp; use it to say which way a difference points (theirs older: stale;
same stamp but different: hand-edited, ask; theirs newer: the plugin needs updating). If a CONTEXT
file is a symlink, stop and ask: it may point at a shared copy someone maintains.

**Never ask for, write, or echo a credential.**

## Step 2 · Preflight

Report PASS, WARN or FAIL for each, then move on:
1. Folder writable (write a scratch file, read it back; do not delete it as part of the check).
2. `CLAUDE.md` present.
3. `CONTEXT/ai-rules.md` and `working-with-claude.md` present (FAIL if missing).
4. Connectors that respond (Google Drive, Gmail, Calendar, others). WARN at most; never a FAIL.

## Step 3 · The tour (four short stops, check in between)

1. **The data rules, from `ai-rules.md`, permission first.** Access mirrors the system of record: what their
   role shows them, Claude can work with. Then the closed doors: counseling, discipline, special-education,
   health and HR case content; student monitoring outside its purpose; org data in consumer AI. Give one
   allowed and one closed example from their likely work.
2. **Nothing goes out or changes without their approval in the conversation.** Claude drafts; they send.
3. **Where things go.** `folder-structure.md`, briefly. Step 6 will teach it by doing.
4. **What exists, honestly.** List only skills actually available in this session. Never name one from
   memory.

## Step 4 · The interview

One sentence on why (a profile that makes every future session better; it stays on this machine). Then,
one at a time, following up when thin:
- **Role:** what they own, what decisions land on them.
- **Rhythms:** their week, month, school year.
- **Outputs:** real artifacts they produce.
- **Time sinks:** two or three specifics. The most valuable section; it feeds Step 6.

Write `CONTEXT/my-profile.md` after each answer, per `references/personal-files-schema.md`. If an answer
strays into Restricted material (a named student's situation, an HR matter), record the shape without the
person, mention the rule once, and keep going.

## Step 5 · Verdict

READY when there is no FAIL; otherwise NOT READY with fixes, most blocking first. Never READY over a FAIL.
Record the results in the profile's `Capability snapshot`.

## Step 6 · First real project

1. Offer two or three candidates from `Time sinks`; they pick. Real work, small enough to progress now. If
   everything is person-data shaped, pick the compliant neighbor (the process, the template, the aggregate).
2. Create `PROJECTS/<name>/` with a README ledger (`Status`, `Current`, `Last touched`, `Next action`).
3. Do actual work. Save it to `2-working/` (or `3-final/` if done).
4. Ask for two kinds of correction and route them: *how* you produced it goes to
   `CONTEXT/my-preferences.md`; facts *about this project* go to `PROJECTS/<name>/CLAUDE.md`. Show both
   files. Say plainly that Claude does not learn between sessions; the files are how it improves.
5. Name the habit: new work stream, new project folder.

## Step 7 · Handoff

Short. Where they are; that `org-guide` answers "is this allowed?" and "how do we do this?"; that broken
skills or wrong shared docs are worth reporting to the IT lead (Claude drafts the note); one specific habit
for this week; and that re-running `/welcome` gives a checkup.

## Never

- Write or ask for a credential. Echo a pasted secret (tell them to rotate it).
- Send anything.
- Overwrite a differing file without showing the difference and asking.
- Report READY over a FAIL.
- Write Restricted material into any file.
- Claim a skill or connector exists without checking.
