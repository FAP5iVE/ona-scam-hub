# MASTER PLAN — Ona Scam Hub

**Ona kaye usanatumize** — *See the risk before you send.*

Owner: the learner. Mentor/tutor: Claude (Sonnet 5.5). Window: **Wed 18 Nov 2026 to Sun 7 Feb 2027** (12 weeks, W0–W11).
Status: **v2, decisions D1, D2, D3, D6 and D9 resolved.** Open items are in section 14 and in `DECISION_LOG.md`.
The day-by-day schedule lives in `TASKS.md` and `roadmap.json`, not here.

---

## 1. Mission and evidence

**Mission:** let ordinary Malawians check a phone number, email, social account or seller BEFORE sending mobile money, and let victims and targets report scam attempts as they happen, so protection exists on day one without waiting for MACRA or telcos to integrate.

**Why it is a real gap (from the research log):**
- MACRA has estimated losses of about MWK120m a month to mobile money fraud (ITWeb, 2022). About 10.9m mobile money wallets exist against 1.2m bank accounts (Semafor, 2023), and 75% of adults use mobile money (GSMA, Aug 2026).
- Fraud has shifted toward hacked WhatsApp accounts, fake messages and fake prizes (Developing Telecoms, 2026). Fake job adverts and trafficking recruit through Facebook and WhatsApp (Zodiak; World Vision notice 2024).
- Operator and regulator responses are mostly warnings and awareness. In Oct 2026 the government said it plans tracing laws, and reports gave no nationwide totals of victims or losses (Rio Times, Oct 2026).
- Many victims could not afford legal redress (Semafor, 2023).
- Reach constraint: smartphone adoption is 33% and unique mobile internet penetration 12.5% (GSMA 2026), so the web app must be light, fast and mobile-first.

**Limits of this evidence:** no direct Reddit, X or Facebook threads surfaced in the searches; some sources are undated; the figures come from news and industry reports rather than a primary MACRA dataset. Treat the numbers as indicative.

**Differentiator:** crowd-sourced (Truecaller-style) reporting plus a positive side, the Verified Merchant Shield, so honest sellers can prove legitimacy with a shareable profile link.

---

## 2. Users, roles and journeys

| Role | Who | Can do |
|---|---|---|
| Visitor | anyone | look up an identifier; view a merchant profile |
| Reporter | phone-verified user | submit reports; manage own reports |
| Merchant | verified seller | create/verify business profile; reply to reviews |
| Moderator | trusted staff | review pending reports, evidence, appeals; override statuses |
| Admin | project owner | manage moderators, view analytics, audit log |

**J1 Buyer lookup (home page):** paste a number, email or handle, instantly see Risk Level, Top Reported Tags, Last Flagged Date. No names.
**J2 Victim/target report:** log in with a verified phone, choose identifier type, channel and scam tags, optionally mark impersonation of a brand, submit.
**J3 Merchant verification:** verify phone by OTP, submit business registration details, a moderator verifies, the merchant gets a profile URL and badge to share in WhatsApp/Facebook chats.
**J4 Owner appeal/unlist:** the number's owner proves control by OTP, submits an appeal, a moderator decides, the outcome is logged.
**J5 Moderator review:** claim items from a queue, view private evidence, accept/reject, every action audited.

---

## 3. Business rules (the contract; change only by a decision-log entry)

### 3.1 Identifiers
Types: PHONE (Malawi numbers, canonical international form), EMAIL, SOCIAL (platform + handle or profile URL), URL/DOMAIN. Each type has normalisation rules (case-folding, stripping punctuation and tracking parameters, converting local number formats to canonical form). Normalisation lives in ONE place per layer and is covered by tests with messy real-world inputs.
Carrier is derived from the number prefix. The official numbering plan must be researched and verified before coding; do not assume prefixes.

### 3.2 Status model and public wording (D3, D6 resolved)

| Status | Trigger | Public display |
|---|---|---|
| UNKNOWN | no reports | "No community reports yet. This does not mean the number is safe." |
| PENDING_REVIEW | 1–2 independent reporting accounts | "Under review — not confirmed." plus "Verify through another channel before sending money." No tags, no counts, no dates |
| HIGH_RISK | 3+ independent accounts flag the same identifier | "High Risk — Multiple Community Flags" plus top tags and last flagged date |
| UNDER_APPEAL | owner appeal opened | neutral "Under review" banner |
| DELISTED | appeal accepted | treated as UNKNOWN; kept in the audit log |
| VERIFIED (merchants) | phone + business verification passed | badge level on the profile; does NOT block community flags |

