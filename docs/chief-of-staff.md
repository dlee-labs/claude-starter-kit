# Running many sessions: the chief-of-staff model

When you run more than three or four Claude Code sessions at once, the problem stops being Claude and
becomes keeping track. This pattern has held up.

## The roles

- **Hub session** (pinned, one only). Never does the work. Keeps `PROJECTS/chief-of-staff/board.md` (live,
  waiting, done), starts job sessions with a short brief, answers "what's next?"
- **Job sessions.** Each owns one bounded task in one project folder and ends with a report: what changed,
  the commit, anything the hub must do.

## The rules that make it work

1. **One writer per shared file.** Only the hub edits the board. Other sessions drop a new small file in
   `PROJECTS/chief-of-staff/inbox/`; the hub folds them in. Two sessions editing one file loses work.
2. **Names show state.** Titles follow `Area · topic`. A session waiting on you carries a marker (for example
   a leading hourglass) so the sidebar shows what needs you.
3. **A protocol file.** `REFERENCE/session-protocol.md`: how a session starts (read the brief and the
   project README), works, and closes (commit, report, title marked done). Change a rule there only.
4. **Roll the hub before it gets heavy.** Around 40% of its context, the hub writes a handoff note and a fresh
   hub starts from it.
5. **Status lives in project READMEs,** never only in the board. The board points at them.

## Start small

Week one: a pinned session and a `board.md`. Add the inbox when two sessions collide; add the protocol when
you catch yourself repeating the same instructions to new sessions.
