# PROGRESS — Ona Scam Hub

The learning chat reads this at the start of every session and updates it at the end. It is the state that survives between chats. Keep it short and factual.

## Current position
- Last update: Mon 23 Nov 2026, about 00:45 (learner's time, UTC+2)
- Week / day: W0 wrap-up. Next: W1 Day 1 (Mon 23 Nov, later today): warm-up on requirements, then relational model and normalisation (1NF to 3NF).
- Milestone: M0 Foundations: all criteria evidenced EXCEPT two open items (below). Sign off once they are done.
- Sunday 22 Nov block: Quiz 0 done (8/9, 89%, pass); fix-weak-spots done (3/3); M0 check in progress.
- Open M0 items: (1) output of `Select-String -Path docs\user-stories.md -Pattern '^### Story' | Measure-Object` was not shown; it must count 15. (2) `docs/NOTES.md` has no entry for the status-model gaps (what happens after a rejected appeal, re-report after delist), marked "proposed, not decided"; the learner writes it (Context, Options, Decision, Consequences, How to test).
- Then: replace `docs/DECISION_LOG.md` with the updated file (adds D-PHONE-01, S5, X3 and the proposed list P1 to P8); update two stale README lines (progress row "In final review" becomes "Done"; the layout line says NOTES.md holds the user stories, it should list `user-stories.md` and `ARCHITECTURE.md`); commit with a conventional message; tick Quiz 0, fix weak spots and M0 in the tracker.

- Last update: Mon 23 Nov 2026, about 23:30 (learner's time, UTC+2)
- Week / day: W1 Day 1 (Mon 23 Nov), in progress. Done: warm-up, M0 close-out, normalisation study, 3NF drill.
- Milestone: M0 Foundations: DONE (user-stories count = 15; status-model NOTES entry written, pending commit).
- Next: build block (ERD v1 on paper: 14 tables), six gaps decided, wrap-up.
- Open M0 items: none, once the NOTES.md entry and README fixes are committed.

## Environment (verified 23 Nov)
- Windows 11, VS Code terminal (PowerShell). git 2.53.0, Python 3.14.6, psql 18.7, PostgreSQL 18.7 server running (login works, user postgres), Node 24.18.0.
- Repo: C:\Users\fyaupi\Music\Ona-Scam-Hub, remote https://github.com/FAP5iVE/ona-scam-hub (public, 7 commits on GitHub, README renders).
- Latest commits: 6886593 "docs: W0 documents addition and the erd-v0.svg", deaf9b5 "docs: add README stub with M0 status". Working tree clean at 00:32 on 23 Nov.
- Repo files: `.env.example` (1 line), `.gitignore`, `README.md`, `_sandbox/`, `backend/`, `db/`, `frontend/`, and under `docs/`: `ARCHITECTURE.md` (18 lines), `DECISION_LOG.md`, `MASTER_PLAN.md`, `NOTES.md` (N-01 to N-04, D-PHONE-01, ERD v0 triage, privacy re-check, Quiz 0), `user-stories.md`, `erd/erd-v0.svg`.

## Hours
Learner logs these; not verified by the tutor.
| Week | Planned | Logged | Notes |
|---|---|---|---|
| W0 | 19 | Day 1: 2.18 h; Days 2 to 5: learner to fill in | Fri and Sat tasks were caught up on 21 to 22 Nov, running past midnight on 22 to 23 Nov. |
| W1 to W11 | 28 / 28 / 28 / 28 / 26 / 26 / 28 / 28 / 28 / 28 / 28 | | |

## Exam and checkpoint scores
| Date | Type | Score | Result |
|---|---|---|---|
| Sun 22 Nov | Quiz 0 | 8 / 9 (89%) | PASS |
| Sun 22 Nov | Fix-weak-spots drill | 3 / 3 | done |
| Mon 23 Nov | W1D1 warm-up Q1/Q2 | 2/2 | PASS |
| Mon 23 Nov | 3NF drill | table list correct, 4 corrections | done |


Result is one of: PASS (75+), FIX (70 to 74, redo the weak section only), REMEDIAL (below 70).

## Remedial status
- Active? (yes/no): no
- Redo score needed to clear: 80%

## Done so far
- 18 Nov: toolchain installed and verified, repo created, folder skeleton with `.gitkeep`.
- 19 to 21 Nov: Git merge-conflict drill (`toy-git`); psql basics; phones CRUD drill (`_sandbox/2026-11-21_phones.sql`); `.gitignore` `.env.example` re-include fixed; scam-domain and number-format study; D-PHONE-01 note (Option C).
- 22 Nov: requirements study; status-model drill (`_sandbox/2026-11-22_status-model.md`); 15 user stories locked in `docs/user-stories.md`; ERD v0 (`docs/erd/erd-v0.svg`) with a 10-point triage for v1; privacy re-check of all stories; README corrected; docs committed and pushed; Quiz 0 and fix-weak-spots done.

## Concepts: shaky or misunderstood
Learner's own wrong models, in their words, to re-test later.
- SERIAL versus PRIMARY KEY (third time). Said an INSERT with a manual `id` fails "because SERIAL assigns a default". Corrected: SERIAL only fills `id` when it is omitted; the PRIMARY KEY rejects a duplicate value. Fix-drill 3/3 (manual id does not move the sequence; a later default id can collide). Re-test on Tue 24 Nov with constraints.
- `git status` after a commit: described the state before the commit (staged plus modified). After the commit only the later edit shows, as modified and not staged. Three-places table (working tree, staging area, last commit) answered correctly afterwards.
- Quiz Q4: forgot the `days` values in the SELECT output (trace step skipped). Re-test with a full trace.
- Q1 reason for status flipping: "reports processed one at a time" is only true if the app serialises them (race drill Thu 3 Dec). Learner stores `status` on Identifiers; drift risk noted.
- Earlier, now solid: UPDATE syntax (SET before WHERE) correct in Quiz 0; DELETE boundary; role of Visitor versus Reporter on reviews; independence rule (Story 1 contradiction fixed).
- ERD: `tags` stored as a string breaks 1NF; to normalise Mon 23 Nov (junction tables).
- Earlier (18 to 21 Nov): staging versus push; `.env` pattern does not match `.env.local`; empty folders need `.gitkeep`; a failed statement in a psql file does not stop the rest; omitting `id` in INSERT is allowed when SERIAL.
- SERIAL vs PRIMARY KEY: warm-up Q2 correct this time (model now right). Re-test Tue 24 Nov with constraints before marking solid.
- 2NF: said it holds because of a composite key in report_tags; it is trivially true for a one-column key. Re-test with a composite-key example.
- Normalising is not enough: UNIQUE constraints are needed too (reporter_phone, phone_number).
- Stored vs derived (carrier): corrected to derive from the prefix; still has to decide it for `identifiers.status`.
- git status after `git add`: correct. Remember two lists (staged and unstaged).

## Bugs the learner hit (layer plus cause)
- PowerShell: pasted a command with an interpreter path prefix; `New-Item -Name a, b, c` takes one string; angle-bracket placeholders are reserved; `Get-Content` extra argument.
- Git CLI: `git commit "message"` without `-m` was read as a pathspec; `git commit` with nothing staged; `git push` said "Everything up-to-date".
- Repo hygiene: `docs/erd/ARCHITECTURE.md` filed under `erd/` and a space in `erd v0.svg` (both fixed in the 22 Nov commit); one non-conventional commit type earlier ("patch").

## Decisions pending
- D4 (Sat 28 Nov): how identifiers are stored for lookup; lean (c) HMAC key plus restricted raw value. The learner decides.
- D5 (Week 6), D7 (Week 6, Story 11 proposed), D8 (Week 9).
- Proposed, not decided: P1 to P8 in `docs/DECISION_LOG.md` (recompute status after a rejected appeal, fresh cycle after delist, `retracted` rows with a partial unique index, superseded versus cycle column, HIGH_RISK downgrade path, Story 6 masking, retention, reply moderation).
- ERD v1 open points (brands table, roles, OTP table, one verified claim per identifier, appeal concurrency, stored versus derived status): decide between Mon 23 and Sat 28 Nov.
- ERD v1 gaps 1 to 6 (see 23 Nov review) decide before Sat 28 Nov.
- Plain UNIQUE (reporter, identifier) vs P2/P3: revisit in Week 6.

## Notes for the next session
- Start: confirm the two open M0 items, commit, tick the tracker, then run `/start-day` for W1 Day 1 (Mon 23 Nov): warm-up on "Requirements" (predict the output or find the bug), then normalisation. Sleep first: the plan requires at least 7 h.
- W1 plan: Mon normalisation (use the ERD triage); Tue DDL and constraints including partial unique index (P3, one open appeal, one verified claim); Wed joins and about 200 synthetic rows (obviously fake numbers only); Thu subqueries and the 3-independent-accounts rule in SQL; Fri migrations and schema v1 draft (identifier lookup column undecided); Sat D4 study, drill and decision, finish schema v1 and ERD v1, mentor review; Sun checkpoint and M1 check.
- Quiz and warm-ups should keep re-testing: SERIAL versus PRIMARY KEY, the three places in Git, full output traces.
- Remind: predict before running; `-m` on commits; never type `<placeholders>`; log D-PHONE-01 prefix verification against an official source in Week 1.