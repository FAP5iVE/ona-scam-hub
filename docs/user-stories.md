# User Stories — Ona Scam Hub (M0, locked 22 Nov 2026)

15 stories with acceptance criteria. Roles are defined in `MASTER_PLAN.md` §2; status rules and wording are in §3.2. Anything marked *proposed, not decided* is not yet in `DECISION_LOG.md`.

---

### Story 1 — Submit Scam Report (Reporter)
* **Story:** As a reporter, I want to submit a scam report with structured tags and optional (`COULD`) private screenshots, so that I can warn others safely.
* **Acceptance:** Submitting a report increments the independent account count by 1 **only when the account is independent** (verified phone, differs from the identifier's owner, and passes anti-abuse checks per §3.3), and a second submission from the same account for the same identifier does not change the count; all optional screenshots and free-text descriptions remain strictly moderator-only.

### Story 2 — Exact-Match Lookup (Visitor)
* **Story:** As a visitor, I want to look up a phone number, email, or handle before sending money, so that I can see if there are community risk flags without exposing personal names.
* **Acceptance:** An exact-match lookup displays:
  * **`UNKNOWN`:** *"No community reports yet. This does not mean the number is safe."* (no tags, counts, or dates);
  * **`PENDING_REVIEW`:** *"Under review — not confirmed. Verify through another channel before sending money."* (no tags, counts, or dates);
  * **`HIGH_RISK`:** *"High Risk — Multiple Community Flags"*, plus top tags, carrier, and last-flagged date;
  * **All states:** never contains a personal name, home address, or reporter identity.
* **Note:** `UNDER_APPEAL` and `DELISTED` results are covered by Stories 10 and 15 and `MASTER_PLAN.md` §3.2.

### Story 3 — Business Verification (Merchant)
* **Story:** As a merchant, I want to verify my phone by OTP and submit business registration details, so that I get a shareable profile badge that shows I passed verification.
* **Acceptance:** Passing OTP verification and moderator business review updates the merchant's badge and generates a shareable profile link, while keeping registration documents private and still allowing community flags to appear if reported.

### Story 4 — Review Held Items, Appeals & Overrides (Moderator)
* **Story:** As a moderator, I want to review held items, private evidence, and owner appeals, and apply manual overrides when needed, so that identifier statuses stay accurate and fair.
* **Acceptance:** Every moderator decision on a held item, owner appeal, or status override updates the identifier's public state accordingly and permanently records the moderator's ID, timestamp, and reason in the audit log.

### Story 5 — Manage Moderators & Audit Log (Admin)
* **Story:** As an admin, I want to manage moderator accounts and view the audit log, so that I can ensure platform integrity and track system activity.
* **Acceptance:** Granting or revoking moderator permissions updates the user's role in the database *(revisit in Week 5, JWT — token expiry/revocation timing)*, and the audit log displays a read-only, non-deletable history of all moderator actions and status changes.

### Story 6 — Masked Recent-Flags Feed (Visitor)
* **Story:** As a visitor, I want to view a public feed of identifiers **flagged by multiple accounts**, so that I stay aware of active scam trends without exposing full numbers or personal names.
* **Acceptance:** The feed lists **`HIGH_RISK` identifiers only** (never `PENDING_REVIEW` or `UNDER_APPEAL`), showing masked identifiers, top tags, carrier, and last-flagged date — never full identifiers, personal names, or reporter identities.
* **Masking rule *(proposed, not decided)*:** For Malawi phone numbers (`+265` + 9 digits), reveal only the country code, the 2-digit carrier prefix, and the last 2 digits, masking the 5 middle digits (e.g., `+265 99* *** *12`).
* **Notes:**
  * The rule covers phone numbers only. Masks for email, social handle and URL are not yet defined, so until then the feed lists PHONE identifiers only.
  * The carrier-prefix assumption must be verified in Week 1 against the official numbering plan before it is relied on.
  * Masking alone does not stop enumeration (100,000 candidates per mask is small). The real defence is the mask together with the Story 7 rate limit.

### Story 7 — Anti-Scraping & Rate Limits *(Non-Functional Requirement)*
* **Requirement:** Lookup endpoints must enforce rate limits per IP and session, so that automated scrapers cannot enumerate the database of identifiers.
* **Acceptance:** Exceeding the lookup threshold returns an HTTP `429 Too Many Requests` response, and the `429` error payload never reveals whether the queried identifier exists in the database.

### Story 8 — Manage Own Reports (Reporter)
* **Story:** As a reporter, I want to view and retract my own submitted reports, so that I can withdraw an accidental flag.
* **Acceptance:** Retracting a report **marks the row as `retracted`** (never deleted, preserving audit history) and removes it from the active independent count; if the identifier is not `UNDER_APPEAL` and active independent reports drop below 3, its status reverts from `HIGH_RISK` to `PENDING_REVIEW` (or `UNKNOWN` if 0); if the identifier is currently `UNDER_APPEAL`, the status remains `UNDER_APPEAL` until the moderator decides.
* **Design note *(proposed, not decided)*:** Because a reporter can retract while an identifier is `UNDER_APPEAL`, when a moderator later rejects the appeal, the system should **recompute the status from active reports** rather than blindly restoring `prior_status`.

### Story 9 — Brand Impersonation Tagging (Reporter)
* **Story:** As a reporter, I want to optionally specify an impersonated brand when submitting a report, so that buyers know the scammer is pretending to be a legitimate company.
* **Acceptance:** When an impersonated brand is selected, it appears as an aggregated tag on `HIGH_RISK` exact-match lookups without exposing any private free-text notes or reporter info.

### Story 10 — Submit Appeal / J4 (Identifier Owner)
* **Story:** As an identifier owner, I want to prove control of my phone number via OTP and submit an appeal with a reason, so that I can contest an inaccurate or outdated risk status.
* **Acceptance:** Completing OTP verification and submitting a required written reason for a `PENDING_REVIEW` or `HIGH_RISK` number opens an appeal, moves the status to `UNDER_APPEAL`, and replaces public warning tags with a neutral "Under review" banner.

### Story 11 — Tag-First Merchant Reviews (Reporter) *(Proposed — pending D7)*
* **Story:** As a Reporter (phone-verified user), I want to leave a tag-first review on a merchant's profile, so that other buyers know whether the seller delivered as promised.
* **Acceptance:** A phone-verified reporter can submit at most one review per merchant using structured experience tags plus an optional short comment, containing no personal names of individuals.

### Story 12 — Reply to Reviews (Merchant)
* **Story:** As a merchant, I want to post a public reply to reviews on my business profile, so that I can address customer feedback or clarify misunderstandings.
* **Acceptance:** A verified merchant can post one reply per published review on their own profile, and the reply displays directly beneath that review without exposing private reviewer contact details. *(Optional: a moderator can hide or remove an abusive reply — see ERD note 8.)*

### Story 13 — Remove Defamatory Reviews (Moderator)
* **Story:** As a moderator, I want to remove or reject reviews that name specific individuals or make personal accusations, so that the platform complies with defamation and privacy guardrails.
* **Acceptance:** Rejecting or removing a review hides it from the merchant's public profile immediately and records the moderator's ID, timestamp, and reason in the audit log.

### Story 14 — Anomaly Hold Override (Moderator)
* **Story:** As a moderator, I want to review identifiers held by an automatic anomaly hold and manually confirm or reject the suspicious report burst, so that coordinated fake reports don't falsely flag innocent numbers.
* **Acceptance:** **Confirming** the reports clears the anomaly hold and moves an identifier with 3+ valid independent reports from `PENDING_REVIEW` to `HIGH_RISK`; **rejecting** the burst marks those reports invalid, clears the hold, and leaves the identifier in `PENDING_REVIEW` (if 1–2 valid reports remain) or reverts it to `UNKNOWN` (if 0 valid reports remain), logging both paths in the audit log.

### Story 15 — Contextual Help & Conditional Appeal Link (Visitor)
* **Story:** As a visitor, I want every non-`UNKNOWN` lookup result to include a link to "How this works" and an appropriate appeal action or status, so that buyers understand how risk levels work and owners know where an appeal stands.
* **Acceptance:** Any lookup returning `PENDING_REVIEW`, `HIGH_RISK`, or `UNDER_APPEAL` renders a link to "How this works"; `PENDING_REVIEW` and `HIGH_RISK` results show an "Open an appeal" link, whereas `UNDER_APPEAL` does **not** show "Open an appeal" (showing "Appeal in progress" instead) and `UNKNOWN` shows neither.


add