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