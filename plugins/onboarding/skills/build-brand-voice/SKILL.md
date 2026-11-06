---
name: build-brand-voice
description: "Build or refresh the organization's brand voice file (CONTEXT/brand-voice.md) from real writing samples, through a short interview: collect on-voice samples, describe the voice from them, write audiences, exemplars, a format guide per container (parent email, newsletter, website, announcement, social), and a banned list including AI tells. Also reviews a draft against the voice. Use when someone says 'make Claude sound like us', 'brand voice', 'style guide', 'voice guide', 'our emails sound like AI', or 'check this against our voice'."
---

# Build the brand voice

Voice is learned from examples, not adjectives. "Warm and professional" teaches nothing; three real
paragraphs teach everything.

## 1 · Samples

Ask for 10 to 20 pieces leadership considers on-voice: parent emails, newsletter articles, the welcome
letter, a well-received announcement, website pages. Pasted text or files in
`PROJECTS/brand-voice/1-source/`. Strip names of students and families before using any of them; a name in an
exemplar travels into every future draft.

Also ask for two or three pieces that felt *off*, and what was wrong with them. Contrast teaches fast.

## 2 · Describe it back

Read all samples, then describe the voice in plain observations the user can check: sentence length, how
pieces open and close, warmth vs formality, how they handle bad news, words that recur, words that never
appear, how they address parents vs staff vs students. Ask the user to correct the read. One round of
corrections, then write.

## 3 · Write `CONTEXT/brand-voice.md`

Sections:
1. **Who we write to** (audiences, and what each needs).
2. **The voice in five lines,** each with a short real example.
3. **Exemplars:** three to five sanitized paragraphs, verbatim.
4. **Format guide per container:** parent email, newsletter, website page, announcement, social post. Length,
   structure, sign-off, what to always include (date, time, place, a contact).
5. **Banned list:** the org's own pet hates, plus common AI tells: "delve", "navigate", "landscape",
   "tapestry", "in today's fast-paced world", "not X, but Y" constructions, rule-of-three padding, em-dash
   asides, closing summaries that repeat the piece.
6. **Hard rules** for anything published (e.g. never a student's full name with a photo; dates written as
   [FORMAT]).

Keep one copy, in the kit repo's `CONTEXT/`, so every person's tools read the same file. Never a second copy.

## 4 · Review mode

When asked to check a draft: read `brand-voice.md`, then return blockers (rule breaks), recommended edits
(shown inline), and what to leave alone. Preserve the author's substance and sound.
