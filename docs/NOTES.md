## N-01: No ORDER BY means no guaranteed row order (21 Nov 2026)

### Context
In the `toy` database, `SELECT * FROM books` returned ids in the order
2, 3, 4, 1. Dune (id 1) came last, and it was the row I had updated on
Thursday.

### Options considered
- Rely on the order rows happened to come back in.
- Always add an explicit `ORDER BY` when order matters.

### Decision
Always use `ORDER BY` when the order matters (lookups, "latest report",
paginated lists).

### Consequences
An UPDATE writes a new version of the row into free physical space, so a
sequential scan without `ORDER BY` returns rows in their current physical
disk order, not insertion order. That order can change at any time, so any
code that depends on it will break silently.

### How to test
Run `SELECT * FROM books;` before and after `UPDATE books SET ... WHERE id = 1;`
and compare the order. Then add `ORDER BY id` and confirm it is stable.

---

## N-02: .gitignore re-include for .env.example (20 Nov 2026)

### Context
I wanted `.env.*` ignored (real secrets) but `.env.example` committed
(a safe template). `git check-ignore -v .env.example` still showed it as
ignored by the `.env.*` line.

### Options considered
- Leave `.env.example` ignored and share it some other way.
- Add a re-include line `!.env.example`.

### Decision
Add `!.env.example` after the `.env.*` line.

### Consequences
`.env.*` also matches `.env.example`, so it is ignored by default. A `!`
re-include only works when it comes AFTER the broader rule; the last
matching rule wins. Wrong order means the file stays ignored.

### How to test
`git check-ignore -v .env.local` should print the `.env.*` rule (ignored).
`git check-ignore -v .env.example` should print the `!` line or nothing,
and `git status` should show `.env.example` as untracked or tracked, not
ignored.

---

## N-03: Repo is private first, public later (18 Nov 2026)

### Context
GitHub repo `ona-scam-hub` exists with early, messy commits.

### Options considered
- Public from day one.
- Private now, public later.

### Decision
Private for now. Why: [FILL: your reason].

### Consequences
Nothing is public until I choose to flip it. Proposed point to flip it:
before any public launch, after the privacy checks and the lawyer review
described in MASTER_PLAN section 4. [FILL: confirm or change this]

### How to test
GitHub repo Settings shows visibility as Private. Re-check before sharing
the link with anyone.

---

## N-04: SERIAL fills the id; psql keeps going after an error (21 Nov 2026)

### Context
My warm-up predictions assumed two things that were wrong. I thought
leaving `id` out of an INSERT would fail because a primary key cannot be
null. I also thought a failed CREATE TABLE stops the rest of a file.

### Options considered
Not a design choice; these are corrected models.

### Decision
Remember the correct behaviour:
- `id SERIAL PRIMARY KEY` fills the id automatically from a sequence
  (`nextval(...)` as the column default). The INSERT in my toy file would
  have worked on a table built from that file.
- My old `books` table rejected the INSERT because its `id` had no default
  [CONFIRM: check with `\d books` and write what the Default column shows].
- `psql` runs the next statement after an error in a file unless
  `ON_ERROR_STOP` is set. This matters for migrations: a half-applied
  migration is possible.

### Consequences
Migration runs should use `ON_ERROR_STOP` (and ideally a transaction), so a
failure stops the file instead of leaving a half-built schema.

