# Ona Scam Hub

**Ona kaye usanatumize** — *See the risk before you send.*

Ona Scam Hub is a planned web app for Malawi. Before you send mobile money, you can check a phone number, email, social account or seller. People who have been targeted can report scam attempts, and honest sellers can earn a shareable **Verified Seller** link.

> **Status: planning (Week 0 of 12). No application code exists yet.** The build runs from Wed 18 Nov 2026 to Sun 7 Feb 2027 as a learning project. Nothing here is live, and the project will use synthetic data only; no real people's phone numbers, names or reports belong in this repository. Sections marked *planned* describe intent, not working features.

## Why

- MACRA has estimated losses of about MWK120m a month to mobile money fraud (ITWeb, 2022).
- About 10.9m mobile money wallets exist against 1.2m bank accounts (Semafor, 2023); 75% of adults use mobile money (GSMA, 2026).
- Warnings and awareness campaigns exist, but a person about to send money has no quick way to check who they are paying.
- Smartphone adoption is about 33% (GSMA 2026), so the app must be light and mobile-first.

These figures come from news and industry reports, not a primary MACRA dataset, so treat them as indicative. Full evidence and its limits are in `docs/MASTER_PLAN.md`.

## What it will do *(planned)*

| Tier | Features |
|---|---|
| Must | Phone-number lookup · report submission · risk status engine (Pending Review → High Risk) · registration and login (JWT, roles) · OTP (console sender in development) · moderation queue · appeal/unlist · privacy rules · tests · CI · live deployment |
| Should | Email, social and URL identifiers and impersonation tags · Merchant Shield (verification, public profile, share link, badge) · tag-first reviews · masked recent-flags feed · analytics |
| Could | B2B API keys and bulk check · private evidence uploads · reporter reputation · Chichewa labels · QR code for merchant link |

## How the risk status works *(planned)*

| Status | When | What the public sees |
|---|---|---|
| Unknown | no reports | "No community reports yet. This does not mean the number is safe." |
| Pending review | 1–2 independent accounts | "Under review — not confirmed." plus a caution line. No tags, counts or dates |
| High risk | 3+ independent accounts | "High Risk — Multiple Community Flags", top tags, last flagged date |
| Under appeal | owner appeal opened | neutral "Under review" banner |
| Delisted | appeal accepted | treated as unknown; audit history kept |

"Independent" means: phone-verified, counted once per identifier, not the identifier's owner, and passing anti-abuse checks. A burst of reports from brand-new accounts is held for a moderator. Some edge cases (what happens after a rejected appeal, or when a delisted number is reported again) are still **proposed, not decided**; see `docs/NOTES.md`.

## Privacy rules

1. No personal names, home addresses or unverified accusations are ever published.
2. Public output is aggregated tag counts, status, carrier and last-flagged date.
3. Reporter identity, free-text and evidence are moderator-only.
4. Public feeds show masked identifiers; full identifiers appear only on exact-match lookup.
5. Number owners can appeal and unlist after proving control by OTP.
6. Every moderator action is audited.
7. This is design guidance, not legal advice. Before any launch with real people's data, a Malawian lawyer must review it.

## Architecture *(planned)*

```
Browser: Next.js (App Router) + TypeScript + Tailwind, Zod, TanStack Query
   │
   ▼
FastAPI: Router → Pydantic → Service → Repository (raw SQL)
   │   JWT + roles · rate limiting · request IDs · exception handlers · structured logs
   ▼
psycopg v3 async pool
   │
   ▼
PostgreSQL
```

## Stack

PostgreSQL · psycopg v3 · Python · FastAPI · Pydantic v2 · JWT · TypeScript · React · Next.js · TanStack Query · Zod · Tailwind CSS · Git/GitHub.

## Progress

| Milestone | Due | Status |
|---|---|---|
| M0 Foundations (repo, README, 15 user stories, ERD v0, status model) | Sun 22 Nov | Done |
| M1 Schema v1 (learner-written schema, seed, ERD v1) | Sun 29 Nov | Not started |

Open decision: **D4**, how identifiers are stored for lookup (raw normalised value versus keyed hash), to be decided Sat 28 Nov. All decisions are in `docs/DECISION_LOG.md`.

## Repository layout

```
README.md       this file
backend/        FastAPI app, services, repositories, tests (empty until Week 3)
db/             ordered SQL migrations and seed scripts (from Week 1)
frontend/       Next.js app (empty until Week 7)
_sandbox/       30-minute practice drills, not part of the product
docs/
  MASTER_PLAN.md      product spec, business rules, privacy guardrails
  DECISION_LOG.md     every decision with date, reason and revisit-when
  NOTES.md            decision notes, ERD triage, privacy re-check, quiz results
  user-stories.md     the 15 locked user stories with acceptance criteria
  ARCHITECTURE.md     layer diagram and design choices (stub until Week 3)
  erd/                entity diagrams (erd-v0.svg now, erd-v1.svg after Week 1)
```

Adjust this list to match the files that actually exist before each commit.

## Running it

*To be written as each part is built.* Setup commands are added here only after they have been run successfully on a clean machine.

## Licence

Not chosen yet. Until one is added, the code is all rights reserved by default, even though the repository is public.