**Copy rules:** state only what the data supports ("reported by several accounts", never "is a scammer"); never imply a person's guilt; never show a count below the High Risk threshold; every non-UNKNOWN result links to "How this works" and to the appeal route.

**Automatic flip with anomaly hold (D6):** the status flips to HIGH_RISK automatically when 3+ independent accounts flag the same identifier, UNLESS the anomaly hold applies. A burst of reports from new accounts keeps the identifier in PENDING_REVIEW until a moderator looks.

### 3.3 "Independent accounts"
A reporter counts once per identifier. Counted accounts must have a verified phone, must differ from the identifier's owner, and pass anti-abuse checks (account age, report rate, clustering) designed in Week 6. The provisional thresholds in `DECISION_LOG.md` (D5) are placeholders to tune with synthetic abuse scenarios.

### 3.4 Reports
Structured: identifier, type, channel (call, SMS, WhatsApp, Facebook, email, other), tags (e.g., reversal scam, fake prize, fake job, impersonation, fake seller, SIM-swap attempt), optional impersonated brand. Free-text descriptions and screenshots are PRIVATE (moderator-only), never public.

### 3.5 Merchant Shield and reviews
Badge levels: Unverified → Phone-verified → Business-verified → Trusted (thresholds from review volume and quality, set later). Reviews (D7, default pending confirmation) are tag-first (structured experiences such as "delivered as described", "item not as described", "no delivery") plus a short moderated comment; one review per reviewer per merchant; merchants can reply; moderators remove accusations of named individuals.

### 3.6 Appeals
Only the number's owner (proved by OTP) can appeal. An appeal moves status to UNDER_APPEAL, a moderator decides through a defined process, and every step is audited. Delisting never erases audit history.

---

## 4. Privacy, defamation and legal guardrails

This is design guidance, NOT legal advice. The learner named a "Defamation & Data Protection Act (2024)"; I could not verify a statute by that title. Public sources show Malawi's Data Protection Bill passed Parliament in Dec 2023, with a Data Protection Authority being set up at MACRA (World Bank, Jun 2025). Defamation is a separate legal area. Before ANY public launch with real people's data, a Malawian lawyer must review.

**Design rules (non-negotiable in this build):**
1. Never publish personal names, home addresses or unverified accusations. Public output is aggregated tag counts, status, carrier and last-flagged date.
2. Reporter identity is never public. Free text and evidence are moderator-only.
3. Public "recent flags" feeds show MASKED identifiers only; full identifiers appear only on exact-match lookup.
4. Data minimisation and retention: decide what is stored, why and for how long (decision log, Week 1).
5. Lookup abuse defence: rate limits and anti-scraping so the database cannot be enumerated.
6. Every moderator action is audited.
7. During the learning build, use SYNTHETIC data only. No real people's numbers.
8. Lookup-versus-storage design (raw normalised value versus a keyed hash) is a Week 1 architecture decision (D4); study the trade-off first, decide Sat 28 Nov.

---

## 5. Architecture (aligned to the locked stack)

```
Browser (Next.js App Router + TypeScript + Tailwind)
   |  Zod validates forms and API responses
   |  TanStack Query: fetching, caching, mutations
   v
FastAPI (Python)
   Router -> Pydantic validation -> Service (business rules) -> Repository (raw SQL)
   Cross-cutting: JWT auth + RBAC dependencies, rate limiter, request-ID middleware,
                  domain exceptions -> global handlers, structured logging
   v
psycopg v3 async connection pool (named params %(name)s, dict_row / class_row)
   v
PostgreSQL (constraints, indexes, pg_trgm, triggers/audit, locking)
```
Trace to drill in every feature: Request → Router → Pydantic → Service → Repository → psycopg → PostgreSQL → Response, and back.

**Conceptual entities (the learner designs columns, types and constraints in Week 1; Claude reviews):** users (reporters/merchants/moderators), phone verifications/OTPs, identifiers, reports, tag catalogue, brands (for impersonation), merchants, merchant verification submissions, reviews, appeals, moderation actions/audit log, refresh-token/revocation records, rate-limit counters, evidence file metadata.

---

## 6. Scope tiers and cut order

