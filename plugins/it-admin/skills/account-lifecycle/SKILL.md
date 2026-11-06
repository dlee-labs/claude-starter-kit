---
name: account-lifecycle
description: "Google Workspace user lifecycle for staff and students: onboarding batches, moves between OUs and groups, and the end-of-year cleanup (graduating and departing students, departing staff). Builds a reviewed proposed-actions list from Admin exports and the roster, then runs it in reversible stages with GAM or the Admin SDK: suspend, transfer Drive and data, wait, delete. Use when someone says 'end of year cleanup', 'offboard', 'graduating students', 'deprovision', 'new student accounts', 'bulk create users', 'move these users to an OU', or mentions GAM."
---

# Account lifecycle

Bulk account changes are where one wrong join deletes a teacher. The shape is always: export, diff, propose,
review, act in reversible stages, keep the list.

## Tools

- **GAM** (the open-source Google Workspace admin CLI) or the **Admin SDK Directory API** from Python.
- The admin credential lives on the always-on server (or as the admin's own GAM OAuth sign-in on their own
  machine), never pasted into a session. Writes are `ask` in settings; deletes are `deny` in the kit's
  starter settings, so the delete stage runs by the admin's own hand or after they lift that rule on purpose.

## 1 · Inputs (into `PROJECTS/eoy-cleanup-YYYY/1-source/`)

- Current accounts by OU (GAM `print users` with orgUnitPath, suspended, lastLoginTime, creationTime).
- The roster of who should exist: SIS export of continuing students, the staff list from HR. Name the system
  of record for each.
- The rules for this year, in writing: which grade leaves, grace period, where Drive data goes, which
  accounts are exempt (service accounts, shared mailboxes, board members).

## 2 · Diff and propose

In code (`2-working/`), produce `proposed-actions.csv` with one row per account: email, OU, current state,
proposed action (`keep`, `move`, `suspend`, `transfer-then-delete-after`), reason, and the matching roster row.

Check before showing:
- Every account in an action row has a reason that cites the roster (or its absence).
- **No staff account is proposed for suspension from a student roster diff.** Staff and students are diffed
  separately.
- Accounts with recent logins that the roster says are gone are flagged for a human, not suspended.
- Totals per action and per OU, so the reviewer can sanity-check the scale.

## 3 · Review

Show totals, then every row in the action set (the reviewer reads the list, not a sample). Edits go back into
the CSV. The approved CSV is copied to `3-final/` with the date and approver; that file is the record.

## 4 · Act in stages, each its own approval

1. **Suspend** (reversible). Dry-run first: print the exact commands for review. Then run.
2. **Transfer** Drive and data per the written rule, verify transfers completed.
3. **Wait** the grace period. Record the date the delete stage becomes allowed.
4. **Delete** only from the approved list, only after the grace period, and only rows still suspended.

Nothing outward in the same motion: if users or families should be notified, that is a separate, approved
message, drafted only.

## 5 · Close-out

Ledger: counts per stage, dates, approver, and any exceptions. Delete raw exports per policy; keep the
approved action list without extra personal fields if the policy allows, else a counts-only summary.
