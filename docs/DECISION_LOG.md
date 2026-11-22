# DECISION LOG — Ona Scam Hub

Single place for every decision that changes the plan. Newest status wins. Add a row instead of editing history; if a decision is reversed, mark the old one SUPERSEDED and link the new one.

IDs D1–D9 are the original numbering used in the planning chat. S = stack/safety rules, X = schedule mechanics, T = tracker, B = boundary.

---

## Decided

| ID | Decision | Date | Why | Revisit when |
|---|---|---|---|---|
| D9 | Project is **Ona Scam Hub** — "Ona kaye usanatumize" / "See the risk before you send" | 17 Nov 2026 | Crowd-sourced scam flagging plus Verified Merchant Shield; works from day one with no MACRA or telco integration | Only if the research evidence changes |
| S1 | Stack is locked: PostgreSQL (raw SQL), `psycopg` v3 only (`psycopg[binary,pool]`), Python + FastAPI, Pydantic v2, JWT + FastAPI Security, TypeScript, React, Next.js App Router, TanStack Query, Zod, Tailwind, Git/GitHub | 16 Nov 2026 | Learner's locked stack. Claude recommends, the learner decides | Never without the learner asking |
| S2 | **No asyncpg.** psycopg v3 with named params `%(param_name)s` and `dict_row` / `class_row` | 17 Nov 2026 | Learner's instruction; one driver means one set of concepts to master | — |
| D1 | Start **Wed 18 Nov 2026** (Week 0); finish **Sun 7 Feb 2027** (final defence) | 17 Nov 2026 | Learner confirmed start; end date moved from 31 Jan to 7 Feb | — |
| D2 | Hours: floor 3 h, **standard 4 h**, peak 5 h. Week = Mon–Fri 4, Sat 5, Sun 3 = 28 h. Light days Fri 25 Dec and Fri 1 Jan = 2 h. Total **323 h** across 12 weeks (W0 = 19 h) | 17 Nov 2026 | Learner is on holiday and full time and wants maximum depth; confirmed 4 h standard | If fatigue shows for two weeks running (see remedial/stop rules) |
| X1 | Exams: weekly checkpoint every Sunday; major 150-min exams Sun 6 Dec, 20 Dec, 3 Jan, 17 Jan, 31 Jan; final defence Sun 7 Feb (180 min). Pass 75%, below 70% triggers the remedial rule | 17 Nov 2026 | Learner delegated cadence to Claude: frequent low-stakes checks plus a major exam every two weeks | After Exam 2 if scores show the cadence is wrong |
| X2 | `roadmap.json` and `TASKS.md` are the **single source of truth** for the day-by-day schedule. Other docs point to them and never copy the day list | 17 Nov 2026 | Avoids drift between documents | — |
| T1 | Tracker is an installable **PWA** plus a tiny serverless push backend (Cloudflare Worker + Cron + KV, VAPID). Fallback if the Worker CPU limit is too tight: GitHub Actions cron + Node `web-push` | 17 Nov 2026 | One codebase for phone and laptop; no Android build and signing chain; real push notifications, not SMS | If the agent's benchmark shows the Worker cannot sign pushes within limits |
| B1 | **Boundary.** Real project code (PostgreSQL schema, FastAPI backend, pytest tests, Next.js/TypeScript frontend): Claude writes no full files and no complete solutions, only small isolated syntax examples on a toy domain. Tracker, README/architecture docs and Claude skill/instruction files: Claude may write in full | 17 Nov 2026 | Learner's exact instruction | — |
| D3 | Public wording for 1–2 reports: **"Under review — not confirmed"** plus a caution line ("Verify through another channel before sending money"). No tags, no counts, no dates. Zero reports: **"No community reports yet. This does not mean the number is safe."** | 17 Nov 2026 | Learner delegated. Avoids publishing an unverified accusation while still warning. Full copy deck in MASTER_PLAN §3.2 | After the first moderated pilot with synthetic users |
| D6 | High Risk flips **automatically** when 3+ independent accounts flag the same identifier, **plus an anomaly hold**: a burst of reports from new accounts stays PENDING_REVIEW until a moderator looks | 17 Nov 2026 | Learner delegated. Automatic keeps it working with no moderators on day one; the hold limits brigading | Week 6 when thresholds are tuned |
| S3 | **Synthetic data only** during the build. No real people's numbers | 17 Nov 2026 | Defamation and data-protection exposure | Only after a Malawian lawyer reviews |
| S4 | **No SMS provider.** OTP goes through an `OtpSender` interface; development implementation prints to the console | 17 Nov 2026 | Real SMS costs money and is out of scope | If a free, reliable route appears |

## Provisional (default chosen, learner can overrule)

| ID | Default | Needed by |
|---|---|---|
| D5 | Independence thresholds: reporter phone verified; reporter account at least 24 h old; at most 5 reports per reporter per day; reporter differs from the identifier's owner; tune in Week 6 with synthetic abuse scenarios. These numbers are placeholders, not evidence | Week 6 (28 Dec) |
| D7 | Reviews are **tag-first plus a short moderated comment**, one review per reviewer per merchant, merchants can reply. **Not yet confirmed by the learner** | Week 6 (30 Dec) before the reviews table is designed |

## Open

| ID | Question | Options | Claude's lean | Decide on |
|---|---|---|---|---|
| D4 | How are identifiers stored for lookup? | (a) raw normalised value; (b) keyed hash (HMAC) only; (c) HMAC lookup key plus restricted raw value for moderator and appeal flows | (c). Study the trade-off first (Sat 28 Nov); the learner decides | **Sat 28 Nov** |
| D8 | Hosting for Next.js, FastAPI and managed PostgreSQL | decided from free-tier terms checked on the day | none yet | Week 9 (Mon 18 Jan) |

## Superseded

| ID | What it was | Replaced by |
|---|---|---|
| — | Early plan: 16 h/week for 10 weeks, 23 Nov–31 Jan | D1, D2 |
| — | Working title "Verify Malawi" | D9 |

---

## Entry template

```
ID:
Decision:
Date:
Options considered:
Why:
Consequences:
Revisit when:
```