**MUST:** phone-number lookup with normalisation; report submission; status engine (Pending → High Risk); registration/login with JWT + roles; OTP service (console sender in dev); moderation queue; appeal/unlist; privacy rules; tests; CI; live deployment.
**SHOULD:** email/social/URL identifiers and impersonation tags; Merchant Shield (verification, public profile, share link, badge); tag-first reviews; masked recent-flags feed; analytics dashboard.
**COULD:** B2B API keys and bulk-check endpoint (rate-limited); private evidence uploads with redaction notes; reporter reputation weighting; Chichewa labels; QR code for the merchant link; CSV export for regulators.
**If behind, cut in this order:** COULD items → analytics → reviews → email/social types (keep phone + impersonation) → merchant document step.

---

## 7. Advanced concepts curriculum (taught from zero assumptions, then pushed deep)

- **PostgreSQL:** normalisation, constraints (CHECK/UNIQUE/FK/partial unique), CTEs, window functions, recursive CTEs (linked-identifier clusters), B-tree/partial/composite indexes, EXPLAIN ANALYZE, pg_trgm + GIN fuzzy search, transactions and isolation levels, row locking (FOR UPDATE / SKIP LOCKED for the review queue), triggers and audit tables, materialised views, JSONB use and misuse, COPY for bulk seed, migrations as ordered SQL files.
- **psycopg v3:** async connection pool, named parameters, dict_row/class_row, transaction blocks, error classes (e.g., unique violations), timeouts, server-side cursors for exports.
- **Python:** OOP (classes, self, instantiation, dataclasses, ABC/Protocol, composition vs inheritance, dependency inversion), context managers, typing and generics, custom exception hierarchy, async/await, decorators, structured logging (standard library).
- **FastAPI + Pydantic v2:** routers, dependency injection, lifespan, middleware, global exception handlers, response models, validators, custom Malawi phone type, discriminated unions, settings, OpenAPI, uploads, keyset pagination.
- **Security/auth:** password hashing, JWT access+refresh with rotation and revocation, RBAC, OTP design (expiry, attempts, sender interface), rate limiting and brute-force/anti-enumeration defences, OWASP Top 10 mapping, CORS/CSRF with cookies, secrets handling.
- **Testing:** pytest, fixtures, factories, test database, async tests, at least 2 tests per service method/query (happy + failure), integration tests through the API.
- **TypeScript/React/Next.js:** types, narrowing, generics, utility types; components/state/effects; App Router, server vs client components, layouts, loading/error files, dynamic routes, generateMetadata (link previews), revalidation, middleware.
- **Zod + TanStack Query:** schemas, transforms, refinements, discriminated unions, z.infer; queries, mutations, invalidation, optimistic updates, infinite queries, prefetch + hydration.
- **Tailwind:** mobile-first, design tokens, accessibility, dark mode, component variants without extra libraries.
- **Git/GitHub:** branching, conventional commits, PR discipline, tags per milestone, rebase, bisect, GitHub Actions CI with a Postgres service.

---

## 8. Calendar and hours

### 8.1 Intensity tiers (full time, on holiday)
- **Floor day:** 3 h. **Standard day:** 4 h. **Peak day:** 5 h.
- **Weekly standard:** Mon–Fri 4 h, Sat 5 h, Sun 3 h = **28 h**.
- Light days: Fri 25 Dec and Fri 1 Jan = 2 h each.
- **Total planned: 323 h** (W0 = 19 h; W5 and W6 = 26 h; every other week = 28 h). Quality beats hours: if focus drops, stop and log it; do not pad.

### 8.2 Daily templates
**Standard weekday (240 min):** 20 warm-up (predict output / find the bug) · 50 study from official docs + notes in your own words · 30 sandbox drill · 90 build in the real repo · 30 test/debug/code-read · 20 wrap-up (commit, NOTES.md entry, tick tracker).
**Saturday (300 min):** longer build block. **Sunday (180 min):** 60 weekly checkpoint, then fix weak spots, architecture notes, plan next week.
**Major-exam Sunday:** 150 min exam + 30 min review. Use a 50/10 focus/break cadence; breaks are not counted in these minutes.

### 8.3 Exams
- **Weekly checkpoint (60 min, Sundays):** predict-the-output, bug-hunt, one small build.
- **Major exams (150 min): Sun 6 Dec, 20 Dec, 3 Jan, 17 Jan, 31 Jan.** A 30 min code reading · B 30 min debug a seeded bug from a traceback · C 75 min build from a spec in `_sandbox/` with official docs only · D 15 min written explanation. Weights 20/20/45/15.
- **Final defence (Sun 7 Feb, 180 min):** live demo, code walkthrough, "break it" session, architecture Q&A.
- **Scoring:** 75% passes. 70–74% means redo only the weak section. Below 70% triggers the remedial rule: the next week adds four 60-min remedial blocks and no new advanced topics until a redo scores 80%+.

