# Identifier Status Model Drill
**Date:** 2026-11-22  
**Source:** `MASTER_PLAN.md` §3.2, §3.3, §3.6  

---

## 1. Identifier State Diagram

*(Note: `VERIFIED` is excluded from this state machine because it applies to Merchant profiles, not identifiers.)*

```text
+-----------------------------------------------------------------------+

|                               UNKNOWN                                 |
|             (Default state: 0 independent reports)                    |
+-----------------------------------+-----------------------------------+
                                    |
                                    | 1st independent report
                                    v
+-----------------------------------------------------------------------+

|                            PENDING_REVIEW                             | <---( 2nd report / Anomaly hold / Mod clears hold <3 )
|      (1–2 independent reports, OR 3+ held by Anomaly Hold D6)         |
+-------------------+-----------------------------------+---------------+

                    |                                   |
   3rd independent  |                                   | Owner appeals
   report (no hold) |                                   | (via OTP)
   OR Mod clears    |                                   |
   hold (>=3 rpts)  |                                   |
                    v                                   |
+---------------------------------------+               |

|               HIGH_RISK               |               |
|  (3+ independent reports, confirmed)  |               |
+-------------------+-------------------+               |

                    |                                   |
                    | Owner appeals (via OTP)           |
                    |                                   v
                    |               +-----------------------------------+
                    +-------------> |           UNDER_APPEAL            |

                                    |   (Owner dispute open; neutral)   |
                                    +---+---------------------------+---+

                                        |                           |
       Mod rejects appeal               |                           | Mod accepts
       (reverts to prior state:         |                           | appeal
        HIGH_RISK or PENDING_REVIEW)    |                           |
                                        v                           v
                         [Reverts to prior state]   +-------------------------------+

                                                    |           DELISTED            |
                                                    | (Publicly shown as UNKNOWN;   |
                                                    |  history kept in audit log)   |
                                                    +---------------+---------------+
                                                                    |
                                                                    | New independent
                                                                    | report arrives
                                                                    v
                                                     [Moves to PENDING_REVIEW]
```

---

## 2. Allowed State Transitions (`FROM -> TO : trigger`)

* **`UNKNOWN -> PENDING_REVIEW`** : 1st independent account submits a valid report.
* **`PENDING_REVIEW -> PENDING_REVIEW`** : 2nd independent account submits a report; OR 3rd+ report arrives while an **anomaly hold** (D6) is active; OR a moderator clears an anomaly hold when the valid independent count is still under 3.
* **`PENDING_REVIEW -> HIGH_RISK`** : 3rd independent account submits a report (when no anomaly hold is active); OR a moderator manually clears an active anomaly hold when 3+ valid independent reports exist.
* **`PENDING_REVIEW -> UNDER_APPEAL`** : Verified owner (via OTP) submits an appeal while the identifier is under review.
* **`HIGH_RISK -> UNDER_APPEAL`** : Verified owner (via OTP) submits an appeal against the High Risk flag.
* **`UNDER_APPEAL -> DELISTED`** : Moderator accepts the owner's appeal.
* **`UNDER_APPEAL -> HIGH_RISK`** : Moderator rejects the owner's appeal *(see Prediction 3)*.
* **`UNDER_APPEAL -> PENDING_REVIEW`** : Moderator rejects the owner's appeal if the identifier entered appeal from `PENDING_REVIEW` *(see Prediction 3)*.
* **`DELISTED -> PENDING_REVIEW`** : A new independent account submits a fresh report after delisting *(see Prediction 4)*.

---

## 3. Predictions & Edge-Case Proposals

### Q1: Can an identifier jump from `UNKNOWN` straight to `HIGH_RISK`? What does that imply about how reports arrive?
* **Answer:** **No.** It must pass through `PENDING_REVIEW` first. This implies that reports are processed and evaluated sequentially (one event at a time) rather than batched into an instant jump, meaning the 1st and 2nd reports always establish the `PENDING_REVIEW` state before the 3rd report can trigger `HIGH_RISK`.

### Q2: What does the anomaly hold do to the arrow into `HIGH_RISK`?
* **Answer:** It **blocks the automatic transition** from `PENDING_REVIEW -> HIGH_RISK` when a suspicious burst of reports from new accounts is detected. Instead of flipping automatically on the 3rd report, the arrow loops back into `PENDING_REVIEW` and requires a manual moderator override to complete the move to `HIGH_RISK`.

### Q3: An owner appeals a `HIGH_RISK` number and a moderator rejects the appeal. Where does it go? (§3.6 doesn't say.)
* **Answer *(my proposal, not decided)*:** It should revert to **its exact pre-appeal status** (`HIGH_RISK` if it was appealed from `HIGH_RISK`, or `PENDING_REVIEW` if it was appealed from `PENDING_REVIEW`). Rejecting an appeal means the existing community flags stand, so returning it to its prior state restores the appropriate public warning without resetting the report count.

### Q4: After `DELISTED`, a new independent report arrives. What should happen, and does the old history count?
* **Answer *(my proposal, not decided)*:** It should move from **`DELISTED -> PENDING_REVIEW`** as a fresh cycle, and **the old pre-delist report count should NOT count** toward the new 3-report threshold. If old reports still counted, a single new report would immediately push a cleared number back to `HIGH_RISK` without fresh consensus. Old history stays locked in the audit log for moderator context only.
