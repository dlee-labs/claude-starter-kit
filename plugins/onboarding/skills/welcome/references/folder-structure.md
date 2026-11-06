<!-- synced: 2026-11-05 from claude-starter-kit CONTEXT/folder-structure.md. Build artifact, do not hand-edit. -->
# How we organize the Claude working folder

One rule underneath everything: **everything about a piece of work lives inside that work's project
folder.** What you were handed, what you drafted, what you sent. If you have to look in two places to
understand one project, the structure has failed.

## The shape

```
~/Claude/                 your working folder (its own private git repo if you use git)
  CLAUDE.md               the rules, loaded automatically in every session
  CONTEXT/                who we are and how we work; rarely changes
    my-profile.md         who you are and what your job is; never shared
    my-preferences.md     how you want Claude to work with you; grows over time
  PROJECTS/
    <project-name>/
      README.md           what this is, where it stands, which file is current
      CLAUDE.md           optional: facts and decisions true of THIS project only
      1-source/           what you were given; never edited
      2-working/          drafts, notes, analysis; messy is fine
      3-final/            what went out, or is ready to
  ROUTINES/               output from recurring work, one folder per routine
  REFERENCE/              durable how-tos and runbooks that belong to no project
  ARCHIVE/                finished projects, moved here whole
~/dev/                    code, one git repo per tool (never inside ~/Claude)
```

Create `ROUTINES/`, `REFERENCE/` and `ARCHIVE/` the first time you need one.

## Why the numbers

They put the folders in the order work moves. `1-source/` is read-only: the export, the vendor PDF, the
config dump. Change a copy in `2-working/`. `3-final/` is the answer: if someone asks what was decided,
that folder holds it.

## The README ledger

Every project README starts with the same five lines, so any session (and any person) can tell where it
stands in ten seconds:

```markdown
**Status:** Active | Parked | Delivered
**Current:** <the file that is current>
**Last touched:** YYYY-MM-DD
**Next action:** <one line>   (or **Wake condition:** for Parked)
**Related:** <other projects>
```

Status lives here and nowhere else. Not in Claude's memory, not in a chat, not in your head.

## Project CLAUDE.md

Create one the first time you correct the same project detail twice. It holds facts only true of this
project. Never restate org context in it (no rules, no voice guide, no roster): that has one home already.

## Sensitive material

Confidential exports (account lists, logs, monitoring CSVs) may sit in a project's `1-source/` while the work
is live. They never go into git, never onto a shared or public link, and are deleted when the project closes.
The kit's pre-commit hook blocks the common ones.

## Code

A script that is reused, scheduled, or shared gets its own repo in `~/dev/`, with its plan in that repo's
`docs/plans/`. The project folder keeps a pointer to it.
