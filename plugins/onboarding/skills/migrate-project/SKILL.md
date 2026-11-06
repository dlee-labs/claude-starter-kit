---
name: migrate-project
description: "Move a claude.ai Project (or a long hand-written mega-prompt from any AI tool) into a Claude Code project folder: standing facts and rules go to CLAUDE.md, repeatable procedures become skills, knowledge files land in 1-source/, and a README ledger records where it stands. Use when someone says 'move my Project over', 'convert this prompt', 'I have a big Gemini/ChatGPT prompt for this', 'turn my Project instructions into a skill', or pastes a long instruction block and asks what to do with it."
---

# Migrate a Project or mega-prompt

A long prompt is context with nowhere to live. Give each piece its home, and the prompt shrinks to a
sentence.

## 1 · Collect

Ask for, one at a time:
1. The instructions text (paste it).
2. The knowledge files (download them; put them in `PROJECTS/<name>/1-source/`). If any hold person-level
   data, apply `ai-rules.md` before reading: Restricted material does not come over at all.
3. Any chats worth keeping: ask the user to have Claude in that chat summarize the decisions made, and paste
   the summary.

## 2 · Sort every sentence of the instructions

| The sentence is... | It goes to |
|---|---|
| About who the user is or how they want output, true everywhere | `~/.claude/CLAUDE.md` or `CONTEXT/my-preferences.md` |
| An org rule already in `ai-rules.md` | Nowhere (say so; a copy would drift) |
| A fact or constraint true of this work only | `PROJECTS/<name>/CLAUDE.md` |
| A step-by-step procedure the user repeats | A skill (step 3) |
| Role-play framing ("You are an expert...") | Drop it, and say why: the files carry the expertise now |
| Output formatting tricks for a weaker tool | Drop unless the user still wants that shape |

Show the sort as a table before writing anything. The user approves or moves lines.

## 3 · Write the skill(s)

For each procedure: `skills/<kebab-name>/SKILL.md` in the user's personal skills (`~/.claude/skills/`) or,
if the team needs it, proposed for the kit repo. Frontmatter `name` and a `description` written as the
words the user would actually say when they need it. Body: the steps, the traps with their reasons, what
done looks like, and what never to do. If Anthropic's `skill-creator` skill is installed, use it to draft and
test.

## 4 · Ledger and test

1. Write `PROJECTS/<name>/README.md` from the template (`Status`, `Current`, `Last touched`, `Next action`).
2. Test: start the same kind of task with a one-sentence ask and no pasted prompt. Compare the result with
   what the old prompt produced. Fix the gap in the file where it belongs.

## 5 · Retire the old copy

The folder is now the source. If non-technical staff still need the claude.ai Project, keep it as a copy and
note in the README that the folder wins and the Project is refreshed from it.