### 8.4 Week table
| Wk | Dates | Hours | Theme | Exam |
|---|---|---|---|---|
| 0 | Wed 18 – Sun 22 Nov | 19 | Setup, Git, SQL basics, requirements | quiz |
| 1 | 23 – 29 Nov | 28 | Relational design, DDL, core SQL, schema v1 | checkpoint |
| 2 | 30 Nov – 6 Dec | 28 | Advanced SQL, indexing, transactions, psycopg intro | **EXAM 1** |
| 3 | 7 – 13 Dec | 28 | Python OOP, async DB layer, repositories, logging, pytest | checkpoint |
| 4 | 14 – 20 Dec | 28 | FastAPI, Pydantic v2, services, lookup+report API | **EXAM 2** |
| 5 | 21 – 27 Dec | 26 | Auth, JWT, OTP, RBAC, rate limiting | checkpoint |
| 6 | 28 Dec – 3 Jan | 26 | Moderation, risk engine, appeals, merchants (backend) | **EXAM 3** |
| 7 | 4 – 10 Jan | 28 | TypeScript, React, Next.js, Tailwind UI shell | checkpoint |
| 8 | 11 – 17 Jan | 28 | Zod, TanStack Query, auth in Next, lookup+report UI | **EXAM 4** |
| 9 | 18 – 24 Jan | 28 | Merchant Shield UI, moderation UI, appeals, analytics | checkpoint |
| 10 | 25 – 31 Jan | 28 | Hardening, CI, deployment, privacy/security docs | **EXAM 5** |
| 11 | 1 – 7 Feb | 28 | Polish, stretch, docs, FINAL DEFENCE (Sun 7 Feb) | **DEFENCE** |

