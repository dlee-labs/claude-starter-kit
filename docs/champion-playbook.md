# Champion playbook: rolling Claude out to your organization

For the person bringing Claude into an org. What would have saved the most time on day one.

## Order of operations

1. **Your own setup first** (SETUP.md, then `/welcome`). Use it for real work for two weeks before anyone else.
2. **The policy before the pilot.** Fill in `CONTEXT/ai-use-policy.md` and `ai-rules.md`, name the reviewer,
   and take section 9's decisions to leadership. A pilot without a policy becomes the policy.
3. **Business plan before org data.** Team, Enterprise or an education agreement: no-training terms, admin
   console, SSO, seat management. Consumer accounts are banned for org data, and say why when you announce it:
   the realistic risk is a well-meaning person pasting a class list into a free chatbot.
4. **Pilot with two or three people** whose time sinks you know. Run `/welcome` beside each of them. Their
   first project is the demo for everyone else.
5. **One canonical source.** This repo holds the rules, the voice and the skills. Everyone installs from it.
   Fixes go here, and everyone gets them on update.
6. **Default-deny new tools,** with a fast path: a request note (what, why, which data) and a yes or no within
   a week. Slow approvals teach people to route around you.
7. **Ninety-day review:** what people actually use, what they asked for, what broke, what the policy got
   wrong.

## Principles behind the kit

- **Rules in files, not in people's heads.** A `CLAUDE.md` loads every session whether anyone remembers.
- **Three layers:** the rules file is culture; platform settings and credential scope are the guarantees.
- **Propose, approve, act.** Every write and every send. It is what makes a fooled model harmless.
- **Access mirrors the system of record.** AI never sees more than the person could already see.
- **Over-refusing is a failure.** Teach the closed doors precisely so everything else proceeds.
- **Credentials by what they open.** Personal sign-ins with the person; org-wide keys on the server.
- **Scheduling is a promise.** Jobs the org depends on run on a machine that is always on.
- **Status in a README ledger; corrections in files; commit every session.** Transcripts are not storage.
- **Skills are procedures plus scar tissue.** Write them after the second time.

## Explaining Chat vs Code to staff

Most staff will use Chat (and Cowork): conversation, uploads, connectors, and pages Claude builds. Show them
three things: the connectors they are allowed, how to share part of a file safely, and that Claude drafts
and they send. Code is for the people who own scripts, systems or a whole document workspace.