### How to test
Run a file with a bad first statement and a good second one, with and
without `\set


## D-PHONE-01: Malawi phone validation vs prefix allowlisting (21 Nov 2026)

### Context
Ona must accept any real Malawi number a buyer wants to check before sending
money. Prefix blocks are reported to have been added after the 2017 ITU filing
(089 and 098; see verification notes), and the Communications (Numbering)
Regulations, 2019 define number portability, so a prefix cannot be treated as
a permanent carrier identifier. Wrongly rejecting a real number defeats the
app's purpose.

### Options considered
- A. Structure only: accept any 9-digit national number starting 1-9 or a
  7-digit MTL landline; new prefixes work at once, unallocated ones are
  accepted silently.
- B. Strict prefix allowlist: catches typos, but blocks real numbers from
  newer allocations until the code is updated.
- C. Structure decides acceptance; a separate updatable prefix table gives
  only a soft "Unrecognised prefix, double-check the number" hint and a
  provisional carrier hint, never a rejection.

### Decision
Option C. Blocking a real lookup is the worse failure; a soft hint covers
typos without that cost.

### Consequences
- Any structurally valid +265 number is accepted before MACRA circulars are
  added to the prefix table.
- Normalisation/validation is one pure function with no carrier data; the
  prefix table is data and can change on its own.
- Carrier shown only as an initial-assignment hint (portability).
- Trade-off: a mistyped number that stays structurally valid is looked up as
  UNKNOWN; case 12 below is accepted although prefix 26 is unallocated in
  the ITU table, so it should trigger the soft warning.

### Normalisation rules (Malawi, +265)
0. Strip spaces, hyphens, parentheses, dots.
1. Leading 00 becomes +.
2. No +, starts with 265, total 10 to 13 digits: prepend +.
3. Still no +: prepend +265.
4. Starts with +2650: strip that single 0 (+26500... is left for step 5 to reject).
5. Accept only if it matches ^\+265[1-9][0-9]{8}$ or ^\+2651[235-9][0-9]{5}$.

### How to test
| # | Raw input | Expected | Reason |
|---|---|---|---|
| 1 | +265 999 000 001 | +265999000001 | E.164 with spaces |
| 2 | 0888-000-002 | +265888000002 | trunk 0 and hyphens |
| 3 | 00265 981 000 003 | +265981000003 | 00 prefix; 098 range accepted by structure |
| 4 | +265 (0) 899 000 004 | +265899000004 | kept trunk 0; 089 range |
| 5 | 265991000005 | +265991000005 | country code without + |
| 6 | 995 000 006 | +265995000006 | bare 9-digit number |
| 7 | +265 1 600 007 | +2651600007 | 7-digit MTL landline |
| 8 | 01 600 008 | +2651600008 | landline with trunk 0 |
| 9 | 0999 000 09 | REJECT | only 8 digits after trunk 0 |
| 10 | +265 888 00O 010 | REJECT | letter O |
| 11 | 0265 991 000 005 | REJECT | extra leading 0, too long |
| 12 | +265 265 000 001 | +265265000001 | accepted by structure only; prefix 26 unallocated per ITU, soft warning expected |
| 13 | +26500888000002 | REJECT | double 0 after +265 |

### Regulatory and prefix verification (21 Nov 2026)
- Source: ITU-T National Numbering Plan for Malawi (+265), communications of
  15.XII.2008, 2.XI.2011, 11.XII.2017:
  https://www.itu.int/dms_pub/itu-t/oth/02/02/T02020000800002PDFE.pdf
- Confirmed there: 12 digits total (3-digit CC + 9-digit national number);
  7-digit landlines 1 2, 1 3, 1 5 to 1 9 (no 1 4); 1 11 (MTL), 21 (ACL),
  31 and 88 (TNM), 77 (GAIN), 99 (Zain, now Airtel). Portability: not
  mentioned in this document.
- Number portability definition: Communications (Numbering) Regulations,
  2019 (GN 23 of 2019, Gazette Supplement 10A, 28 June 2019), Regulation 2
  (Interpretation), Gazette p. 145 (PDF p. 3). Checked by the learner.
- 022: UNVERIFIED. Not in the ITU PDF; not confirmed in public operator
  disclosures.
- 089: UNVERIFIED / OBSERVED IN USE. Not in the ITU PDF. TNM rollout reported
  Nov 2022. Source URL: TO ADD.
- 098: UNVERIFIED / OBSERVED IN USE. Not in the ITU PDF. Reported in Airtel
  Malawi 2021 results. Source URL: TO ADD.
- Prefix-to-operator mapping stays provisional; not used in validation or seed files.

Story 6 mask: the rule only covers phone numbers. Either say the feed lists PHONE identifiers only for now, or define masks for email, social handle and URL. Also, your claim about "2-digit carrier prefix" assumes a prefix structure that the plan says must be verified in Week 1, so mark it "verify". 
Story 6 reasoning: the 100,000 figure is true, but weak by itself. The real defence is the mask together with Story 7's rate limit. A scraper who can try 100,000 candidates through lookup is stopped by the 429, not by the arithmetic. Say so in the note. 
Story 2: it covers UNKNOWN, PENDING_REVIEW and HIGH_RISK. UNDER_APPEAL and DELISTED are handled in Stories 10 and 15 and §3.2, but add one line pointing there so a reader isn't left guessing.

## ERD v0 triage: fixes planned for ERD v1 (proposed; v1 due Sat 28 Nov)

`erd-v0.svg` stays untouched as history. These changes go into the working copy for ERD v1.

| # | ERD note | Label | Decision / next step |
|---|---|---|---|
| 1 | `tags` is a string in Reports and MerchantReviews (breaks 1NF) | fix now (normalise Mon 23 Nov) | Replace with a `tags` catalogue plus junction tables `report_tags(report_id, tag_id)` and `merchant_review_tags`, each with a composite primary key. |
| 2 | No `created_at` on Reports, MerchantReviews, Appeals | fix now | Needed for the 5-reports-per-day limit, the 5-minute anomaly hold window (D6) and `last_flagged_at`. Add to every table whose rows have a time order. |
| 3 | `impersonated_brand` is a string | decide later (Week 1) | Curated `brands` table versus a fixed tag list. |
| 4 | Users `phone_hash` versus Identifiers `normalized_val` | decide Sat 28 Nov (D4) | Leave undecided. Both tables need a compatible representation for the rule "reporter differs from the owner" (§3.3). |
| 5 | OTP storage missing | fix now | Add `otp_challenges` (id, purpose, target, code_hash, expires_at, attempts, consumed_at). The `target` representation depends on D4. |
| 6 | Appeals has no decider or decision time | fix now (decider/time), decide Tue 24 Nov (concurrency) | Add `decided_by_user_id` and `decided_at`. "One open appeal per identifier" is a partial unique index, to be studied Tuesday. |
| 7 | Merchants: `badge_level` versus verification state; `is_claimed_by` cardinality | fix now, decide Tue 24 Nov | Separate `verification_status` from `badge_level`. Add `verification_submissions` so private documents and rejection history are not overwritten. A plain UNIQUE on `identifier_id` would block a re-claim after a rejected claim, so the real rule is probably one *verified* claim per identifier (Tuesday). |
| 8 | `merchant_reply` is one column | fix now (lightweight) | Add `reply_mod_status` so a moderator can hide an abusive reply without deleting the review. Trade-off: no record of who hid it or when, except in the audit log. |
| 9 | AuditLogs `target_type` + `target_id` has no foreign key | disagree, keep polymorphic design | One append-only table can track every entity. Trade-off: no database-level referential integrity on `target_id`. Mitigation: a CHECK constraint listing the allowed `target_type` values, and the table stays append-only. |
| 10 | `role` is a single string | decide later (Week 1) | Hierarchical roles versus a `user_roles` table. Rule to keep either way: a merchant must not review their own business. |

Stored-status drift: `identifiers.status` stays stored for fast lookups. Risk: it can drift from the active report count if retractions, rejections or holds bypass the recalculation. Mitigation to decide in Week 2: one function that recomputes status, called everywhere.

## Privacy re-check: gaps found (M0)

All 15 stories pass on the main rules. Three gaps to resolve later:
1. **Retention (rule 4):** no story says how long retracted reports, OTP records and rate-limit data are kept. Decide in Week 1.
2. **Story 7:** the response body must not reveal whether an identifier exists, but response *timing* might. Revisit in Week 5.
3. **Story 12:** a merchant reply could name a reviewer. Replies need the same moderation rule as reviews in Story 13.

## Quiz 0 (Sun 22 Nov 2026): 8 / 9 (89%), pass

| Topic | Result |
|---|---|
| Git: what a commit contains | Correct. |
| Git: `git status` after a commit | Wrong. After the commit only the later edit shows, as `modified, not staged`. |
| Git: `.gitignore` pattern `.env` and `git check-ignore -v` | Correct. |
| Git: `git commit` needs `-m` | Correct. |
| SQL: UPDATE/DELETE trace | Rows right; forgot the `days` values (A 14, B 14). |
| SQL: why `INSERT (id=2, ...)` fails | Wrong reason. Duplicate PRIMARY KEY value, not "SERIAL forbids manual ids". |
| SQL: row order without ORDER BY | Correct. |
| SQL: UPDATE syntax (SET before WHERE) | Correct. |
| Domain: independence rule, retraction recompute, public wording at PENDING_REVIEW | All correct. |

Weak spots: (1) SERIAL supplies a default only when `id` is omitted; PRIMARY KEY is what rejects duplicates. (2) The three places in Git: working tree, staging area, last commit.

## N-05: Status-model gaps: rejected appeals and re-reports after a delist (22 Nov 2026)

**Status: PROPOSED, NOT DECIDED.** Logged as P1 to P5 in `DECISION_LOG.md`; to be decided in Week 6 when the appeals backend is built.

### Context
`MASTER_PLAN.md` §3.2 and §3.6 define how a number gets flagged, appealed and delisted, but they do not say:
- where a number goes when a moderator **rejects** an appeal;
- what happens when a **delisted** number is reported again, and whether old reports still count.

Story 8 adds a complication: a reporter can retract a report (the row is marked `retracted`, never deleted) while the identifier is `UNDER_APPEAL`. So the active report count can change during an appeal.

### Options considered
**A. Appeal rejected**
1. Restore `prior_status` (the status saved when the appeal opened).
2. Recompute the status from the currently active independent reports.

**B. New report after a delist**
1. Old reports still count toward the 3-report threshold.
2. A fresh cycle: old reports no longer count; the first new independent report moves the number to `PENDING_REVIEW`.

**C. Same reporter after a delist** (open sub-question)
1. Mark old reports `superseded` at delist time, so a partial unique index on active reports lets the reporter count again.
2. Add a cycle column and make uniqueness apply per cycle.

### Decision
Not decided. Current proposals:
- **A2, recompute.** If two of three reporters retract during the appeal and the appeal is then rejected, restoring `prior_status` would show `HIGH_RISK` on only one active report. Recomputing prevents a stale status from coming back.
- **B2, fresh cycle.** If old reports counted, a single new report would push a cleared number straight back to `HIGH_RISK` without new agreement. Old history stays in the audit log for moderator context only.
- **C:** undecided. To compare in Week 6 after the partial unique index lesson on Tue 24 Nov.

Also open: why `DELISTED` should be a separate state from `UNKNOWN`, given that both show the same public text. The likely reason (the audit boundary between cycles) needs confirming.

### Consequences
- One function must compute status from active reports, and **every** path calls it: new report, retraction, anomaly-hold decision and appeal decision. Otherwise the stored `identifiers.status` can drift from the real count.
- `prior_status` on Appeals becomes audit information, not the value to restore.
- B2 and C need a way to separate old reports from new ones (a `superseded` status or a cycle marker). This interacts with the partial unique index on (reporter, identifier) for active reports (P3).
- The public never sees these internals: rejected appeals and delists show only the neutral wording from §3.2.

### How to test (when built)
| Scenario | Expected result |
|---|---|
| 3 active reports, appeal opened, 2 retractions, appeal rejected | `PENDING_REVIEW` (recomputed from 1 active report) |
| 3 active reports, appeal opened, no retractions, appeal rejected | `HIGH_RISK` |
| Retraction while `UNDER_APPEAL` | status stays `UNDER_APPEAL` until the moderator decides |
| Delisted number gets 1 new independent report | `PENDING_REVIEW`, count 1 (not 1 plus the old reports) |
| Same reporter who flagged before the delist reports again | depends on option C; write the test after deciding |
| Any path above | the stored status equals the status recomputed from active reports |