### 8.5 Day-by-day schedule
**Single source of truth: `TASKS.md` (human-readable) and `roadmap.json` (for the tracker).** Both are generated from one script (459 items, 323 h, every week's total checked against the table above). This plan does not repeat the day list, so the documents cannot drift apart. If the schedule changes, regenerate both files.

---

## 9. Milestones and deliverables

| # | Date | Milestone | Acceptance |
|---|---|---|---|
| M0 | 22 Nov | Foundations | env runs; GitHub repo; README stub; 15+ user stories; ERD v0 |
| M1 | 29 Nov | Schema v1 | learner-written schema + seed; ERD v1; 30 practice queries |
| M2 | 6 Dec | SQL mastery | risk-status + review-queue queries with EXPLAIN evidence; Exam 1 ≥75% |
| M3 | 13 Dec | Data layer | Database manager + repositories + exceptions + logging + tests |
| M4 | 20 Dec | Public API | lookup + report API with tests; Exam 2 ≥75% |
| M5 | 27 Dec | Auth & security | JWT/refresh, RBAC, OTP, rate limiter, threat-model notes |
| M6 | 3 Jan | Backend MVP | moderation, appeals, merchants, reviews; coverage target; Exam 3 ≥75% |
| M7 | 10 Jan | UI shell | navigable app + component kit + design notes |
| M8 | 17 Jan | Integrated core | lookup/report/login working end to end; Exam 4 ≥75% |
| M9 | 24 Jan | Feature complete | all MUST + SHOULD features in UI |
| M10 | 31 Jan | Live & hardened | deployed URL, CI green, security + privacy docs; Exam 5 ≥75% |
| M11 | 7 Feb | Defended | final docs, demo, defence passed |

**Definition of Done (every feature):** sandbox drill done → you wrote the code → at least 2 pytest tests (happy + failure) → domain exceptions + structured logging → no bare try/except → NOTES.md decision entry for anything tricky → committed with a clear message → ticked in the tracker.

---

## 10. Learning protocol (Tutor Rule)

Full rules: `MASTER_PROMPT.md`. In short:
- Claude explains concepts, defines new terms before using them, shows small isolated syntax examples on a toy domain, traces execution flow, and reviews code YOU write. Claude does NOT write full files or complete solutions for the real project (schema, FastAPI backend, pytest tests, Next.js/TypeScript frontend).
- Best-practice, explicit style first; shortcuts shown afterwards as a comparison.
- Class topics always cover: blueprint idea, attributes vs methods, inheritance, instantiation and `self` in that exact case.
- **Sandbox drill (30 min) before every complex feature**, then apply to the real file.
- **Debugging:** read tracebacks bottom-up; name the failing layer (PostgreSQL / Python-FastAPI / Zod-Next.js); inspect the variable; hints before fixes.
- **NOTES.md entry template:** Context · Options considered · Decision · Consequences · How to test.
- **Git:** branch per feature, conventional commits, small commits, tag each milestone (m1…m11).
- **Wellbeing:** sleep ≥7 h, a daily walk, stop when quality drops; fatigue is logged, not hidden.
- The stack is locked; Claude recommends and the learner decides.

---

## 11. Tools and accounts (free only)

**Backend:** Python 3.12+; fastapi; uvicorn; pydantic v2 + pydantic-settings; `psycopg[binary,pool]` (ONLY driver, no asyncpg); PyJWT; a password-hashing library (decide in W5, e.g., argon2-cffi); python-multipart (uploads); pytest; pytest-asyncio; httpx.
**Frontend:** Node.js LTS; next; react; react-dom; typescript; @tanstack/react-query; zod; tailwindcss (plus whatever its current setup requires).
**Database/dev:** PostgreSQL 16+ with the pg_trgm extension, psql, VS Code, Git, GitHub (+ Actions).
**Accounts:** GitHub; hosting for Next.js, FastAPI and managed PostgreSQL chosen in Week 9 (D8; verify free-tier terms that day). **No SMS provider** (OTP is printed to the console in dev).
**Ask-first extras (not in the locked stack):** linters/formatters, a frontend test runner, a QR-code library, logging libraries.
The separate tracker app is specified in `TRACKER_BUILD_BRIEF.md`.

**Official docs (links not yet tested from the planning environment):** PostgreSQL https://www.postgresql.org/docs/current/ · EXPLAIN https://www.postgresql.org/docs/current/using-explain.html · Isolation https://www.postgresql.org/docs/current/transaction-iso.html · Locking https://www.postgresql.org/docs/current/explicit-locking.html · pg_trgm https://www.postgresql.org/docs/current/pgtrgm.html · psycopg 3 https://www.psycopg.org/psycopg3/docs/ · FastAPI https://fastapi.tiangolo.com · Pydantic https://docs.pydantic.dev · PyJWT https://pyjwt.readthedocs.io · argon2-cffi https://argon2-cffi.readthedocs.io · pytest https://docs.pytest.org · pytest-asyncio https://pytest-asyncio.readthedocs.io · HTTPX https://www.python-httpx.org · TypeScript https://www.typescriptlang.org/docs/ · React https://react.dev · Next.js https://nextjs.org/docs · TanStack Query https://tanstack.com/query/latest · Zod https://zod.dev · Tailwind https://tailwindcss.com/docs · Git https://git-scm.com/doc · OWASP Top 10 https://owasp.org/www-project-top-ten/

---

## 12. Risks and mitigations
| Risk | Mitigation |
|---|---|
| Defamation / data-protection exposure | synthetic data only; masked public feeds; no names; lawyer review before real launch |
| Brigading / false reports | independence rule, anomaly hold, rate limits, moderator override, appeals |
| Cold start (no reports) | seeded synthetic data for the demo; clear "no reports ≠ safe" wording |
| Scraping / enumeration | rate limits, exact-match lookup, masked feeds |
| Scope creep | tiers + cut order (section 6) |
| Fatigue at 28 h/week | floor/standard/peak days, stop rule, remedial rule |
| Free-tier changes | verify at deployment time; keep deploy scripts simple |
| OTP cost | console sender behind an interface; real SMS out of scope |

---

## 13. Companion documents
`TASKS.md` and `roadmap.json` (schedule) · `DECISION_LOG.md` · `MASTER_PROMPT.md` (learning chat) · `PROGRESS.md` (state) · `HANDOFF.md` · `README.md` (for the repo) · `TRACKER_BUILD_BRIEF.md` · the `ona-tutor` Claude skill (proposed separately; the learner saves it).

## 14. Decisions
**Resolved:** D1 start Wed 18 Nov · D2 standard 4 h/day · D3 public wording for 1–2 reports (section 3.2) · D6 automatic flip with anomaly hold · D9 name Ona Scam Hub.
**Open or provisional:** D4 identifier storage — decide **Sat 28 Nov** · D5 independence thresholds — provisional, tune in Week 6 · D7 reviews tag-first — default, not yet confirmed · D8 hosting — Week 9.
